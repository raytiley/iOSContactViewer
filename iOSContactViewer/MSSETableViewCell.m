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
        // Initialization code
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
    
    UIView *callorEmailView = [[self contentView] viewWithTag:101];
    UIView *messageView = [[self contentView] viewWithTag:102];
    
    if(state & UITableViewCellStateShowingDeleteConfirmationMask) {
        
        callorEmailView.hidden = YES;
        messageView.hidden = YES;
    } else {
        callorEmailView.hidden = NO;
        messageView.hidden = NO;
    }
    
}
@end
