//
//  ModalViewController.swift
//  Demo
//
//  Created by Andrea Mazzini on 13/05/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
  @IBOutlet weak var closeButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
  }
  
  @IBAction func closeAction(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
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
