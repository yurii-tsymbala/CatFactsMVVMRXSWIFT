//
//  UserDefaultsService.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

enum UserDefaultsServiceError: String {
  case firstError = "Empty TextFields"
  case secondError = "Bad Email"
  case thirdError = "Bad password confirmation"
  case fourthError = "Too short password"
  case fifthError
  case sixthError
  case seventhError
  case eighthError
  case ninthError
  case tenthError
  case eleventhError
}

final class UserDefaultsService {
  private let userDefaults = UserDefaults.standard

  private enum Keys: String {
    case keyUserLogin
  }

  var isUserLogin: Bool {
    get {
      let isUserLogin = userDefaults.bool(forKey: Keys.keyUserLogin.rawValue)
      return isUserLogin
    }
    set(userLoginState) {
      userDefaults.set(userLoginState, forKey: Keys.keyUserLogin.rawValue)
      userDefaults.synchronize()
    }
  }

  typealias AuthHandler = (Result<Bool, UserDefaultsServiceError>) -> Void

  func signUp(withEmail email: String,
              withPassword password: String,
              withPasswordConfirm passwordConfirm: String,
              completion: @escaping AuthHandler) {

    guard !email.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty else { completion(Result.failure(UserDefaultsServiceError.firstError));return }

    guard email.isValidEmail() else {completion(Result.failure(UserDefaultsServiceError.secondError));return}

    if password != passwordConfirm {
      completion(Result.failure(UserDefaultsServiceError.thirdError));return
    } else if password.count < 5 || passwordConfirm.count < 5 {
      completion(Result.failure(UserDefaultsServiceError.fourthError));return
    }

    saveUserToUserDefaults(withEmail: email, withPassword: password) { userDefaultSaveResult in
      switch userDefaultSaveResult {
      case .success(let isSuccessful):
        completion(Result.success(isSuccessful))
      case .failure(let error):
        completion(Result.failure(error));return
      }
    }
  }

  func signIn(withEmail email: String,
              withPassword password: String) {

  }

  private func saveUserToUserDefaults(withEmail email: String,
                                      withPassword password: String,
                                      completion: @escaping AuthHandler) {
    Defaults.saveNameAndAddress(email,password)
    completion(Result.success(true))
  }
}

