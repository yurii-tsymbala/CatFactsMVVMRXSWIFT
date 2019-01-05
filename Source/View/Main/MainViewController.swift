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
    setupView()
    observeViewModel()
  }

  private func observeViewModel() {
    viewModel
      .onFinish
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.doneCallback?()
        print("esketit")
      })
      .disposed(by: disposeBag)
  }

  private func setupView() {
    setupNavigationBar()
  }

  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(logOut))
    navigationItem.title = "Cat Facts"
  }

  @objc func logOut() {
    viewModel.logOut()
  }
}
