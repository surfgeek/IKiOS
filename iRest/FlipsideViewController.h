//
//  FlipsideViewController.h
//  iRest
//
//  Created by Tim Askins on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)setServerUrlString:(NSString *)url;
@end

@interface FlipsideViewController : UIViewController
{
    id <FlipsideViewControllerDelegate> delegate;
    UITextField *_serverUrl;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *ServerUrl;

- (IBAction)done:(id)sender;
- (void)setServerUrlString:(NSString *)url;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
