//
//  DetailViewController.h
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/5/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
