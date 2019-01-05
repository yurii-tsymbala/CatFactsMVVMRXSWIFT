//
//  SignUpViewModel.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpViewModelType {
  var emailPlaceholder: String { get }
  var passwordPlaceholder: String { get }
  var passwordConfirmPlaceholder: String { get }
  var signUpBtnTitle: String { get }
  var alertTitle: String { get }
  var alertMessage: String { get }
  var emailInput: BehaviorRelay<String> { get }
  var passwordInput: BehaviorRelay<String> { get }
  var passwordConfirmInput: BehaviorRelay<String> { get }
  var showAlert: PublishSubject<AlertViewModel> { get }
  var onFinish: PublishSubject<Void> { get }
  func signUp()
}

class SignUpViewModel: SignUpViewModelType {
  private struct Strings {
    static let alertTitle = NSLocalizedString("Error", comment: "")
    static let alertMessage = NSLocalizedString("Bad Credentials", comment: "")
    static let btnTitle = NSLocalizedString("Sign Up", comment: "")
    static let emailPlaceholder = NSLocalizedString("Email", comment: "")
    static let passwordPlaceholder = NSLocalizedString("Password", comment: "")
    static let passwordConfirmPlaceholder = NSLocalizedString("Confirm Password", comment: "")
  }

  private let userDefaultsService: UserDefaultsService

  init(userDefaultsService: UserDefaultsService) {
    self.userDefaultsService = userDefaultsService
  }

  let emailPlaceholder = Strings.emailPlaceholder
  let passwordPlaceholder = Strings.passwordPlaceholder
  let passwordConfirmPlaceholder = Strings.passwordConfirmPlaceholder
  let signUpBtnTitle = Strings.btnTitle

  var alertTitle = Strings.alertTitle
  var alertMessage = Strings.alertMessage

  var emailInput = BehaviorRelay<String>(value: "")
  var passwordInput = BehaviorRelay<String>(value: "")
  var passwordConfirmInput = BehaviorRelay<String>(value: "")
  var showAlert = PublishSubject<AlertViewModel>()
  var onFinish = PublishSubject<Void>()

  func signUp() {
    userDefaultsService.signUp(withEmail: emailInput.value,
                               withPassword: passwordInput.value,
                               withPasswordConfirm: passwordConfirmInput.value) { [weak self] userDefaultsServiceResult in
                                guard let strongSelf = self else {return}
                                switch userDefaultsServiceResult {
                                case .success(_):
                                  strongSelf.onFinish.onNext(())
                                case .failure(let error):
                                  strongSelf.showAlert.onNext(AlertViewModel(message: error.rawValue))
                                }
    }
  }
}



