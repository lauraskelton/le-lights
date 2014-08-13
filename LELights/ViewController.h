//
//  ViewController.h
//  LELights
//
//  Created by Laura Skelton on 8/10/14.
//  Copyright (c) 2014 lauraskelton. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ColorPicker.h"
#import "LEDStripView.h"
#import "ColorLoupe.h"

@interface ViewController : UIViewController <ColorPickerDelegate>

@property (nonatomic, retain) IBOutlet ColorPicker *colorPicker;
@property (nonatomic, retain) IBOutlet ColorLoupe *colorRect;
@property (nonatomic, retain) IBOutlet LEDStripView *ledStripView;

@end
