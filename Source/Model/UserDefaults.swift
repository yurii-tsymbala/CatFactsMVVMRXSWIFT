//
//  UserDefaults.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

struct Defaults {

  static let (emailKey, passwordKey) = ("email", "password")
  static let userSessionKey = "com.save.usersession"

  struct UserModel {
    var email: String?
    var password: String?

    init(_ json: [String: String]) {
      self.email = json[emailKey]
      self.password = json[passwordKey]
    }
  }

  static var saveNameAndAddress = { (name: String, address: String) in
    UserDefaults.standard.set([emailKey: name, passwordKey: address], forKey: userSessionKey)
  }

  static var getNameAndAddress = { _ -> UserModel in
    return UserModel((UserDefaults.standard.value(forKey: userSessionKey) as? [String: String]) ?? [:])
  }(())

  static func clearUserData(){
    UserDefaults.standard.removeObject(forKey: userSessionKey)
  }
}
