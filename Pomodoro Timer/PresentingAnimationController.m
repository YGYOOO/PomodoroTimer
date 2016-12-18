//
//  PresentingAnimationController.m
//  POPDemo
//
//  Created by Hossam Ghareeb on 12/14/14.
//  Copyright (c) 2014 Hossam Ghareeb. All rights reserved.
//

#import "PresentingAnimationController.h"

@implementation PresentingAnimationController


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2;
}



- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.frame = CGRectMake(0,
                              0,
                              CGRectGetHeight(transitionContext.containerView.bounds) * 1.2,
                              CGRectGetHeight(transitionContext.containerView.bounds) * 1.2);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGPoint p = CGPointMake(screenRect.size.width, 0);
    toView.center = _centerPoint;
    
    [transitionContext.containerView addSubview:toView];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(transitionContext.containerView.center.y);
    positionAnimation.springSpeed = 3;
    positionAnimation.springBounciness = 5;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
  
    POPSpringAnimation *positionAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation2.toValue = @(transitionContext.containerView.center.x);
    positionAnimation2.springSpeed = 3;
    positionAnimation2.springBounciness = 5;
    [positionAnimation2 setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
      [transitionContext completeTransition:YES];
    }];
  
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.springSpeed = 3;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(.1, .1)];
  
    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toView.layer pop_addAnimation:positionAnimation2 forKey:@"positionAnimation2"];
    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

@end
