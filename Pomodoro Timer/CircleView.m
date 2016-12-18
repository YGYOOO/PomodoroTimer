//
//  CircleView.m
//  Popping
//
//  Created by André Schneider on 21.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "CircleView.h"
#import <POP/POP.h>

@interface CircleView()
- (void)addCircleLayer;
//- (void)animateToStrokeEnd:(CGFloat)strokeEnd;
@end

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self addCircleLayer];
      [self setStrokeColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setStrokeEnd:(CGFloat)strokeEnd
{
//    if (animated) {
//        [self animateToStrokeEnd:strokeEnd];
//        return;
//    }
    self.circleLayer.strokeEnd = strokeEnd;
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    self.circleLayer.strokeColor = strokeColor.CGColor;
    _strokeColor = strokeColor;
}

- (void)addCircleLayer
{
    CGFloat lineWidth = 10.f;
    CGFloat radius = CGRectGetWidth(self.bounds)/2 - lineWidth/2 + 1;
    self.circleLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(lineWidth/2 - 1, lineWidth/2 - 1, radius * 2, radius * 2);
    self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                  cornerRadius:radius].CGPath;

    self.circleLayer.strokeColor = self.tintColor.CGColor;
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineWidth = lineWidth;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.lineJoin = kCALineJoinRound;

    [self.layer addSublayer:self.circleLayer];
}


//- (void)animateToStrokeEnd:(CGFloat)strokeEnd
//{
//    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
//    strokeAnimation.toValue = @(strokeEnd);
//    strokeAnimation.springBounciness = 12.f;
//    strokeAnimation.removedOnCompletion = NO;
//    [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
//}

@end
