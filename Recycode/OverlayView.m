//
//  OverlayView.m
//  Recycode
//
//  Created by Angel Genov on 1/8/14.
//  Copyright (c) 2014 recycode. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    
    CGContextSetLineWidth(context, 1.0);
    //grid
/*
    CGContextMoveToPoint(context, 0,0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, 0,284);
    CGContextAddLineToPoint(context, 320, 284);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0,568);
    CGContextAddLineToPoint(context, 320, 568);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, 0,284-240);
    CGContextAddLineToPoint(context, 320, 284-240);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, 0,284+240);
    CGContextAddLineToPoint(context, 320, 284+240);
    CGContextStrokePath(context);
*/
    
    //real
    CGContextMoveToPoint(context, 0,250);
    CGContextAddLineToPoint(context, 320, 250);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0,318);
    CGContextAddLineToPoint(context, 320, 318);
    CGContextStrokePath(context);
    
/*
    CGContextMoveToPoint(context, 0,286);
    CGContextAddLineToPoint(context, 640, 286);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, 0,354);
    CGContextAddLineToPoint(context, 640, 354);
    CGContextStrokePath(context);
 */

}


@end
