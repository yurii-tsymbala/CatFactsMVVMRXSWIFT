//
//  Result.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

enum Result<Value, Error> {
  case success(Value)
  case failure(Error)

  var value: Value? {
    switch self {
    case .success(let value):
      return value
    default:
      return nil
    }
  }

  var error: Error? {
    switch self {
    case .failure(let error):
      return error
    default:
      return nil
    }
  }
}
