//
//  iRestViewController.h
//  iRest
//
//  Created by Bryan Coon on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iRestViewController : UIViewController {
    UITextField *serverUrl;
    UITextView *responseTextView;
    UITextView *inputTextView;
    UIActivityIndicatorView *activityIndicator;
    UIButton *sendButton;
}

@property (nonatomic, retain) IBOutlet UITextField *serverUrl;
@property (nonatomic, retain) IBOutlet UITextView *responseTextView;
@property (nonatomic, retain) IBOutlet UITextView *inputTextView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;

- (IBAction)sendButtonClick:(id)sender;

-(void)PostDataToServer: (NSString*) server text: (NSString*) inputText;
@end
