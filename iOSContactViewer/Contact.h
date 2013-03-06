//
//  Contact.h
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/5/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property NSString* name;
@property NSString* title;
@property NSMutableArray* emails;
@property NSMutableArray* phones;
@property NSString* defaultCallPhone;
@property NSString* defaultTextPhone;
@property NSString* defaultEmail;

@end
