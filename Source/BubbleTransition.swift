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
    public var startingPoint = CGPointZero {
        didSet {
            if let bubble = bubble {
                bubble.center = startingPoint
            }
        }
    }
    
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
            let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            let originalCenter = presentedControllerView.center
            let originalSize = presentedControllerView.frame.size

            bubble = UIView(frame: frameForBubble(originalCenter, size: originalSize, start: startingPoint))
            bubble!.layer.cornerRadius = bubble!.frame.size.height / 2
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
            let returningControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size

            bubble!.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble!.layer.cornerRadius = bubble!.frame.size.height / 2
            bubble!.center = startingPoint

            UIView.animateWithDuration(duration, animations: {
                self.bubble!.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.center = self.startingPoint
                returningControllerView.alpha = 0
                
                containerView.insertSubview(returningControllerView, belowSubview: returningControllerView)
                containerView.insertSubview(self.bubble!, belowSubview: returningControllerView)
                }) { (_) -> Void in
                    returningControllerView.removeFromSuperview()
                    self.bubble!.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        } else {
            let returningControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size

            bubble!.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble!.layer.cornerRadius = bubble!.frame.size.height / 2
            bubble!.center = startingPoint

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

private extension BubbleTransition {
    private func frameForBubble(originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x);
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
        let size = CGSize(width: offset, height: offset)

        return CGRect(origin: CGPointZero, size: size)
    }
}
