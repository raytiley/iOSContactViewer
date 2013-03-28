//
//  TableViewPhoneCell.m
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/27/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import "MSSETableViewCell.h"

@implementation MSSETableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Add the views we need depending on reuse identifier
        if([reuseIdentifier isEqualToString:@"ContactDetailsEditCell"]) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(1,2,298,40)];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            
            [[self contentView] addSubview:textField];
        } else if([reuseIdentifier isEqualToString:@"PhoneEditCell"]) {
            //TODO Figure out how to use layout stuff better.
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(1,2,150,40)];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            
            
            UIButton *txtButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, 44, 44)];
            txtButton.tag = 101;
            [txtButton setImage:[UIImage imageNamed:@"phone_transparent.png"] forState:UIControlStateNormal];
            
            UIButton *callButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 0, 44, 44)];
            callButton.tag = 102;
            [callButton setImage:[UIImage imageNamed:@"texting_transparent.png"] forState:UIControlStateNormal];
            
            [[self contentView] addSubview:textField];
            [[self contentView] addSubview:txtButton];
            [[self contentView] addSubview:callButton];
            
        } else if([reuseIdentifier isEqualToString:@"EmailEditCell"]) {
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(1,2,180,40)];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];

            UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 2, 44, 44)];
            [emailButton setImage:[UIImage imageNamed:@"email_transparent.png"] forState:UIControlStateNormal];
            
            [[self contentView] addSubview:textField];
            [[self contentView] addSubview:emailButton];
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    if (state & UITableViewCellStateShowingDeleteConfirmationMask) {
        UIView *callorEmailView = [[self contentView] viewWithTag:101];
        UIView *messageView = [[self contentView] viewWithTag:102];
        callorEmailView.hidden = YES;
        messageView.hidden = YES;
    }
}

- (void) didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    
    Boolean hide = NO;
    if(state & UITableViewCellStateShowingDeleteConfirmationMask) {
        hide = YES;
    }
    
    
    for (int i=1; i<[[[self contentView] subviews] count]; i++) {
        [[[[self contentView] subviews] objectAtIndex:i] setHidden:hide];
    }
    
}
@end
