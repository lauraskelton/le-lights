//
//  LEDStripView.m
//  LELights
//
//  Created by Laura Skelton on 8/10/14.
//  Copyright (c) 2014 lauraskelton. All rights reserved.
//

#import "LEDStripView.h"

#define numberOfLEDs 5.0

@interface LEDStripView () {
    NSArray *ledViews;
}

@end

@implementation LEDStripView

-(void)awakeFromNib
{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    while (i < numberOfLEDs) {
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(i * self.bounds.size.width/numberOfLEDs, self.bounds.origin.y, self.bounds.size.width/numberOfLEDs, self.bounds.size.height)];
        
        NSLog(@"subview frame: (%f,%f,%f,%f)", i * self.bounds.size.width/numberOfLEDs, self.bounds.origin.y, self.bounds.size.width/numberOfLEDs, self.bounds.size.height);
        
        [tmpArray addObject: subview];
        [self addSubview:subview];
        [self bringSubviewToFront:subview];
        i++;
    }
    ledViews = tmpArray;
    
    [super awakeFromNib];
    
}

-(void)setLEDColor:(UIColor *)color atPoint:(CGPoint)point
{
    // convert point to bin of which LED it hits depending on defined number of LEDs in strip
    
    NSInteger ledNum = [self getLEDForPoint:point];
    NSLog(@"ledNum: %d", ledNum);
    
    if (ledNum >= ledViews.count) {
        return;
    }
    UIView *thisLEDView = (UIView *)ledViews[ledNum];
    
    thisLEDView.backgroundColor = color;
    
}

-(NSInteger)getLEDForPoint:(CGPoint)point
{
    CGFloat fractionSize = self.bounds.size.width / numberOfLEDs;
    
    if (CGRectContainsPoint(self.bounds, point)) {
        
        // LED number
        return floorf(point.x / fractionSize);
    }
    
    // failed
    return -1;
}

@end
