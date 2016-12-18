//
//  CircleView.h
//  Popping
//
//  Created by André Schneider on 21.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property(nonatomic) UIColor *strokeColor;
@property(nonatomic) CAShapeLayer *circleLayer;

- (void)setStrokeEnd:(CGFloat)strokeEnd;

@end
