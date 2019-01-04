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
  var onFinish = PublishSubject<Void>()

  func signUp() {
  userDefaultsService.signUp(withEmail: emailInput.value,
                             withPassword: passwordInput.value,
                             withPasswordConfirm: passwordConfirmInput.value) { [weak self] userDefaultsServiceResult in
                              switch userDefaultsServiceResult {
                              case .success(_):
                                print("success and go to next vc")
                                // go to next vc
                              case .failure(let error):
                                print("Error = \(error)")
                              }
    }

    
    //    authService.signUp(
    //      withName: nameInput.value,
    //      withEmail: emailInput.value,
    //      withPassword: passwordInput.value,
    //      withUserImg: userImg.value,
    //      completion: { [weak self] authResult in
    //        guard let strongSelf = self else { return }
    //        switch authResult {
    //        case .success(let user):
    //          guard let userImg = strongSelf.userImg.value, let userId = user.id else {
    //            Logger.error("userId or userImg = empty -> authResult error")
    //            return
    //          }
    //          strongSelf.imageService.uploadImage(userImg, identifire: userId, completion: { (imgResult) in
    //            switch imgResult {
    //            case .success(let url):
    //              let stringURL = url.absoluteString
    //              user.avatarImgURL = stringURL
    //              strongSelf.userService.update(user, completion: { (userResult) in
    //                switch userResult {
    //                case .success:
    //                  strongSelf.onFinish.onNext(())
    //                case .failure:
    //                  Logger.error("update user error"); return
    //                }
    //              })
    //            case .failure:
    //              Logger.error("imgResult error"); return
    //            }
    //          })
    //        case .failure:
    //          Logger.error(authResult)
    //        }
    //    })
  }
}



