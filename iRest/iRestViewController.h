//
//  iRestViewController.h
//  iRest
//
//  Created by Bryan Coon on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTextSegmentIndex 0
#define kImageSegmentIndex 1
#define kSketchSegmentIndex 2

@interface iRestViewController : UIViewController<UIImagePickerControllerDelegate>
{
    UISegmentedControl *_inputTypeSelector;
    
    UITextField *_serverUrl;
    UITextView *_responseTextView;
    UITextView *_inputTextView;
    UIActivityIndicatorView *_activityIndicator;
    UIButton *_sendButton;
    NSOperationQueue *_queue;
    
    UIImageView *imageView;
    UIButton *takePictureButton;
    UIButton *selectpictureButton;
    UIImage *image;
    CGRect imageFrame;
    
    UIView *sketchView;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *InputTypeSelector;

@property (nonatomic, retain) IBOutlet UITextField *ServerUrl;
@property (nonatomic, retain) IBOutlet UITextView *ResponseTextView;
@property (nonatomic, retain) IBOutlet UITextView *InputTextView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *SendButton;
@property (retain) NSOperationQueue *Queue;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *selectPictureButton;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) IBOutlet UIView *sketchView;

- (IBAction)SendButtonClick:(id)sender;
-(void)PostDataToServer: (NSString*) server text: (NSString*) inputText;

- (IBAction)toggleinputType:(id)sender;
- (IBAction)shootPicture:(id)sender;
- (IBAction)selectExistingPicture:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
