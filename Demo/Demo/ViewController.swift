//
//  ViewController.swift
//  Demo
//
//  Created by Andrea Mazzini on 13/05/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import BubbleTransition

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
  @IBOutlet weak var transitionButton: UIButton!
  
  let transition = BubbleTransition()
  let interactiveTransition = BubbleInteractiveTransition()
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? ModalViewController {
      controller.transitioningDelegate = self
      controller.modalPresentationStyle = .custom
      controller.interactiveTransition = interactiveTransition
      interactiveTransition.attach(to: controller)
    }
  }
  
  // MARK: UIViewControllerTransitioningDelegate
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint = transitionButton.center
    transition.bubbleColor = transitionButton.backgroundColor!
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = transitionButton.center
    transition.bubbleColor = transitionButton.backgroundColor!
    return transition
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactiveTransition
  }
  
}

