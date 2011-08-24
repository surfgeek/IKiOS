//
//  iRestViewController.m
//  iRest
//
//  Created by Bryan Coon on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iRestViewController.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "DataElement.h"

#import <MobileCoreServices/UTCoreTypes.h>

@interface iRestViewController()
static UIImage *shrinkImage(UIImage *original, CGSize size);
- (void)updateDisplay;
- (void)getMdeiaFromSource:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation iRestViewController

@synthesize InputTypeSelector = _inputTypeSelector;

@synthesize ServerUrl = _serverUrl;
@synthesize ResponseTextView = _responseTextView;
@synthesize InputTextView = _inputTextView;
@synthesize ActivityIndicator = _activityIndicator;
@synthesize SendButton = _sendButton;
@synthesize Queue = _queue;

@synthesize imageView;
@synthesize takePictureButton;
@synthesize selectPictureButton;
@synthesize image;

@synthesize sketchView;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.Queue = [[[NSOperationQueue alloc] init] autorelease];
    [_serverUrl setText:@"http://IK002159/Rest/IOSService/TestXml"];
    
    _inputTextView.hidden = NO;
    
    takePictureButton.hidden = YES;
    selectPictureButton.hidden = YES;
    imageView.hidden = YES;
    
    sketchView.hidden = YES;
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        takePictureButton.enabled = YES;
//    }
//    else
//    {
//        takePictureButton.enabled = NO;
//    }
    
    imageFrame = imageView.frame;
}


- (void)viewDidUnload
{
    self.imageView = nil;
    self.takePictureButton = nil;
    
    [self setServerUrl:nil];
    [self setResponseTextView:nil];
    [self setInputTextView:nil];
    [self setActivityIndicator:nil];
    [self setSendButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    imageView.image = image;
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [_serverUrl resignFirstResponder];
    [_inputTextView resignFirstResponder];
}

- (IBAction)toggleinputType:(id)sender
{
    if ([sender selectedSegmentIndex] == kTextSegmentIndex)
    {
        _inputTextView.hidden = NO;
        
        takePictureButton.hidden = YES;
        selectPictureButton.hidden = YES;
        imageView.hidden = YES;
        
        sketchView.hidden = YES;
    }
    else if ([sender selectedSegmentIndex] == kImageSegmentIndex)
    {
        _inputTextView.hidden = YES;
        
        takePictureButton.hidden = NO;
        selectPictureButton.hidden = NO;
        imageView.hidden = NO;
        
        sketchView.hidden = YES;
        
        [_inputTextView resignFirstResponder];
    }
    else
    {
        _inputTextView.hidden = YES;
        
        takePictureButton.hidden = YES;
        selectPictureButton.hidden = YES;
        imageView.hidden = YES;
        
        sketchView.hidden = NO;
        
        [_inputTextView resignFirstResponder];
    }
}

- (IBAction)shootPicture:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)selectExistingPicture:(id)sender {
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
    self.image = shrunkenImage;
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
static UIImage *shrinkImage(UIImage *original, CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, 0,
                                                 colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width * scale, size.height * scale), original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    
    CGContextRelease(context);
    CGImageRelease(shrunken);
    
    return final;
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error accessing media"
                              message:@"Device doesn't support that media source."
                              delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (UIImage *)createImageFromBase64:(unsigned char *)data pixelWidth:(int)width pixelHeight:(int)height
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(data, width, height, 8, 32, colorspace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorspace);
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
}

- (void)dealloc {
    [imageView release];
    [takePictureButton release];
    [image release];
    [_serverUrl release];
    [_responseTextView release];
    [_inputTextView release];
    [_activityIndicator release];
    [_sendButton release];
    [super dealloc];
}

- (IBAction)sendButtonClick:(id)sender 
{
    // Hide the keyboard
    [_inputTextView resignFirstResponder];
    
    NSString* input = [self getInputString];
    
    // Post the input text to the remote server
    NSString* server = [_serverUrl text];
    
    [self PostDataToServer:server text:input];
}

- (NSString *)getInputString
{
    if ([_inputTypeSelector selectedSegmentIndex] == kTextSegmentIndex)
    {
        return [_inputTextView text];
    }
    else if ([_inputTypeSelector selectedSegmentIndex] == kImageSegmentIndex)
    {
    }
    
    return @"Drawing data";
}

-(void)PostDataToServer: (NSString*) server text: (NSString*) inputText
{
    // Post data to REST service 
    NSURL *url = [NSURL URLWithString:server];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (NSObject *)parseXmlAsDataElement:(GDataXMLElement *)rootElement
{
    DataElement *dataElement = [[DataElement alloc] init];
    
    dataElement.ElementId = [rootElement valueForChild:@"Id"];
    dataElement.DataSetName = [rootElement valueForChild:@"DataSetName"];
    dataElement.DataText  = [rootElement valueForChild:@"DataText"];
    
    return dataElement;
}

- (NSObject *)parseResponse:(GDataXMLElement *)rootElement
{    
    NSString* name = [rootElement name];
    if ([name compare:@"DataElement"] == NSOrderedSame) {
        return [self parseXmlAsDataElement:rootElement];
    } else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }
    
    return nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
//    NSString *responseString = [request responseString];
//    NSData *responseData = [request responseData];
    
    [_queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] 
                                                               options:0 error:&error];
        if (doc == nil)
        { 
            NSLog(@"Failed to parse %@", request.url);
        }
        else
        {
            NSObject *responseObject = [self parseResponse:doc.rootElement];                
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if ([responseObject isKindOfClass:[DataElement class]])
                {
                    _responseTextView.text = ((DataElement *)responseObject).DataText;
                }
            }];
        }        
    }];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [_inputTextView resignFirstResponder];
    [_responseTextView setText:error.description];
}
@end
