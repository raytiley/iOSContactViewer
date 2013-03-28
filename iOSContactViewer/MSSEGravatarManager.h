//
//  MSSEGravatarManager.h
//  iOSContactViewer
//
//  Created by Raymond Tiley on 3/28/13.
//  Copyright (c) 2013 Raymond Tiley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSSEGravatarManager : NSObject
+(UIImage*)getGravatarImageForEmail:(NSString*)email;
+(void)downloadGravatarForEmail:(NSString*)email;
@end
