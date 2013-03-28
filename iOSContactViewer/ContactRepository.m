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
        NSString *path = [self itemsArchivePath];
        contacts = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(!contacts)
        {
            contacts = [[NSMutableArray alloc] init];
        }
        
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

- (void)addNewContact:(Contact *)contact
{
    [contacts addObject:contact];
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

-(BOOL)saveChanges
{
    NSString *path = [self itemsArchivePath];
    return [NSKeyedArchiver archiveRootObject:contacts toFile:path];
}


-(NSString *)itemsArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"contacts.archive"];
}@end
