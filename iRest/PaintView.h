//
//  PaintView.h
//  iRest
//
//  Created by Tim Askins on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Squiggle.h"

@interface PaintView : UIView
{
    NSMutableDictionary *squiggles;
    NSMutableArray *finishedSquiggles;
    UIColor *color;
    float lineWidth;
}

@property (nonatomic, retain) IBOutlet UIColor *color;
@property IBOutlet float lineWidth;
@property (nonatomic, retain) NSMutableArray *finishedSquiggles;

- (void)drawSquiggle:(Squiggle *)squiggle inContext:(CGContextRef)context;
- (void)resetView;
- (void)addSquiggles:(NSMutableArray *)newSquiggles;

@end
