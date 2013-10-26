//
//  KAAAppDelegate.m
//  kaas
//
//  Created by Jurre Stender on 26/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAAAppDelegate.h"

#import "AFNetworkActivityIndicatorManager.h"

@implementation KAAAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
	[NSURLCache setSharedURLCache:URLCache];
    
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
	UIViewController *viewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = self.navigationController;
	[self.window makeKeyAndVisible];
    
	return YES;
}

@end
