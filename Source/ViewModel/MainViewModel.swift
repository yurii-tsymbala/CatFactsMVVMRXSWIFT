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
  func logOut()
  var onFinish: PublishSubject<Void> { get }
}

class MainViewModel : MainViewModelType {
  var onFinish = PublishSubject<Void>()

  func logOut() {
    onFinish.onNext(())
  }
  
}
