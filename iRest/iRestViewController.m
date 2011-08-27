//
//  iRestViewController.m
//  iRest
//
//  Created by Bryan Coon on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iRestViewController.h"
#import "FlipsideViewController.h"
#import "PaintView.h"
#import "Squiggle.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "DataElement.h"
#import "Base64.h"
#import "SBJson.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface iRestViewController()
static UIImage *shrinkImage(UIImage *original, CGSize size);
- (void)updateDisplay;
- (void)getMdeiaFromSource:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation iRestViewController

@synthesize InputTypeSelector = _inputTypeSelector;

@synthesize ServerUrl = _serverUrl;
@synthesize EncodeAsJson = _encodeAsJson;
@synthesize ResponseTextView = _responseTextView;
@synthesize InputTextView = _inputTextView;
@synthesize ActivityIndicator = _activityIndicator;
@synthesize SendButton = _sendButton;
@synthesize Queue = _queue;

@synthesize imageView;
@synthesize takePictureButton;
@synthesize selectPictureButton;
@synthesize image;
@synthesize responseImageView;
@synthesize responseImage;

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
    _serverUrl = @"http://IK002159/Rest/IOSService/";
    
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
    responseImageFrame = responseImageView.frame;
    
    _encodeAsJson = NO;
    
    [Base64 initialize];
}


- (void)viewDidUnload
{
    self.imageView = nil;
    self.responseImageView = nil;
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

- (void)dealloc {
    [imageView release];
    [responseImageView release];
    [takePictureButton release];
    [image release];
    [responseImage release];
    [_serverUrl release];
    [_responseTextView release];
    [_inputTextView release];
    [_activityIndicator release];
    [_sendButton release];
    [super dealloc];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setServerUrlString:(NSString *)url
{
    _serverUrl = url;
}

- (void)setUsingJson:(BOOL)useJson
{
    _encodeAsJson = useJson;
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller setServerUrlString:_serverUrl];
    [controller setUsingJson:_encodeAsJson];
    
    [controller release];
}

- (IBAction)sendButtonClick:(id)sender 
{
    // Hide the keyboard
    [_inputTextView resignFirstResponder];
    
    [_responseTextView setText:@""];
    [responseImageView setImage:nil];
    
    DataElement* data = [[DataElement alloc] init];
    data.ElementId = @"42";
    data.DataSetName = @"Test Data";
    data.DataText = [_inputTextView text];
    data.DataImageBase64 = [self getStringFromImage:image];
    
    // Post the input text to the remote server
    NSString* server = _serverUrl;
    
    [self PostDataToServer:server dataElement:data asJson:_encodeAsJson];
}

- (NSString *)getStringFromImage:(UIImage *)theImage
{
    if (theImage == nil)
    {
        return @"";
    }
    NSData *imageData = UIImageJPEGRepresentation(theImage, 90);
    return [Base64 encode:imageData];
}

- (UIImage *)getImageFromString:(NSString *)imageString
{
    if (imageString == nil)
    {
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    return [[UIImage alloc] initWithData:[Base64 decode:imageString]];
}
- (void)PostDataToServer:(NSString*)server dataElement:(DataElement*)dataElement asJson:(BOOL)useJson
{
    NSString *urlString = [[NSString alloc] init];
    NSData *encodedData;
    
    // Determine the proper method to call.
    if (useJson == YES)
    {
        urlString = [[server copy] stringByAppendingString:@"EchoJson"];
        encodedData = [self encodeDataElementAsJson:dataElement];
    }
    else
    {
        urlString = [[server copy] stringByAppendingString:@"EchoXml"];
        encodedData = [self encodeDataElementAsXml:dataElement];
    }
    
    // Post data to REST service
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request appendPostData:encodedData];
    [request setRequestMethod:@"PUT"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (NSData *)encodeDataElementAsXml:(DataElement *)dataElement
{
    GDataXMLElement *dataElementElement = [GDataXMLNode elementWithName:@"DataElement"];
    GDataXMLElement *idElement = [GDataXMLNode elementWithName:@"Id" stringValue:[dataElement ElementId]];
    GDataXMLElement *dataSetNameElement = [GDataXMLNode elementWithName:@"DataSetName" stringValue:[dataElement DataSetName]];
    GDataXMLElement *dataTextElement = [GDataXMLNode elementWithName:@"DataText" stringValue:[dataElement DataText]];
    GDataXMLElement *dataImageBase64Element = [GDataXMLNode elementWithName:@"DataImageBase64" stringValue:[dataElement DataImageBase64]];
    
    [dataElementElement addChild:idElement];
    [dataElementElement addChild:dataSetNameElement];
    [dataElementElement addChild:dataTextElement];
    [dataElementElement addChild:dataImageBase64Element];
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithRootElement:dataElementElement] autorelease];
    return document.XMLData;
}

- (NSObject *)parseXmlAsDataElement:(GDataXMLElement *)rootElement
{
    DataElement *dataElement = [[DataElement alloc] init];
    
    dataElement.ElementId = [rootElement valueForChild:@"Id"];
    dataElement.DataSetName = [rootElement valueForChild:@"DataSetName"];
    dataElement.DataText  = [rootElement valueForChild:@"DataText"];
    dataElement.DataImageBase64  = [rootElement valueForChild:@"DataImageBase64"];
    
    return dataElement;
}

- (NSObject *)parseXmlRootElement:(GDataXMLElement *)rootElement
{    
    NSString* name = [rootElement name];
    if ([name compare:@"DataElement"] == NSOrderedSame) {
        return [self parseXmlAsDataElement:rootElement];
    } else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }
    
    return nil;
}

