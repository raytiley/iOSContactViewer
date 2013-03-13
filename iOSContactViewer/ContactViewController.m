//
//  ContactViewController.m
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/12/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactEditViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize contact;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(editButtonSelected:)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    return self;
}

- (void)editButtonSelected:(id)sender {
    ContactEditViewController* edit = [[ContactEditViewController alloc] initWithNibName:@"ContactEditViewController" bundle:nil];
    
    [edit setContact:self.contact];
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 1; // We always have 1 section
    if([contact.phones count] > 0)
        sections++;
    
    if([contact.emails count] > 0)
        sections++;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString* sec = [self sectionToContent:section];
    
    if([sec isEqualToString:@"Contact Details"])
        return 2;
    
    if([sec isEqualToString:@"Phones"])
        return [contact.phones count];
    
    if([sec isEqualToString:@"Emails"])
        return [contact.emails count];
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self sectionToContent:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell.textLabel setText:@""];
    NSString* section = [self sectionToContent:indexPath.section];
    
    if([section isEqualToString:@"Contact Details"])
    {
        if(indexPath.row == 0)
            [cell.textLabel setText:contact.name];
        else
            [cell.textLabel setText:contact.title];
    }
    if([section isEqualToString:@"Phones"])
        [cell.textLabel setText:[contact.phones objectAtIndex:indexPath.row]];
    
    if([section isEqualToString:@"Emails"])
        [cell.textLabel setText:[contact.emails objectAtIndex:indexPath.row]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSString *)sectionToContent:(NSInteger)section
{
        if(section == 0)
            return @"Contact Details";
    
        if(section == 1 && contact.phones.count > 0)
            return @"Phones";
    
        return @"Emails";
    
}

@end
