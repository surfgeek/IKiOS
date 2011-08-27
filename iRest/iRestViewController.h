//
//  iRestViewController.h
//  iRest
//
//  Created by Bryan Coon on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"
#import "PaintView.h"

#define kTextSegmentIndex 0
#define kImageSegmentIndex 1
#define kSketchSegmentIndex 2

@interface iRestViewController : UIViewController<UIImagePickerControllerDelegate, FlipsideViewControllerDelegate>
{
    UISegmentedControl *_inputTypeSelector;
    
    NSString *_serverUrl;
    BOOL _encodeAsJson;
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
    UIImageView *responseImageView;
    UIImage *responseImage;
    CGRect responseImageFrame;
    
    PaintView *sketchView;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *InputTypeSelector;

@property (nonatomic, retain) NSString *ServerUrl;
@property (nonatomic) BOOL EncodeAsJson;
@property (nonatomic, retain) IBOutlet UITextView *ResponseTextView;
@property (nonatomic, retain) IBOutlet UITextView *InputTextView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *SendButton;
@property (retain) NSOperationQueue *Queue;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *selectPictureButton;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) IBOutlet UIImageView *responseImageView;
@property (nonatomic, retain) UIImage *responseImage;
@property (nonatomic, retain) IBOutlet PaintView *sketchView;

- (IBAction)SendButtonClick:(id)sender;
-(void)PostDataToServer: (NSString*) server text: (NSString*) inputText asJson:(BOOL)useJson;

- (IBAction)toggleinputType:(id)sender;
- (IBAction)shootPicture:(id)sender;
- (IBAction)selectExistingPicture:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
