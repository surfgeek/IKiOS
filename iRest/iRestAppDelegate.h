//
//  iRestAppDelegate.h
//  iRest
//
//  Created by Bryan Coon on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iRestViewController;

@interface iRestAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iRestViewController *viewController;

@end
