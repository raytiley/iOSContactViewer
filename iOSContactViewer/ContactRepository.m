//
//  ContactRepository.m
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/5/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import "ContactRepository.h"

@implementation ContactRepository

- (id) init
{
    self = [super init];
    if(self)
    {
        contacts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSArray *)allContacts
{
    return contacts;
}

-(Contact *)createNewContact
{
    
    Contact* newContact = [[Contact alloc] init];
    [contacts addObject:newContact];
    
    return newContact;
}

-(void)deleteContact:(Contact *)contact
{
    if([contacts containsObject:contact])
    {
        [contacts removeObject:contact];
    }
}

+ (ContactRepository *)getContactRepository
{
    static ContactRepository* repo = nil;
    if(!repo)
    {
        repo = [[super allocWithZone:nil] init];
    }
    return repo;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self getContactRepository];
}
@end
