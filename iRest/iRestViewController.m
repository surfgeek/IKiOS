//
//  iRestViewController.m
//  iRest
//
//  Created by Bryan Coon on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iRestViewController.h"
#import "ASIHTTPRequest.h"

@implementation iRestViewController
@synthesize serverUrl;
@synthesize responseTextView;
@synthesize inputTextView;
@synthesize activityIndicator;
@synthesize sendButton;

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
    [serverUrl setText:@"http://bccm4500/Rest/IOSService/CurrentTime"];
}


- (void)viewDidUnload
{
    [self setServerUrl:nil];
    [self setResponseTextView:nil];
    [self setInputTextView:nil];
    [self setActivityIndicator:nil];
    [self setSendButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [serverUrl release];
    [responseTextView release];
    [inputTextView release];
    [activityIndicator release];
    [sendButton release];
    [super dealloc];
}

- (IBAction)sendButtonClick:(id)sender 
{
    // Hide the keyboard
    [inputTextView resignFirstResponder];
    
    // Grab the text from the input window
    NSString* input = inputTextView.text;
    
    // Post the input text to the remote server
    NSString* server = serverUrl.text;
    
    [self PostDataToServer: server text: input];
}

-(void)PostDataToServer: (NSString*) server text: (NSString*) inputText
{
    // Post data to REST service 
    NSURL *url = [NSURL URLWithString:server];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    // Need to do more stuff here
    
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [responseTextView setText:error];
}
@end
