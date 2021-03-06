//
//  ContactViewController.m
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/12/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import "ContactViewController.h"
#import "MSSETableViewCell.h"
#import "ContactRepository.h"
#import "MSSEGravatarManager.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize contact;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
        [[self tableView] setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    ContactRepository* repo = [ContactRepository getContactRepository];
    if([[repo allContacts] containsObject:contact] == NO)
    {
        [repo addNewContact:contact];
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger row = 0;
    NSInteger section = 0;
    NSInteger tag = textField.tag;
    if(tag == 1000 || tag == 1001) {
        section = 0;
        row = tag - 1000;
    } else if (tag >= 2000 && tag < 2000) {
        section = 1;
        row = tag - 2000;
    } else if (tag >= 3000 && tag < 4000) {
        section = 2;
        row = tag - 3000;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.isEditing) {
        [self setEditing:NO animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    if(self.isEditing == NO) {
    NSInteger sections = 1; // We always have 1 section
        if([contact.phones count] > 0)
            sections++;
        
        if([contact.emails count] > 0)
            sections++;
        
        return sections;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isEditing == NO) {
        //If we aren't editing we might not have all sections
        NSString* sec = [self sectionToContent:section];
        
        if([sec isEqualToString:@"Contact Details"])
            return 2;
        
        if([sec isEqualToString:@"Phones"])
            return [contact.phones count];
        
        if([sec isEqualToString:@"Emails"])
            return [contact.emails count];
    } else {
        // If we are editing we always have at least one row for the add button
        
        switch (section) {
            case 0:
                return 2; // Name and Title
            case 1:
                return [[contact phones] count] + 1;
            case 2:
                return [[contact emails] count] + 1;
            default:
                return 0;
        }
    }
    // Never get here:
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.isEditing == NO)
    {
        return [self sectionToContent:section];
    } else {
        switch (section) {
            case 0:
                return @"Contact Details";
            case 1:
                return @"Phones";
            case 2:
                return @"Emails";
        }
    }
    return @"Never Get Here";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(self.isEditing == NO) {
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        [cell.textLabel setText:@""];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        NSString* section = [self sectionToContent:indexPath.section];
        
        if([section isEqualToString:@"Contact Details"])
        {
            //Don't allow selecting
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
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
    } else {
        
        NSString *reuseIdentifier;
        switch (indexPath.section) {
            case 0:
                reuseIdentifier = @"ContactDetailsEditCell";
                break;
            case 1:
                if(indexPath.row == [[contact phones] count])
                    reuseIdentifier = @"NewPhoneCell";
                else
                    reuseIdentifier = @"PhoneEditCell";
                break;
            case 2:
                if(indexPath.row == [[contact emails] count])
                    reuseIdentifier = @"NewEmailCell";
                else
                    reuseIdentifier = @"EmailEditCell";
                break;
            default:
                break;
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if(!cell) {
            cell = [[MSSETableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        //Configure Cell
        if([reuseIdentifier isEqualToString:@"ContactDetailsEditCell"]) {
            UITextField *textField =(UITextField *) [[[cell contentView] subviews] objectAtIndex:0];
            [textField setDelegate:self];
            [textField setReturnKeyType:UIReturnKeyDone];
            if(indexPath.row == 0) {
                [textField setTag:1000];
                [textField setText:[contact name]];
                [textField setPlaceholder:@"Name"];
            } else {
                [textField setTag:1001];
                [textField setText:[contact title]];
                [textField setPlaceholder:@"Title"];
            }
            
        } else if([reuseIdentifier isEqualToString:@"NewPhoneCell"]) {
            [[cell textLabel] setText:@"New Phone"];
        } else if([reuseIdentifier isEqualToString:@"NewEmailCell"]) {
            [[cell textLabel] setText:@"New Email"];
        } else if([reuseIdentifier isEqualToString:@"PhoneEditCell"]) {
            
            NSString* phone = (NSString *)[[contact phones] objectAtIndex:indexPath.row];
            
            UITextField *textField =(UITextField *) [[[cell contentView] subviews] objectAtIndex:0];
            UIButton *callButton = (UIButton *) [[[cell contentView] subviews] objectAtIndex:1];
            UIButton *txtButton = (UIButton *) [[[cell contentView] subviews] objectAtIndex:2];
            
            [textField setDelegate:self];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setTag:2000 + indexPath.row];
            [textField setText:phone];
            
            [callButton addTarget:self action:@selector(setDefaultCallPhonePressed:) forControlEvents:UIControlEventTouchUpInside];
            [callButton setTag: indexPath.row];
            
            if([phone isEqualToString:[contact defaultCallPhone]]) {
                [callButton setImage:[UIImage imageNamed:@"phone_selected_transparent.png" ] forState:UIControlStateNormal];
            } else {
                [callButton setImage:[UIImage imageNamed:@"phone_transparent.png"] forState:UIControlStateNormal];
            }
            
            [txtButton addTarget:self action:@selector(setDefaultTextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [txtButton setTag:indexPath.row];
            
            if([phone isEqualToString:[contact defaultTextPhone]]) {
                [txtButton setImage:[UIImage imageNamed:@"texting_selected_transparent.png" ] forState:UIControlStateNormal];
            } else {
                [txtButton setImage:[UIImage imageNamed:@"texting_transparent.png"] forState:UIControlStateNormal];
            }
            
        } else if([reuseIdentifier isEqualToString:@"EmailEditCell"]) {
            NSString* email = [[contact emails] objectAtIndex:indexPath.row];
            
            UITextField *textField = (UITextField *) [[[cell contentView] subviews] objectAtIndex:0];
            UIButton *emailButton = (UIButton *) [[[cell contentView] subviews] objectAtIndex:1];
            
            [textField setDelegate:self];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setTag:3000 + indexPath.row];
            [textField setText:email];
            
            [emailButton addTarget:self action:@selector(setDefaultEmailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [emailButton setTag:indexPath.row];
            
            if([email isEqualToString:[contact defaultEmail]]) {
                [emailButton setImage:[UIImage imageNamed:@"email_selected_transparent.png" ] forState:UIControlStateNormal];
            } else {
                [emailButton setImage:[UIImage imageNamed:@"email_transparent.png"] forState:UIControlStateNormal];
            }
        }
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

        return cell;
    }
}

-(void) setDefaultCallPhonePressed:(id)sender {
    UIButton *callBtn = (UIButton *)sender;
    NSString *phone = [[contact phones] objectAtIndex:callBtn.tag];
    if(![phone isEqualToString:@""])
    {
        [contact setDefaultCallPhone:phone];
        
    }
    [self.tableView reloadData];
}

-(void) setDefaultTextButtonPressed:(id)sender {
    UIButton *txtBtn = (UIButton *)sender;
    NSString *phone = [[contact phones] objectAtIndex:txtBtn.tag];
    if(![phone isEqualToString:@""])
    {
        [contact setDefaultTextPhone:phone];
    }
    [self.tableView reloadData];
}

-(void) setDefaultEmailButtonPressed:(id)sender {
    UIButton *emailBtn = (UIButton *)sender;
    NSString *email = [[contact emails] objectAtIndex:emailBtn.tag];
    if(![email isEqualToString:@""])
    {
        [contact setDefaultEmail:email];
    }
    [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger tag = textField.tag;
    NSInteger index = 0;
    
    if (tag == 1000) {
        [contact setName:textField.text];
    } else if (tag == 1001) {
        [contact setTitle:textField.text];
    } else if (tag >= 2000 && tag < 3000) {
        index = tag - 2000;
        [[contact phones] setObject:textField.text atIndexedSubscript:index];
    } else if (tag >= 3000) {
        index = tag - 3000;
        [[contact emails] setObject:textField.text atIndexedSubscript:index];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if(self.isEditing){
        //Change back button to cancel
        self.navigationItem.hidesBackButton = YES;
        
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = NO;
        
        //Clean up contact
        NSMutableArray *phoneKeepers = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[contact phones] count]; i++) {
            if (![[[contact phones] objectAtIndex: i] isEqualToString:@""]) {
                [phoneKeepers addObject:[[contact phones] objectAtIndex:i]];
            }
        }
        
        NSMutableArray *emailKeepers = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[contact emails] count]; i++) {
            if (![[[contact emails] objectAtIndex: i] isEqualToString:@""]) {
                [emailKeepers addObject:[[contact emails] objectAtIndex:i]];
            }
        }
        
        [contact setPhones:phoneKeepers];
        [contact setEmails:emailKeepers];
        
        //Coming out of an edit download gravatar
        [MSSEGravatarManager downloadGravatarForEmail:[contact defaultEmail]];
    }
    
    //Refresh the table view
    [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            if([[contact phones] count] == indexPath.row)
                return UITableViewCellEditingStyleInsert;
            break;
        case 2:
            if([[contact emails] count] == indexPath.row)
                return UITableViewCellEditingStyleInsert;
            break;
        default:
            break;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        switch (indexPath.section) {
            case 1:
                [[contact phones] removeObjectAtIndex:indexPath.row];
                break;
            case 2:
                [[contact emails] removeObjectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        switch (indexPath.section) {
            case 1:
                [[contact phones] addObject:@""];
                break;
            case 2:
                [[contact emails] addObject:@""];
                break;
            default:
                break;
        }
    }
    [self.tableView reloadData]; //This could be done better.
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* section = [self sectionToContent:indexPath.section];
    if([section isEqualToString:@"Phones"]) {
        //We are going to open an action sheet so we can call or message them.
        [self openActionSheetForPhoneAtIndex:indexPath.row];
    }
    
    if([section isEqualToString:@"Emails"]) {
        // Email the contact
        NSLog(@"Email button pressed");
        NSString *emailAddress = [NSString stringWithFormat: @"mailto:%@", [[contact emails] objectAtIndex:indexPath.row]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailAddress]];
    }
    
    
}

- (void) openActionSheetForPhoneAtIndex: (NSInteger)index
{
    UIActionSheet* actionSheet =[[UIActionSheet alloc]
                                 initWithTitle:@"Action"
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"Call", @"Text", nil];
    
    // Since we only have one section, the index path row is the index of our contact
    // Set it as the tag on the action shee so we know what contact to act on.
    [actionSheet setTag:index];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the contact
    NSString* number = [[contact phones] objectAtIndex:actionSheet.tag];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Call"]) {
        NSLog(@"Call button pressed");
        if ([[device model] isEqualToString:@"iPhone"]) {
            NSString *phoneNumber = [NSString stringWithFormat: @"tel://%@", number];
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
            NSString *phoneNumber = [NSString stringWithFormat: @"sms://%@", number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
        else {
            UIAlertView *NotPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [NotPermitted show];
        }
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel button pressed");
    }
    
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
