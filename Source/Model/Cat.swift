//
//  Cat.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/5/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

struct Cats: Codable {
  let cats: [Cat]
  enum CodingKeys: String, CodingKey {
    case cats = "all"
  }
}

struct Cat: Codable {
  let text: String
  let user: User?
}

struct User: Codable {
  let name: Name
}

struct Name: Codable {
  let first: String
  let last: String

  var fullName: String {
    return "\(first) \(last)"
  }
}
