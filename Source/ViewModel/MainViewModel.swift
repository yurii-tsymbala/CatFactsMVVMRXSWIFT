//
//  MainViewModel.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelType {
  var navigatiomItemTitle: String { get }
  var navigationItemRightBarButtonItemTitle: String { get}
  var onFinish: PublishSubject<Void> { get }
  var reloadData: PublishSubject<Void> { get }
  var showCatDetail: PublishSubject<CatDetailViewModel> { get }
  func logOut()
}

class MainViewModel : MainViewModelType {
  private struct Strings {
    static let navigatiomItemTitle = NSLocalizedString("Cat Facts", comment: "")
    static let navigationItemRightBarButtonItemTitle = NSLocalizedString("Log Out", comment: "")
  }
  private let downloadService: DownloadServiceType
  var navigationItemRightBarButtonItemTitle = Strings.navigationItemRightBarButtonItemTitle
  var navigatiomItemTitle = Strings.navigatiomItemTitle

  private var cellViewModels: [CatCellViewModel] = []

  var onFinish = PublishSubject<Void>()
  var reloadData = PublishSubject<Void>()
  var showCatDetail = PublishSubject<CatDetailViewModel>()

  var numberOfCells: Int {
    return cellViewModels.count
  }

  init(downloadService: DownloadServiceType) {
    self.downloadService = downloadService
    fetchData()
  }

  func selectCat(atIndex index: Int) {
    guard index >= 0 && index < cellViewModels.count else {return}
    let catDetail = CatDetailViewModel(name: cellViewModels[index].name,
                                       text: cellViewModels[index].text)
    showCatDetail.onNext(catDetail)
  }

  func getCellViewModel(at index: Int) -> CatCellViewModel {
    return cellViewModels[index]
  }

  private func fetchData() {
    downloadService.fetchDataFromJSON { [weak self] fetchResult in
      guard let strongSelf = self else {return}
      switch fetchResult {
      case .success(let catCellViewModels):
        strongSelf.cellViewModels = catCellViewModels
        print("success")
      case .failure(let errror):
        print(errror)
      }
    }
  }

  func logOut() {
    onFinish.onNext(())
  }
  
}
