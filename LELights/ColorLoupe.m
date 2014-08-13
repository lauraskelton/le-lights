//
//  ColorLoupe.m
//  LELights
//
//  Created by Laura Skelton on 8/10/14.
//  Copyright (c) 2014 lauraskelton. All rights reserved.
//

#import "ColorLoupe.h"

@implementation ColorLoupe
@synthesize fillColor = _fillColor;
@synthesize innerCircle = _innerCircle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor * shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    
    CGFloat lineWidth = 2;
    CGRect borderRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    borderRect = CGRectInset(borderRect, lineWidth * 0.5, lineWidth * 0.5);

    
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    CGContextFillRect(context, _innerCircle);
    
    CGContextSetStrokeColorWithColor(context, whiteColor.CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor.CGColor);
    CGContextRestoreGState(context);
}

-(void)setFillColor:(UIColor *)newFillColor
{
    if (newFillColor != _fillColor) {
        _fillColor = newFillColor;
        [self setNeedsDisplay];
    }
}

@end
