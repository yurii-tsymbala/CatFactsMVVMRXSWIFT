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
  private let catTableViewCellId = "CatTableViewCell"

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
    viewModel.onFinish
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.doneCallback?()
      })
      .disposed(by: disposeBag)
    viewModel.reloadData
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.tableView.reloadData()
      })
      .disposed(by: disposeBag)
    viewModel.showCatDetail
      .subscribe(onNext: { [weak self] catDetailViewModel in
        guard let strongSelf = self else { return }
        strongSelf.showCatDetail(withViewModel: catDetailViewModel)
      })
      .disposed(by: disposeBag)
  }

  private func showCatDetail(withViewModel viewModel: CatDetailViewModel) {
    let catDetailViewController = CatDetailViewController(viewModel: viewModel)
    navigationController?.pushViewController(catDetailViewController, animated: true)
  }

  private func setupView() {
    view.backgroundColor = ViewConfig.Colors.background
    setupNavigationBar()
    setupTableView()
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = true
    tableView.allowsMultipleSelection = false
    tableView.backgroundView?.backgroundColor = ViewConfig.Colors.background
    tableView.backgroundColor = ViewConfig.Colors.background
    let catCellNib = UINib(nibName: catTableViewCellId, bundle: nil)
    tableView.register(catCellNib, forCellReuseIdentifier: catTableViewCellId)
    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableView.automaticDimension
  }

  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.navigationItemRightBarButtonItemTitle,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(logOut))
    navigationItem.title = viewModel.navigatiomItemTitle
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

extension MainViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfCells
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: catTableViewCellId, for: indexPath) as! CatTableViewCell
    cell.viewModel = viewModel.getCellViewModel(at: indexPath.row)
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.selectCat(atIndex: indexPath.row)
  }
}
