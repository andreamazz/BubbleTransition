//
//  ModalViewController.swift
//  Demo
//
//  Created by Andrea Mazzini on 13/05/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import BubbleTransition

class ModalViewController: UIViewController {
  @IBOutlet weak var closeButton: UIButton!
  weak var interactiveTransition: BubbleInteractiveTransition?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
  }
  
  @IBAction func closeAction(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    
    // NOTE: when using interactive gestures, if you want to dismiss with a button instead, you need to call finish on the interactive transition to avoid having the animation stuck
    interactiveTransition?.finish()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.setStatusBarStyle(.default, animated: true)
  }
}
