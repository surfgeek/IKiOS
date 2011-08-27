//
//  Squiggle.h
//  iRest
//
//  Created by Tim Askins on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Squiggle : NSObject
{
    NSMutableArray *points;
    UIColor *strokeColor;
    float lineWIdth;
}

@property (retain) UIColor *strokeColor;
@property (assign) float lineWidth;
@property (nonatomic, readonly) NSMutableArray *points;

- (void)addPoint:(CGPoint)point;

@end
