//
//  UserDefaultsService.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

final class UserDefaultsService {
  private let userDefaults = UserDefaults.standard

  private enum Keys: String {
    case keyUserLogin
    case keyUserInGroup
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
}

