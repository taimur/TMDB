//
//  UIViewControllerTapExtension.swift
//  TMDB
//
//  Created by Taimur Ajmal on 10/2/18.
//  Copyright © 2018 Taimur Ajmal. All rights reserved.
//

import UIKit

extension UIViewController {
  func hideKeyboardOnTap() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
