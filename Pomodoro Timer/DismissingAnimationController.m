//
//  DismissingAnimationController.m
//  POPDemo
//
//  Created by Hossam Ghareeb on 12/14/14.
//  Copyright (c) 2014 Hossam Ghareeb. All rights reserved.
//

#import "DismissingAnimationController.h"
#import "POP.h"

@implementation DismissingAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.75;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toView.userInteractionEnabled = YES;
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    
    POPBasicAnimation *closeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    closeAnimation.toValue = @(0);
    [closeAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
  
  POPBasicAnimation *closeAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
  closeAnimation2.toValue = @(self.transitionX);
  
    POPSpringAnimation *scaleDownAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleDownAnimation.springBounciness = 5;
  scaleDownAnimation.springSpeed = 3;
    scaleDownAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(.1, .1)];
    
    [fromView.layer pop_addAnimation:closeAnimation forKey:@"closeAnimation"];
  [fromView.layer pop_addAnimation:closeAnimation2 forKey:@"closeAnimation2"];
    [fromView.layer pop_addAnimation:scaleDownAnimation forKey:@"scaleDown"];
 
}

@end
