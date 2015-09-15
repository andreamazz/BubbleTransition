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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }

    // MARK: UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }

}

