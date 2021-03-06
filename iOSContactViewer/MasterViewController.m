//
//  MasterViewController.m
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/5/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import "MasterViewController.h"

#import "ContactRepository.h"
#import "Contact.h"
#import "ContactViewController.h"
#import "MSSEGravatarManager.h"

@interface MasterViewController () {
    
}
@end

@implementation MasterViewController

UISearchBar* searchBar;
NSArray* filteredContacts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Contacts", @"Contacts");
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        searchBar.delegate = self;
        
        self.tableView.tableHeaderView = searchBar;
    }
    return self;
}
         
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
 {
     [searchBar resignFirstResponder];
 }

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    filteredContacts = [[ContactRepository getContactRepository] allContacts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [searchBar resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!self.contactViewController) {
        self.contactViewController = [[ContactViewController   alloc] init];
    }
    Contact* contact = [[ContactRepository getContactRepository] createNewContact];
    self.contactViewController.contact = contact;
    self.contactViewController.editing = YES;
    [self.navigationController pushViewController:self.contactViewController animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredContacts count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }

    Contact *contact = [filteredContacts objectAtIndex:indexPath.row];
    cell.textLabel.text = [contact name];
    [[cell imageView] setImage:[MSSEGravatarManager getGravatarImageForEmail:[contact defaultEmail]]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactRepository* contacts = [ContactRepository getContactRepository];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Contact* contactToRemove = [filteredContacts objectAtIndex:indexPath.row];
        
        //We need to remove the contact from the repo first, so that then we can update the filter
        [contacts deleteContact:contactToRemove];
        filteredContacts = [self filterContactsBy:searchBar.text];
        
        //remove the row
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    filteredContacts = [self filterContactsBy:searchText];
    [self.tableView reloadData];
}

-(NSArray*)filterContactsBy:(NSString *)searchText
{
    NSArray* contacts = [[ContactRepository getContactRepository] allContacts];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    if(!searchText || [searchText isEqualToString:@""])
        return contacts;
    
    for(int i = 0; i < [contacts count]; i++)
    {
        NSRange r = [[[contacts objectAtIndex:i] name] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(r.location != NSNotFound)
        {
            [results addObject:[contacts objectAtIndex:i]];
        }
    }
    return results;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet* actionSheet =[[UIActionSheet alloc]
                                 initWithTitle:@"Action"
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"Call", @"Text", @"Email", nil];
    
    // Since we only have one section, the index path row is the index of our contact
    // Set it as the tag on the action shee so we know what contact to act on.
    [actionSheet setTag:indexPath.row];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the contact
    Contact* contact = [filteredContacts objectAtIndex:actionSheet.tag];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Call"]) {
        NSLog(@"Call button pressed");
        if ([[device model] isEqualToString:@"iPhone"]) {
            NSString *phoneNumber = [NSString stringWithFormat: @"tel://%@", contact.defaultCallPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
        else {
            UIAlertView *NotPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [NotPermitted show];
        }
    }
    if ([buttonTitle isEqualToString:@"Text"]) {
        NSLog(@"Text button pressed");
        if ([[device model] isEqualToString:@"iPhone"]) {
            NSString *phoneNumber = [NSString stringWithFormat: @"sms://%@", contact.defaultTextPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
        else {
            UIAlertView *NotPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [NotPermitted show];
        }
    }
    if ([buttonTitle isEqualToString:@"Email"]) {
        NSLog(@"Email button pressed");
        NSString *emailAddress = [NSString stringWithFormat: @"mailto:%@", contact.defaultEmail];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailAddress]];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel button pressed");
    }
        
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
     if (!self.contactViewController) {
         self.contactViewController = [[ContactViewController   alloc] init];
     }
     Contact* contact = [filteredContacts objectAtIndex:indexPath.row];
     self.contactViewController.contact = contact;
     [self.navigationController pushViewController:self.contactViewController animated:YES];
     
}

@end
