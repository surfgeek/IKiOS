//
//  iRestViewController.h
//  iRest
//
//  Created by Bryan Coon on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iRestViewController : UIViewController {
    UITextField *_serverUrl;
    UITextView *_responseTextView;
    UITextView *_inputTextView;
    UIActivityIndicatorView *_activityIndicator;
    UIButton *_sendButton;
    NSOperationQueue *_queue;
}

@property (nonatomic, retain) IBOutlet UITextField *ServerUrl;
@property (nonatomic, retain) IBOutlet UITextView *ResponseTextView;
@property (nonatomic, retain) IBOutlet UITextView *InputTextView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *SendButton;
@property (retain) NSOperationQueue *Queue;

- (IBAction)SendButtonClick:(id)sender;

-(void)PostDataToServer: (NSString*) server text: (NSString*) inputText;
@end
