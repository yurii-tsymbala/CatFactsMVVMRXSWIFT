//
//  AlertViewController.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/5/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class AlertViewController: UIAlertController {

  var viewModel: AlertViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = viewModel?.title
    message = viewModel?.message
    addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
  }
}
