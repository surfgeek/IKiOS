//
//  DataElement.m
//  iRest
//
//  Created by Bryan Coon on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataElement.h"

@implementation DataElement

@synthesize ElementId = _elementId;
@synthesize DataSetName = _dataSetName;
@synthesize DataText = _dataText;
@synthesize DataImageBase64 = _dataImageBase64;
@synthesize DataSketch = _dataSketch;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
