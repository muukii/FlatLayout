//
//  LayoutSpecs.swift
//  FlatLayout
//
//  Created by muukii on 9/17/18.
//  Copyright © 2018 muukii. All rights reserved.
//

public struct Context {

  public let root: UIView

  public init(root: UIView) {
    self.root = root
  }
}

public struct Result {

  public let constraints: [NSLayoutConstraint]
}

public protocol LayoutElement {

  func applyLayout(context: inout Context, parent: UIView) -> UIView
//
//  var leadingAnchor: NSLayoutXAxisAnchor { get }
//
//  var trailingAnchor: NSLayoutXAxisAnchor { get }
//
//  var leftAnchor: NSLayoutXAxisAnchor { get }
//
//  var rightAnchor: NSLayoutXAxisAnchor { get }
//
//  var topAnchor: NSLayoutYAxisAnchor { get }
//
//  var bottomAnchor: NSLayoutYAxisAnchor { get }
//
//  var widthAnchor: NSLayoutDimension { get }
//
//  var heightAnchor: NSLayoutDimension { get }
//
//  var centerXAnchor: NSLayoutXAxisAnchor { get }
//
//  var centerYAnchor: NSLayoutYAxisAnchor { get }
//
//  var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
//
//  var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}

struct Layout {

  enum Constraint {
    case equal(to: CGFloat)
    case greaterThanOrEqual(to: CGFloat)
    case lessThanOrEqual(to: CGFloat)
  }

  let top: Constraint
  let right: Constraint
  let bottom: Constraint
  let left: Constraint

  let width: Constraint
  let height: Constraint

}

extension UIView : LayoutElement {
  public func applyLayout(context: inout Context, parent: UIView) -> UIView {
    parent.addSubview(self)
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: parent.topAnchor),
      rightAnchor.constraint(equalTo: parent.rightAnchor),
      leftAnchor.constraint(equalTo: parent.leftAnchor),
      bottomAnchor.constraint(equalTo: parent.bottomAnchor),
      ])
    return self
  }

  func safeAddSubview(_ view: UIView) {
    guard view != self else { return }
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
  }
}

public protocol LayoutSpec : LayoutElement {

}

extension LayoutSpec {

}

//public struct StackLayoutSpec : LayoutSpec {
//
//  public func apply(in context: inout Context) {
//
//  }
//
//}

//public struct OverlayLayoutSpec : LayoutSpec {
//
//  public var overlay: Node
//  public var child: Node
//
//  public init(overlay: Node, child: Node) {
//    self.overlay = overlay
//    self.child = child
//  }
//
//  public func apply(in context: inout Context) {
//
//    context.root.add(child)
//    context.root.add(overlay)
//  }
//}

public struct BackgroundLayoutSpec : LayoutSpec {

  public var background: LayoutElement
  public var child: LayoutElement

  public init(background: LayoutElement, child: LayoutElement) {
    self.background = background
    self.child = child
  }

  public func applyLayout(context: inout Context, parent: UIView) -> UIView {

    let backgroundView = background.applyLayout(context: &context, parent: parent)
    let childView = child.applyLayout(context: &context, parent: parent)

    parent.safeAddSubview(backgroundView)
//    parent.safeAddSubview(childView)

    NSLayoutConstraint.activate([
      backgroundView.topAnchor.constraint(equalTo: childView.topAnchor),
      backgroundView.rightAnchor.constraint(equalTo: childView.rightAnchor),
      backgroundView.leftAnchor.constraint(equalTo: childView.leftAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: childView.bottomAnchor),
      ])

    NSLayoutConstraint.activate([
      childView.topAnchor.constraint(equalTo: parent.topAnchor),
      childView.rightAnchor.constraint(equalTo: parent.rightAnchor),
      childView.leftAnchor.constraint(equalTo: parent.leftAnchor),
      childView.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
      ])

    return childView
  }

}

public struct InsetLayoutSpec : LayoutSpec {

  public var insets: UIEdgeInsets
  public var child: LayoutElement

  public init(insets: UIEdgeInsets, child: LayoutElement) {
    self.insets = insets
    self.child = child
  }

  public func applyLayout(context: inout Context, parent: UIView) -> UIView {

    let childView = child.applyLayout(context: &context, parent: parent)
    parent.safeAddSubview(childView)

    NSLayoutConstraint.activate([
      childView.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
      childView.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -insets.right),
      childView.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: insets.left),
      childView.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom),
      ])

    return parent
  }
}

extension LayoutSpec {


}