- (NSObject *)parseResponseAsXml:(NSString *)responseData
{    
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil)
    { 
        return NO;
    }
    
    return [self parseXmlRootElement:doc.rootElement];                
}

- (NSData *)encodeDataElementAsJson:(DataElement *)dataElement
{
    SBJsonWriter *json = [[SBJsonWriter new] autorelease];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                                       
    [dictionary setObject:dataElement.ElementId forKey:@"Id"];
    [dictionary setObject:dataElement.DataSetName forKey:@"DataSetName"];
    [dictionary setObject:dataElement.DataText forKey:@"DataText"];
    [dictionary setObject:dataElement.DataImageBase64 forKey:@"DataImageBase64"];
    
    NSMutableArray *squiggles = [[NSMutableArray alloc] init];
    for (Squiggle *squiggle in sketchView.finishedSquiggles)
    {
        NSMutableArray *squigglePoints = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [[squiggle points] count]; i++)
        {
            NSValue *value = [[squiggle points] objectAtIndex:i];
            CGPoint point;
            [value getValue:&point];
            
            NSMutableDictionary *normalizedCoords = [[NSMutableDictionary alloc] init];
            [normalizedCoords setObject:[NSString stringWithFormat:@"%.2f", point.x] forKey:@"_x"];
            [normalizedCoords setObject:[NSString stringWithFormat:@"%.2f", point.y] forKey:@"_y"];
            
            [squigglePoints addObject:normalizedCoords];
        }
        
        NSMutableDictionary *pointEntry = [[NSMutableDictionary alloc] init];
        [pointEntry setObject:squigglePoints forKey:@"Points"];
        [squiggles addObject:pointEntry];
        }
        
        [dictionary setObject:squiggles forKey:@"DataSketch"];
    
    return [json dataWithObject:dictionary];
}

- (NSObject *)parseJsonAsDataElement:(NSArray *)fields
{
    DataElement *dataElement = [[DataElement alloc] init];
    
    dataElement.ElementId = [fields valueForKey:@"Id"];
    dataElement.DataSetName = [fields valueForKey:@"DataSetName"];
    dataElement.DataText  = [fields valueForKey:@"DataText"];
    dataElement.DataImageBase64  = [fields valueForKey:@"DataImageBase64"];
    
    return dataElement;
}

- (NSObject *)parseResponseAsJson:(NSString *)responseString
{
	NSError *error;
	SBJsonParser *json = [[SBJsonParser new] autorelease];
	NSArray *fields = [json objectWithString:responseString error:&error];
	if (fields == nil)
    {
        NSLog(@"JSON parsing failed: %@", [error localizedDescription]);
        return NO;
    }
    
    return [self parseJsonAsDataElement:fields];                
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSData *responseData = [request responseData];
    NSObject *responseObject;
    
    if (_encodeAsJson)
    {
        responseObject = [self parseResponseAsJson:responseString];
    }
    else
    {
        responseObject = [self parseResponseAsXml:responseData];
    }
    
    if (responseObject == nil)
    { 
        NSLog(@"Failed to parse %@", request.url);
        _responseTextView.text = @"Failed to parse response";
        return;
    }
    
    if ([responseObject isKindOfClass:[DataElement class]])
    {
        DataElement *dataElement = (DataElement *)responseObject;
        _responseTextView.text = dataElement.DataText;
        if (dataElement.DataImageBase64 != nil)
        {
            UIImage *dataImage = [self getImageFromString:dataElement.DataImageBase64];
            UIImage *shrunkenImage = shrinkImage(dataImage, responseImageFrame.size);
            self.responseImageView.image = shrunkenImage;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [_inputTextView resignFirstResponder];
    [_responseTextView setText:error.description];
}
@end
