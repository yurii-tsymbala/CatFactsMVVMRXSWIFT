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
  var namePlaceholder: String { get }
  var emailPlaceholder: String { get }
  var userFotoLabelText: String { get }
  var passwordPlaceholder: String { get }
  var signUpBtnTitle: String { get }

  var alertTitle: String { get }
  var alertMessageTitle: String { get }
  var alerDefaultActionTitle: String { get }
  var alerGalarytActionTitle: String { get }
  var alertCancelActionTitle: String { get }

  var nameInput: BehaviorRelay<String> { get }
  var emailInput: BehaviorRelay<String> { get }
  var passwordInput: BehaviorRelay<String> { get }
  var userImg: BehaviorRelay<UIImage?> { get }
  var onFinish: PublishSubject<Void> { get }
  func signUp()
}

class SignUpViewModel: SignUpViewModelType {
  private struct Strings {
    static let alertTitle = NSLocalizedString("Foto", comment: "")
    static let alertMessageTitle = NSLocalizedString("Select the option to upload your profile photo", comment: "")
    static let alerDefaultActionTitle = NSLocalizedString("Select photos from default", comment: "")
    static let alerGalarytActionTitle = NSLocalizedString("Select photos from photo galary", comment: "")
    static let alertCancelActionTitle = NSLocalizedString("Cancel", comment: "")

    static let btnTitle = NSLocalizedString("Sign Up", comment: "")
    static let userFotoLabelText = NSLocalizedString("Tap for edit avatar", comment: "")
    static let namePlaceholder = NSLocalizedString("Name", comment: "")
    static let emailPlaceholder = NSLocalizedString("Email", comment: "")
    static let passwordPlaceholder = NSLocalizedString("Password", comment: "")
  }

  private let authService: AuthServiceType
  private let imageService: ImageUploadable
  private let userService: UserServiceType

  init(authService: AuthServiceType,
       imageService: ImageUploadable,
       userService: UserServiceType) {
    self.authService = authService
    self.imageService = imageService
    self.userService = userService
  }

  let namePlaceholder = Strings.namePlaceholder
  let emailPlaceholder = Strings.emailPlaceholder
  let passwordPlaceholder = Strings.passwordPlaceholder
  let userFotoLabelText = Strings.userFotoLabelText
  let signUpBtnTitle = Strings.btnTitle

  var alertTitle = Strings.alertTitle
  var alertMessageTitle = Strings.alertMessageTitle
  var alerDefaultActionTitle = Strings.alerDefaultActionTitle
  var alerGalarytActionTitle = Strings.alerGalarytActionTitle
  var alertCancelActionTitle = Strings.alertCancelActionTitle

  var nameInput = BehaviorRelay<String>(value: "")
  var emailInput = BehaviorRelay<String>(value: "")
  var passwordInput = BehaviorRelay<String>(value: "")
  var userImg = BehaviorRelay<UIImage?>(value: nil)
  var onFinish = PublishSubject<Void>()

  func signUp() {
    authService.signUp(
      withName: nameInput.value,
      withEmail: emailInput.value,
      withPassword: passwordInput.value,
      withUserImg: userImg.value,
      completion: { [weak self] authResult in
        guard let strongSelf = self else { return }
        switch authResult {
        case .success(let user):
          guard let userImg = strongSelf.userImg.value, let userId = user.id else {
            Logger.error("userId or userImg = empty -> authResult error")
            return
          }
          strongSelf.imageService.uploadImage(userImg, identifire: userId, completion: { (imgResult) in
            switch imgResult {
            case .success(let url):
              let stringURL = url.absoluteString
              user.avatarImgURL = stringURL
              strongSelf.userService.update(user, completion: { (userResult) in
                switch userResult {
                case .success:
                  strongSelf.onFinish.onNext(())
                case .failure:
                  Logger.error("update user error"); return
                }
              })
            case .failure:
              Logger.error("imgResult error"); return
            }
          })
        case .failure:
          Logger.error(authResult)
        }
    })
  }
}

