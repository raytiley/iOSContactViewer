//
//  MSSEGravatarManager.m
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/28/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import "MSSEGravatarManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MSSEGravatarManager


+(UIImage*)getGravatarImageForEmail:(NSString*)email
{
    //First lets see if we already have it
    if(email && ![email isEqualToString:@""])
    {
        NSString* hash = [self generateMd5HashForEmail:email];
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg", hash];
        NSString* filePath = [self getPathForFileName:fileName];
        
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            return [UIImage imageWithContentsOfFile:filePath];
        }
    }
    
    return [UIImage imageNamed:@"default_gravatar"];
}

+(void)downloadGravatarForEmail:(NSString*)email
{
    if(email && ![email isEqualToString:@""])
    {
        NSString* hash = [self generateMd5HashForEmail:email];
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg", hash];

        NSData *urlData = [NSData dataWithContentsOfURL:[self getGravatarURLForEmail:email]];
        [urlData writeToFile:[self getPathForFileName:fileName] atomically:YES];
    }
}

+ (NSURL*) getGravatarURLForEmail:(NSString *)email
{
    NSString* processedEmail = [[email lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* hash = [self generateMd5HashForEmail:processedEmail];
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?d=monsterid", hash]];
}

+ (NSString *) generateMd5HashForEmail:(NSString *) email {
    const char *cStr = [email UTF8String];
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, strlen(cStr), hash);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [result appendFormat:@"%02x", hash[i]];
    }
    return [NSString stringWithString:result];
}

+ (NSString *)getPathForFileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    
    return filePath;
}



@end
