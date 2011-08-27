//
//  Squiggle.m
//  iRest
//
//  Created by Tim Askins on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Squiggle.h"

@implementation Squiggle

@synthesize strokeColor;
@synthesize lineWidth;
@synthesize points;

- (id)init
{
    if (self = [super init])
    {
        points = [[NSMutableArray alloc] init];
        strokeColor = [[UIColor blackColor] retain];
    }
    
    return self;
}

- (void)addPoint:(CGPoint)point
{
    NSValue *value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
    [points addObject:value];
}

- (void)dealloc
{
    [strokeColor release];
    [points release];
    [super dealloc];
}

@end
