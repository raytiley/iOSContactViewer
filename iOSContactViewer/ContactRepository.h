//
//  ContactRepository.h
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/5/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface ContactRepository : NSObject
{
    NSMutableArray* contacts;
}
+(ContactRepository *)getContactRepository;

-(NSArray *)allContacts;
-(Contact *)createNewContact;
-(void)addNewContact:(Contact*)contact;
-(void)deleteContact:(Contact*)contact;
-(BOOL) saveChanges;


@end
