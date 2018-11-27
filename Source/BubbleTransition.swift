//
//  BubbleTransition.swift
//  BubbleTransition
//
//  Created by Andrea Mazzini on 04/04/15.
//  Copyright (c) 2015-2018 Fancy Pixel. All rights reserved.
//

import UIKit

/**
 A custom modal transition that presents and dismiss a controller with an expanding bubble effect.
 
 - Prepare the transition:
 ```swift
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   let controller = segue.destination
   controller.transitioningDelegate = self
   controller.modalPresentationStyle = .custom
 }
 ```
 - Implement UIViewControllerTransitioningDelegate:
 ```swift
   func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
   transition.transitionMode = .present
   transition.startingPoint = someButton.center
   transition.bubbleColor = someButton.backgroundColor!
   return transition
 }
 
 func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
   transition.transitionMode = .dismiss
   transition.startingPoint = someButton.center
   transition.bubbleColor = someButton.backgroundColor!
   return transition
 }
 ```
 */
open class BubbleTransition: NSObject {
  
  /**
   The point that originates the bubble. The bubble starts from this point
   and shrinks to it on dismiss
   */
  @objc open var startingPoint = CGPoint.zero {
    didSet {
      bubble.center = startingPoint
    }
  }
  
  /**
   The transition duration. The same value is used in both the Present or Dismiss actions
   Defaults to `0.5`
   */
  @objc open var duration = 0.5
  
  /**
   The transition direction. Possible values `.present`, `.dismiss` or `.pop`
   Defaults to `.Present`
   */
  @objc open var transitionMode: BubbleTransitionMode = .present
  
  /**
   The color of the bubble. Make sure that it matches the destination controller's background color.
   */
  @objc open var bubbleColor: UIColor = .white
  
  open fileprivate(set) var bubble = UIView()
  
  /**
   The possible directions of the transition.
   
   - Present: For presenting a new modal controller
   - Dismiss: For dismissing the current controller
   - Pop: For a pop animation in a navigation controller
   */
  @objc public enum BubbleTransitionMode: Int {
    case present, dismiss, pop
  }
}


/// The interactive swipe direction
///
/// - up: swipe up
/// - down: swipe down
public enum BubbleInteractiveTransitionSwipeDirection: CGFloat {
  case up = -1
  case down = 1
}

/**
 Handles the interactive dismissal of the presented controller via swipe
 
 - Prepare the interactive transaction:
 
 ```swift
 let interactiveTransition = BubbleInteractiveTransition()

 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   let controller = segue.destination
   controller.transitioningDelegate = self
   controller.modalPresentationStyle = .custom
   interactiveTransition.attach(to: controller)
 }
 ```
 
 and implement the appropriate delegate method:
 ```swift
 func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
   return interactiveTransition
 }
 ```
 */
open class BubbleInteractiveTransition: UIPercentDrivenInteractiveTransition {
  fileprivate var interactionStarted = false
  fileprivate var interactionShouldFinish = false
  fileprivate var controller: UIViewController?
  
  /// The threshold that grants the dismissal of the controller. Values from 0 to 1
  open var interactionThreshold: CGFloat = 0.3
  
  /// The swipe direction
  open var swipeDirection: BubbleInteractiveTransitionSwipeDirection = .down
  
  /// Attach the swipe gesture to a controller
  ///
  /// - Parameter to: the target controller
  open func attach(to: UIViewController) {
    controller = to
    controller?.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(BubbleInteractiveTransition.handlePan(gesture:))))
    if #available(iOS 10.0, *) {
      wantsInteractiveStart = false
    }
  }
  
  @objc func handlePan(gesture: UIPanGestureRecognizer) {
    guard let controller = controller, let view = controller.view else { return }
    
    let translation = gesture.translation(in: controller.view.superview)
    
    let delta = swipeDirection.rawValue * (translation.y / view.bounds.height)
    let movement = fmaxf(Float(delta), 0.0)
    let percent = fminf(movement, 1.0)
    let progress = CGFloat(percent)
  
    switch gesture.state {
    case .began:
      interactionStarted = true
      controller.dismiss(animated: true, completion: nil)
    case .changed:
      interactionShouldFinish = progress > interactionThreshold
      update(progress)
    case .cancelled:
      interactionShouldFinish = false
      fallthrough
    case .ended:
      interactionStarted = false
      interactionShouldFinish ? finish() : cancel()
    default:
      break
    }
  }
}

