//
//  WelcomeViewModel.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WelcomeViewModelType {
  var signInButtonTitle: String { get }
  var signUpButtonTitle: String { get }
  var showSignUp: Observable<SignUpViewModel> { get }
  var showSignIn: Observable<SignInViewModel> { get }
  func signIn()
  func signUp()
}

class WelcomeViewModel: WelcomeViewModelType {
  private struct Strings {
    static let signInButtonTitle = NSLocalizedString("Sign In", comment: "")
    static let signUpButtonTitle = NSLocalizedString("Sign Up", comment: "")
  }

  var showSignUp: Observable<SignUpViewModel> { return showSignUpSubject.asObservable() }
  var showSignIn: Observable<SignInViewModel> { return showSignInSubject.asObservable() }
  private let showSignUpSubject = PublishSubject<SignUpViewModel>()
  private let showSignInSubject = PublishSubject<SignInViewModel>()

  let signInButtonTitle = Strings.signInButtonTitle
  let signUpButtonTitle = Strings.signUpButtonTitle

  func signIn() {
    showSignInSubject.onNext(SignInViewModel(userDefaultsService: UserDefaultsService()))
  }
  func signUp() {
    showSignUpSubject.onNext(SignUpViewModel(userDefaultsService: UserDefaultsService()))
  }
}

