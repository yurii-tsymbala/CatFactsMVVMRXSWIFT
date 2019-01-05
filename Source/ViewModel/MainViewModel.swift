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
  func logOut()
}

class MainViewModel : MainViewModelType {
  private struct Strings {
    static let navigatiomItemTitle = NSLocalizedString("Cat Facts", comment: "")
    static let navigationItemRightBarButtonItemTitle = NSLocalizedString("Log Out", comment: "")
  }
  var navigationItemRightBarButtonItemTitle = Strings.navigationItemRightBarButtonItemTitle
  var navigatiomItemTitle = Strings.navigatiomItemTitle

  var onFinish = PublishSubject<Void>()

  func logOut() {
    onFinish.onNext(())
  }
  
}
