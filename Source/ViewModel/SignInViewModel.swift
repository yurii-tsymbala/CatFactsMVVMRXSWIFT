//
//  SignInViewModel.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignInViewModelType {
  var emailPlaceholder: String { get }
  var passwordPlaceholder: String { get }
  var signInBtnTitle: String { get }
  var emailInput: BehaviorRelay<String> { get }
  var passwordInput: BehaviorRelay<String> { get }
  var onFinish: PublishSubject<Void> { get }
  func signIn()
}

class SignInViewModel: SignInViewModelType {
  private struct Strings {
    static let btnTitle = NSLocalizedString("Sign In", comment: "")
    static let emailPlaceholder = NSLocalizedString("Email", comment: "")
    static let passwordPlaceholder = NSLocalizedString("Password", comment: "")
  }

  private let userDefaultsService: UserDefaultsService

  init(userDefaultsService: UserDefaultsService) {
    self.userDefaultsService = userDefaultsService
  }

  let emailPlaceholder = Strings.emailPlaceholder
  let passwordPlaceholder = Strings.passwordPlaceholder
  let signInBtnTitle = Strings.btnTitle
  var emailInput = BehaviorRelay<String>(value: "")
  var passwordInput = BehaviorRelay<String>(value: "")
  var onFinish = PublishSubject<Void>()

  func signIn() {
    userDefaultsService.signIn(withEmail: emailInput.value,
                               withPassword: passwordInput.value) { [weak self] userDefaultsServiceResult in
                                guard let strongSelf = self else {return}
                                switch userDefaultsServiceResult {
                                case .success(_):
                                  strongSelf.onFinish.onNext(())
                                case .failure(let error):
                                  print("Error = \(error.rawValue)") // закинути ці дані в алерт і презентнути
                                }
    }
  }
}

