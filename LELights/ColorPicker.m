//
//  ColorPicker.m
//  LELights
//
//  Created by Laura Skelton on 8/10/14.
//  Copyright (c) 2014 lauraskelton. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ColorPicker.h"

@implementation ColorPicker

@synthesize lastSelectedColor=_lastSelectedColor;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"hue568"]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (CGContextRef)createBitmapContextFromImage:(CGImageRef)hueImage {
	
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	size_t pixelsWide = CGImageGetWidth(hueImage);
	size_t pixelsHigh = CGImageGetHeight(hueImage);
	
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
    
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
	// per component. Regardless of what the source image format is
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	if (context == NULL)
	{
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	CGColorSpaceRelease( colorSpace );
	
	return context;
}


- (UIColor*)getPixelColorAtLocation:(CGPoint)point {
	UIColor* color = nil;
    
	CGImageRef hueImage = [[self image] CGImage];
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = [self createBitmapContextFromImage:hueImage];
	if (cgctx == NULL) { return nil; /* error */ }
	
    size_t w = CGImageGetWidth(hueImage);
	size_t h = CGImageGetHeight(hueImage);
	CGRect rect = {{0,0},{w,h}};
	
	// Draw the image to the bitmap context. Once we draw, the memory
	// allocated for the context for rendering will then contain the
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, hueImage);
	
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	unsigned char* data = CGBitmapContextGetData (cgctx);
	if (data != NULL && data != 0) {
		//offset locates the pixel in the data from x,y.
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int offset = 4*((w*round(point.y))+round(point.x));
		int alpha =  data[offset];
		int red = data[offset+1];
		int green = data[offset+2];
		int blue = data[offset+3];
		//NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
		color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
	}
	
	// When finished, release the context
	CGContextRelease(cgctx);
	// Free image data memory for the context
	if (data) { free(data); }
	
	return color;
}

-(void)getColorFromPoint:(CGPoint)point
{
    CGRect r = self.frame;
    r.origin = CGPointZero;
    
    if (CGRectContainsPoint(r, point)) {
        UIColor *color = [self getPixelColorAtLocation:point];
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        if (components[3] != 0) {
            _lastSelectedColor = color;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self getColorFromPoint:point];
    
    [_delegate startPickingAtPoint:point color:_lastSelectedColor];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self getColorFromPoint:point];
    
    [_delegate movedPickerToPoint:point color:_lastSelectedColor];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self]; //where image was tapped
    
    [self getColorFromPoint:point];
    
    [_delegate droppedAtPoint:point withColor:_lastSelectedColor];
    
}

@end
