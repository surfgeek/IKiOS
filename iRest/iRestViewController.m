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

@implementation iRestViewController

@synthesize ServerUrl = _serverUrl;
@synthesize ResponseTextView = _responseTextView;
@synthesize InputTextView = _inputTextView;
@synthesize ActivityIndicator = _activityIndicator;
@synthesize SendButton = _sendButton;
@synthesize Queue = _queue;

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
    [_serverUrl setText:@"http://bccm4500/Rest/IOSService/CurrentTimeJson"];
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
    
    // Grab the text from the input window
    NSString* input = [_inputTextView text];
    
    // Post the input text to the remote server
    NSString* server = [_serverUrl text];
    
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

- (void)parseXml:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) {            
        
        NSString *blogTitle = [channel valueForChild:@"title"];                    
        
        NSArray *items = [channel elementsForName:@"item"];
        for (GDataXMLElement *item in items) {
            
            NSString *articleTitle = [item valueForChild:@"title"];
            NSString *articleUrl = [item valueForChild:@"link"];            
            NSString *articleDateString = [item valueForChild:@"pubDate"];        
            NSDate *articleDate = nil;
            
//            RSSEntry *entry = [[[RSSEntry alloc] initWithBlogTitle:blogTitle 
//                                                      articleTitle:articleTitle 
//                                                        articleUrl:articleUrl 
//                                                       articleDate:articleDate] autorelease];
//            [entries addObject:entry];
            
        }      
    }
    
}

- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries 
{    
    NSString* name = [rootElement name];
    if ([name compare:@"rss"] == NSOrderedSame) {
        [self parseXml:rootElement entries:entries];
    } else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request description];
    NSData *responseData = [request responseData];
    
    
    [_queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] 
                                                               options:0 error:&error];
        if (doc == nil) { 
            NSLog(@"Failed to parse %@", request.url);
        } else {
            
            NSMutableArray *entries = [NSMutableArray array];
            [self parseFeed:doc.rootElement entries:entries];                
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                // Do some fancy stuff in here
            }];
            
        }        
    }];
    
    
    // Need to do more stuff here
    
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
    
    [_responseTextView setText:responseString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [_inputTextView resignFirstResponder];
    [_responseTextView setText:error.description];
}
@end
