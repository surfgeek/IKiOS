//
//  FlipsideViewController.m
//  iRest
//
//  Created by Tim Askins on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize ServerUrl = _serverUrl;
@synthesize JsonSwitch = _jsonSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _serverUrl = [[UITextField alloc] init];
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [_serverUrl resignFirstResponder];
}

- (void)setServerUrlString:(NSString *)url
{
    _serverUrl.text = url;
}

- (void)setUsingJson:(BOOL)useJson
{
    _jsonSwitch.on = useJson;
}

- (IBAction)done:(id)sender
{
    [self.delegate setServerUrlString:_serverUrl.text];
    [self.delegate setUsingJson:_jsonSwitch.on];
    [self.delegate flipsideViewControllerDidFinish:self];
}
@end
