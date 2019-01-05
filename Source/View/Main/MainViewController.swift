//
//  MainViewController.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/5/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UITableViewController {
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
    view.backgroundColor = ViewConfig.Colors.background
    setupNavigationBar()
    setupTableView()
  }

  private func setupTableView() {
    tableView.allowsSelection = false
    tableView.backgroundView?.backgroundColor = ViewConfig.Colors.background
    tableView.backgroundColor = ViewConfig.Colors.background
  }

  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(logOut))
    navigationItem.title = "Cat Facts"
    navigationItem.rightBarButtonItem?.tintColor = ViewConfig.Colors.white
    navigationController?.navigationBar.barTintColor = ViewConfig.Colors.background
    navigationController?.navigationBar.backgroundColor = ViewConfig.Colors.background
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ViewConfig.Colors.white]
  }

  @objc func logOut() {
    viewModel.logOut()
  }
}
