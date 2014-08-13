//
//  ColorPicker.h
//  LELights
//
//  Created by Laura Skelton on 8/10/14.
//  Copyright (c) 2014 lauraskelton. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ColorPickerDelegate <NSObject>

- (void)droppedAtPoint:(CGPoint)point withColor:(UIColor *)color;
- (void)startPickingAtPoint:(CGPoint)point color:(UIColor *)color;
- (void)movedPickerToPoint:(CGPoint)point color:(UIColor *)color;

@end

@interface ColorPicker : UIImageView

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly, retain) UIColor* lastSelectedColor;

@end