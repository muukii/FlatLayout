//
//  ViewController.swift
//  FlatLayoutDemo
//
//  Created by muukii on 9/17/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

import FlatLayout

final class View : UIView {

  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.init(white: 0, alpha: 0.1)
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    var context = Context.init(root: view)

    BackgroundLayoutSpec(
      background: View(),
      child: InsetLayoutSpec(
          insets: .init(top: 8, left: 8, bottom: 8, right: 8),
          child: BackgroundLayoutSpec(
            background: View(),
            child: InsetLayoutSpec(
              insets: .init(top: 8, left: 8, bottom: 8, right: 8),
              child: View()
            )
        )
      )
      )
      .applyLayout(context: &context, parent: view)


  }

}

