//
//  CatDetailViewController.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/5/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class CatDetailViewController: UIViewController {

  private var viewModel: CatDetailViewModel!

  convenience init(viewModel: CatDetailViewModel) {
    self.init()
    self.viewModel = viewModel
  }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
