//
//  BubbleTransition.swift
//  BubbleTransition
//
//  Created by Andrea Mazzini on 04/04/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit

/**
A custom modal transition that presents and dismiss a controller with an expanding bubble effect.
*/
public class BubbleTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    /**
    The point that originates the bubble.
    */
    public var startingPoint = CGPointZero
    
    /**
    The transition duration.
    */
    public var duration = 0.5
    
    /**
    The transition direction. Either `.Present` or `.Dismiss.`
    */
    public var transitionMode: BubbleTransitionMode = .Present
    
    /**
    The color of the bubble. Make sure that it matches the destination controller's background color.
    */
    public var bubbleColor: UIColor = .whiteColor()
    
    private var bubble: UIView?
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    /**
    Required by UIViewControllerAnimatedTransitioning
    */
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    /**
    Required by UIViewControllerAnimatedTransitioning
    */
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        
        if transitionMode == .Present {
            let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            let originalCenter = presentedControllerView.center
            let originalSize = presentedControllerView.frame.size
            let lengthX = fmax(startingPoint.x, originalSize.width - startingPoint.x);
            let lengthY = fmax(startingPoint.y, originalSize.height - startingPoint.y)
            let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
            let size = CGSize(width: offset, height: offset)
            bubble = UIView(frame: CGRect(origin: CGPointZero, size: size))
            bubble!.layer.cornerRadius = size.height / 2
            bubble!.center = startingPoint
            bubble!.transform = CGAffineTransformMakeScale(0.001, 0.001)
            bubble!.backgroundColor = bubbleColor
            containerView.addSubview(bubble!)
            
            presentedControllerView.center = startingPoint
            presentedControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
            presentedControllerView.alpha = 0
            containerView.addSubview(presentedControllerView)
            
            UIView.animateWithDuration(duration, animations: {
                self.bubble!.transform = CGAffineTransformIdentity
                presentedControllerView.transform = CGAffineTransformIdentity
                presentedControllerView.alpha = 1
                presentedControllerView.center = originalCenter
                }) { (_) -> Void in
                    transitionContext.completeTransition(true)
            }
        } else if transitionMode == .Pop {
            let returningController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            let returningControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            
            UIView.animateWithDuration(duration, animations: {
                
                self.bubble!.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.center = self.startingPoint
                returningControllerView.alpha = 0
                
                containerView.insertSubview(toController.view, belowSubview: returningControllerView)
                containerView.insertSubview(self.bubble!, belowSubview: returningControllerView)
                
                
                }) { (_) -> Void in
                    returningControllerView.removeFromSuperview()
                    self.bubble!.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        } else {
            let returningController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            let returningControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            
            UIView.animateWithDuration(duration, animations: {
                self.bubble!.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.center = self.startingPoint
                returningControllerView.alpha = 0
                }) { (_) -> Void in
                    returningControllerView.removeFromSuperview()
                    self.bubble!.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        }
    }
    
    /**
    The possible directions of the transition
    */
    @objc public enum BubbleTransitionMode: Int {
        case Present, Dismiss, Pop
    }
}
