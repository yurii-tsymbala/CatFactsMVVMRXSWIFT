//
//  MainViewController.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
  var doneCallback: (() -> Void)?
  private var viewModel: MainViewModelType!
  private let disposeBag = DisposeBag()

  convenience init(viewModel: MainViewModelType) {
    self.init()
    self.viewModel = viewModel
  }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
