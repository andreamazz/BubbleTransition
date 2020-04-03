// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "BubbleTransition",
  products: [
    .library(
      name: "BubbleTransition",
      targets: ["BubbleTransition"])
  ],
  targets: [
    .target(
      name: "BubbleTransition",
      path: "Source")
  ]
)