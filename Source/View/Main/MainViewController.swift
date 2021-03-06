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
  private var router: Router!
  private var myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)

  convenience init(withViewModel viewModel: MainViewModelType,withRouter router: Router) {
    self.init()
    self.router = router
    self.viewModel = viewModel
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    setupActivityIndicator()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    observeViewModel()
    viewModel.fetchData()
  }

  private func observeViewModel() {
    viewModel.startAnimating
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else {return}
        DispatchQueue.main.async {
          strongSelf.startAnimating()
        }
        }, onCompleted: { [weak self] in
          guard let strongSelf = self else {return}
          DispatchQueue.main.async {
            strongSelf.stopAnimating()
          }
      }).disposed(by: disposeBag)
    viewModel.onFinish
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.doneCallback?()
      })
      .disposed(by: disposeBag)
    viewModel.reloadData
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        DispatchQueue.main.async {
          strongSelf.tableView.reloadData()
        }
      })
      .disposed(by: disposeBag)
    viewModel.showCatDetail
      .subscribe(onNext: { [weak self] catDetailViewModel in
        guard let strongSelf = self else { return }
        strongSelf.showCatDetail(withViewModel: catDetailViewModel)
      })
      .disposed(by: disposeBag)
    viewModel.showAlert
      .subscribe(onNext: { [weak self] alertViewModel in
        guard let strongSelf = self else { return }
        DispatchQueue.main.async {
          strongSelf.showAlert(withViewModel: alertViewModel)
        }
      })
      .disposed(by: disposeBag)
  }

  private func setupView() {
    view.backgroundColor = ViewConfig.Colors.background
    myActivityIndicator.startAnimating()
    setupNavigationBar()
    setupTableView()
  }

  private func setupActivityIndicator() {
    myActivityIndicator.center = CGPoint(x:view.bounds.size.width/2.0,
                                         y: view.bounds.size.height/2.0);
    view.addSubview(myActivityIndicator)
  }

  private func startAnimating() {
    self.myActivityIndicator.isHidden = false
    myActivityIndicator.startAnimating()
    userIteractionEnabled(isEnabled: false)
  }

  private func stopAnimating() {
    myActivityIndicator.stopAnimating()
    myActivityIndicator.isHidden = true
    userIteractionEnabled(isEnabled: true)
  }

  private func userIteractionEnabled(isEnabled: Bool) {
    tableView.isUserInteractionEnabled = isEnabled
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = true
    tableView.allowsMultipleSelection = false
    tableView.backgroundView?.backgroundColor = ViewConfig.Colors.background
    tableView.backgroundColor = ViewConfig.Colors.background
    tableView.separatorColor = ViewConfig.Colors.grayDarkAlpha
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

  private func showCatDetail(withViewModel viewModel: CatDetailViewModel) {
    let catDetailViewController = CatDetailViewController(viewModel: viewModel)
    navigationController?.pushViewController(catDetailViewController, animated: true)
  }

  private func showAlert(withViewModel viewModel: AlertViewModel ) {
    router.showAlert(viewModel, inViewController: self)
  }
}

extension MainViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfCells
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: catTableViewCellId, for: indexPath)
    if let catTableCell = cell as? CatTableViewCell {
      catTableCell.viewModel = viewModel.getCellViewModel(atIndex: indexPath.row)
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.selectCat(atIndex: indexPath.row)
  }
}
