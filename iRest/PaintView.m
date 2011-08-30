//
//  PaintView.m
//  iRest
//
//  Created by Tim Askins on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintView.h"

@implementation PaintView

@synthesize color;
@synthesize lineWidth;
@synthesize finishedSquiggles;

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super initWithCoder:decoder])
    {
        squiggles = [[NSMutableDictionary alloc] init];
        finishedSquiggles = [[NSMutableArray alloc] init];
        
        color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
        lineWidth = 5;
    }
    
    return self;
}

- (void)resetView
{
    [squiggles removeAllObjects];
    [finishedSquiggles removeAllObjects];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (Squiggle *squiggle in finishedSquiggles)
        [self drawSquiggle:squiggle inContext:context];
    
    for (NSString *key in squiggles)
    {
        Squiggle *squiggle = [squiggles valueForKey:key];
        [self drawSquiggle:squiggle inContext:context];
    }
    
    CGContextFlush(context);
}

- (void)addSquiggles:(NSMutableArray *)newSquiggles
{
    [self resetView];
    finishedSquiggles = newSquiggles;
    [finishedSquiggles retain];
    [self setNeedsDisplay];
}

- (void)drawSquiggle:(Squiggle*)squiggle inContext:(CGContextRef)context
{
    UIColor *squiggleColor = squiggle.strokeColor;
    CGColorRef colorRef = [squiggleColor CGColor];
    CGContextSetStrokeColorWithColor(context, colorRef);
    
    CGContextSetLineWidth(context, squiggle.lineWidth);
    
    NSMutableArray *points = [squiggle points];
    
    CGPoint firstPoint;
    [[points objectAtIndex:0] getValue:&firstPoint];
    
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    
    for (int i = 1; i < [points count]; i++)
    {
        NSValue *value = [points objectAtIndex:i];
        CGPoint point;
        [value getValue:&point];
        
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    
    CGContextStrokePath(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *array = [touches allObjects];
    
    for (UITouch *touch in array)
    {
        Squiggle *squiggle = [[Squiggle alloc] init];
        [squiggle setStrokeColor:color];
        [squiggle setLineWidth:lineWidth];
        
        [squiggle addPoint:[touch locationInView:self]];
        
        NSValue *touchValue = [NSValue valueWithPointer:touch];
        NSString *key = [NSString stringWithFormat:@"%@", touchValue];
        
        [squiggles setValue:squiggle forKey:key];
        [squiggle release];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *array = [touches allObjects];
    
    for (UITouch *touch in array)
    {
        NSValue *touchValue = [NSValue valueWithPointer:touch];
        
        Squiggle *squiggle = [squiggles valueForKey:
                              [NSString stringWithFormat:@"%@", touchValue]];
        CGPoint current = [touch locationInView:self];
        CGPoint previous = [touch previousLocationInView:self];
        [squiggle addPoint:current];
        
        CGPoint lower, higher;
        lower.x = (previous.x > current.x ? current.x : previous.x);
        lower.y = (previous.y > current.y ? current.y : previous.y);
        higher.x = (previous.x < current.x ? current.x : current.x);
        higher.y = (previous.y < current.y ? current.y : previous.y);
        
        [self setNeedsDisplayInRect:CGRectMake(lower.x - lineWidth, lower.y - lineWidth,
                                               higher.x - lower.x + lineWidth * 2,
                                               higher.y - lower.y + lineWidth * 2)];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        NSValue *touchValue = [NSValue valueWithPointer:touch];
        NSString *key = [NSString stringWithFormat:@"%@", touchValue];
        
        Squiggle *squiggle = [squiggles valueForKey:key];
        
        [finishedSquiggles addObject:squiggle];
        [squiggles removeObjectForKey:key];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        NSString *message = @"Are you sure you want to clear the painting?";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear painting" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil];
        [alert show];
        [alert release];
    }
    
    [super motionEnded:motion withEvent:event];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self resetView];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)dealloc
{
    [squiggles release];
    [finishedSquiggles release];
    [color release];
    [super dealloc];
}

@end
