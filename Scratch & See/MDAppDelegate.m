//
//  MDAppDelegate.m
//  Scratch & See
//
//  Created by Andrew Kopanev on 1/21/14.
//  Copyright (c) 2014 Moqod. All rights reserved.
//

#import "MDAppDelegate.h"
#import "MDScratchSampleViewController.h"

@implementation MDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = [[MDScratchSampleViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
