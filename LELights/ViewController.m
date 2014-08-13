//
//  ViewController.m
//  LELights
//
//  Created by Laura Skelton on 8/10/14.
//  Copyright (c) 2014 lauraskelton. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize colorPicker = _colorPicker;
@synthesize colorRect = _colorRect;
@synthesize ledStripView = _ledStripView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _colorPicker.delegate = self;
    _colorRect.hidden = YES;
    [_colorRect setAutoresizingMask:UIViewAutoresizingNone];
    
    [_colorRect setFrame:CGRectMake(-40, -40, 70, 70)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ColorPicker Delegate Methods

- (void)startPickingAtPoint:(CGPoint)point color:(UIColor *)color
{
    [_colorRect setFrame:CGRectMake(-40, -40, 90, 90)];
    
    _colorRect.backgroundColor = [UIColor clearColor];
    
    
    CGPoint centerInSuperview = [self.view convertPoint:point fromView:_colorPicker];
    _colorRect.center = centerInSuperview;
    _colorRect.fillColor = color;
    _colorRect.hidden = NO;
}

- (void)movedPickerToPoint:(CGPoint)point color:(UIColor *)color
{
    CGPoint centerInSuperview = [self.view convertPoint:point fromView:_colorPicker];
    _colorRect.center = centerInSuperview;
    _colorRect.fillColor = color;

}

- (void)droppedAtPoint:(CGPoint)point withColor:(UIColor *)color
{
    _colorRect.hidden = YES;
    
    CGPoint centerInSuperview = [self.view convertPoint:point fromView:_colorPicker];
    CGPoint pointInStripView = [_ledStripView convertPoint:centerInSuperview fromView:self.view];
    [_ledStripView setLEDColor:color atPoint:pointInStripView];

}

@end