extension BubbleTransition: UIViewControllerAnimatedTransitioning {
  
  // MARK: - UIViewControllerAnimatedTransitioning
  
  /**
   Required by UIViewControllerAnimatedTransitioning
   */
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  /**
   Required by UIViewControllerAnimatedTransitioning
   */
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    
    let fromViewController = transitionContext.viewController(forKey: .from)
    let toViewController = transitionContext.viewController(forKey: .to)
    
    if transitionMode == .present {
      fromViewController?.beginAppearanceTransition(false, animated: true)
      if toViewController?.modalPresentationStyle == .custom {
        toViewController?.beginAppearanceTransition(true, animated: true)
      }
      
      let presentedControllerView = transitionContext.view(forKey: .to)!
      let originalCenter = presentedControllerView.center
      let originalSize = presentedControllerView.frame.size
      
      bubble = UIView()
      bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
      bubble.layer.cornerRadius = bubble.frame.size.height / 2
      bubble.center = startingPoint
      bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
      bubble.backgroundColor = bubbleColor
      containerView.addSubview(bubble)
      
      presentedControllerView.center = startingPoint
      presentedControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
      presentedControllerView.alpha = 0
      containerView.addSubview(presentedControllerView)
      
      UIView.animate(withDuration: duration, animations: {
        self.bubble.transform = CGAffineTransform.identity
        presentedControllerView.transform = CGAffineTransform.identity
        presentedControllerView.alpha = 1
        presentedControllerView.center = originalCenter
      }, completion: { (_) in
        transitionContext.completeTransition(true)
        self.bubble.isHidden = true
        if toViewController?.modalPresentationStyle == .custom {
          toViewController?.endAppearanceTransition()
        }
        fromViewController?.endAppearanceTransition()
      })
    } else {
      if fromViewController?.modalPresentationStyle == .custom {
        fromViewController?.beginAppearanceTransition(false, animated: true)
      }
      toViewController?.beginAppearanceTransition(true, animated: true)
      
      let key: UITransitionContextViewKey = (transitionMode == .pop) ? .to : .from
      let returningControllerView = transitionContext.view(forKey: key)!
      let originalCenter = returningControllerView.center
      let originalSize = returningControllerView.frame.size
      
      bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
      bubble.layer.cornerRadius = bubble.frame.size.height / 2
      bubble.backgroundColor = bubbleColor
      bubble.center = startingPoint
      bubble.isHidden = false
      
      UIView.animate(withDuration: duration, animations: {
        self.bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        returningControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        returningControllerView.center = self.startingPoint
        returningControllerView.alpha = 0
        
        if self.transitionMode == .pop {
          containerView.insertSubview(returningControllerView, belowSubview: returningControllerView)
          containerView.insertSubview(self.bubble, belowSubview: returningControllerView)
        }
      }, completion: { (completed) in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        
        if !transitionContext.transitionWasCancelled {
          returningControllerView.center = originalCenter
          returningControllerView.removeFromSuperview()
          self.bubble.removeFromSuperview()

          if fromViewController?.modalPresentationStyle == .custom {
            fromViewController?.endAppearanceTransition()
          }
          toViewController?.endAppearanceTransition()
        }
      })
    }
  }
}

private extension BubbleTransition {
  func frameForBubble(_ originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
    let lengthX = fmax(start.x, originalSize.width - start.x)
    let lengthY = fmax(start.y, originalSize.height - start.y)
    let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
    let size = CGSize(width: offset, height: offset)
    
    return CGRect(origin: CGPoint.zero, size: size)
  }
}
