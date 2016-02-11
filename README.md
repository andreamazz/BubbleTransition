# BubbleTransition

[![CI Status](http://img.shields.io/travis/王易平/BubbleTransition.svg?style=flat)](https://travis-ci.org/王易平/BubbleTransition)
[![Version](https://img.shields.io/cocoapods/v/BubbleTransition.svg?style=flat)](http://cocoapods.org/pods/BubbleTransition)
[![License](https://img.shields.io/cocoapods/l/BubbleTransition.svg?style=flat)](http://cocoapods.org/pods/BubbleTransition)
[![Platform](https://img.shields.io/cocoapods/p/BubbleTransition.svg?style=flat)](http://cocoapods.org/pods/BubbleTransition)

An objective-C version of [andreamazz/BubbleTransition](https://github.com/andreamazz/BubbleTransition). A custom modal transition that presents and dismiss a controller inside an expanding and shrinking _bubble_.

# Screenshot
![BubbleTransition](https://raw.githubusercontent.com/epingwang/BubbleTransision/master/Pod/Assets/screenshot.gif)

## Usage

Install through [CocoaPods](http://cocoapods.org)
```ruby
pod 'BubbleTransition-objc', '~> 0.1'
```

## Installation

Have your viewcontroller conform to `UIViewControllerTransitioningDelegate`. Set the `transitionMode`, the `startingPoint`, the `bubbleColor` and the `duration`.
```objc

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = segue.destinationViewController;
    controller.transitioningDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transition.transitionMode = YPBubbleTransitionModePresent;
    self.transition.startPoint = someButton.center;
    self.transition.bubbleColor = someButton.backgroundColor;
    return self.transition;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transition.transitionMode = YPBubbleTransitionModeDismiss;
    self.transition.startPoint = someButton.center;
    self.transition.bubbleColor = someButton.backgroundColor;
    return self.transition;
}


```

#Properties
```objc
CGPoint startPoint = CGPointZero;
```
The point that originates the bubble.

```objc
CGFloat duration = 0.5;
```
The transition duration.

```objc
YPBubbleTransitionMode transitionMode = YPBubbleTransitionModePresent;
```
The transition direction. Either `YPBubbleTransitionModePresent` or `YPBubbleTransitionModeDismiss`.

```swift
UIColor *bubbleColor = [UIColor whiteColor];
```
The color of the bubble. Make sure that it matches the destination controller's background color.  

Checkout the sample project for the full implementation.

## Author

epingwang

## License

BubbleTransition is available under the MIT license. See the LICENSE file for more info.
