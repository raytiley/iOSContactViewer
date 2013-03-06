//
//  ContactEditViewController.h
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/5/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactEditViewController : UIViewController
@property Contact* contact;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end
