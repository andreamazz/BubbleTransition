<p align="center">
  <img src="assets/logo.png"/>
</p>

[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/BubbleTransition/badge.svg)](http://cocoapods.org/?q=bubbletransition)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A custom modal transition that presents and dismiss a controller inside an expanding and shrinking _bubble_.

# Screenshot
![BubbleTransition](https://raw.githubusercontent.com/andreamazz/BubbleTransition/master/assets/screenshot.gif)

# Usage
Install through [Cocoapods](http://cocoapods.org)
```
pod 'BubbleTransition', '~> 0.1'

use_frameworks!
```
#Setup
Have your viewcontroller conform to `UIViewControllerTransitioningDelegate`. Set the `transitionMode`, the `startingPoint`, the `bubbleColor` and the `duration`.
```swift
let transition = BubbleTransition()

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let controller = segue.destinationViewController as? UIViewController {
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
}

// MARK: UIViewControllerTransitioningDelegate

func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .Present
    transition.startingPoint = someButton.center
    transition.bubbleColor = someButton.backgroundColor!
    return transition
}

func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .Dismiss
    transition.startingPoint = someButton.center
    transition.bubbleColor = someButton.backgroundColor!
    return transition
}
```

You can find the Objective-C equivalent [here](https://gist.github.com/andreamazz/9b0d6c7db065555ec0d7).

#Properties
```swift
var startingPoint = CGPointZero
```
The point that originates the bubble.

```swift
var duration = 0.5
```
The transition duration.

```swift
var transitionMode: BubbleTranisionMode = .Present
```
The transition direction. Either `.Present` or `.Dismiss`.

```swift
var bubbleColor: UIColor = .whiteColor()
```
The color of the bubble. Make sure that it matches the destination controller's background color.  

Checkout the sample project for the full implementation.

#MIT License

	Copyright (c) 2015 Andrea Mazzini. All rights reserved.

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	
