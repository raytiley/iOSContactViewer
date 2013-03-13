//
//  MasterViewController.h
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/5/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactViewController;

@interface MasterViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) ContactViewController *contactViewController;

@end
