//
//  Contact.m
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/5/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import "Contact.h"

@implementation Contact
@synthesize name;
@synthesize title;
@synthesize phones;
@synthesize emails;
@synthesize defaultCallPhone;
@synthesize defaultTextPhone;
@synthesize defaultEmail;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.phones = [[NSMutableArray alloc] init];
        self.emails = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:phones forKey:@"phones"];
    [aCoder encodeObject:emails forKey:@"emails"];
    [aCoder encodeObject:defaultCallPhone forKey:@"defaultCallPhone"];
    [aCoder encodeObject:defaultTextPhone forKey:@"defaultTextPhone"];
    [aCoder encodeObject:defaultEmail forKey:@"defaultEmail"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.phones = [aDecoder decodeObjectForKey:@"phones"];
        self.emails = [aDecoder decodeObjectForKey:@"emails"];
        self.defaultCallPhone = [aDecoder decodeObjectForKey:@"defaultCallPhone"];
        self.defaultTextPhone = [aDecoder decodeObjectForKey:@"defaultTextPhone"];
        self.defaultEmail = [aDecoder decodeObjectForKey:@"defaultEmail"];
    }
    return self;
}

@end
