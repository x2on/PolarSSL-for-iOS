//
//  PolarSSL_for_iOSAppDelegate.m
//  PolarSSL-for-iOS
//
//  Created by Felix Schulze on 08.04.11.
//  Copyright 2011 Felix Schulze. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "PolarSSL_for_iOSAppDelegate.h"
#include "polarssl/md5.h"

@implementation PolarSSL_for_iOSAppDelegate


@synthesize window, textField, md5TextField;

#pragma mark -
#pragma mark PolarSSL

- (IBAction)calculateMD5:(id)sender
{
	/** Calculate MD5*/
	NSString *string =  textField.text;
    const char *inStr = [string UTF8String];
    unsigned long lngth = [string length];
	unsigned char result[16];
    
    md5( (unsigned char *) inStr, lngth, result );
    
    NSMutableString *outStrg = [[NSMutableString alloc] init];
    
    for(int i = 0; i < 16; i++ )
    {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    
	md5TextField.text = outStrg;
    [outStrg release];
	
	//Hide Keyboard after calculation
	[textField resignFirstResponder];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (IBAction)showInfo {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GnuTLS-for-iOS" message:@"PolarSSL-Version: 0.14.3\n\nLicense: See include/polarssl/LICENSE\n\nCopyright 2011 by Felix Schulze\n http://www.x2on.de" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}


- (void)dealloc
{
    [window release];
    [textField release];
    [md5TextField release];

    [super dealloc];
}

@end
