//
//  Cat.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/5/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation

struct Cat: Decodable {
  let firstName: String
  let lastName: String
  let text: String

  enum CodingKeys: String, CodingKey {
    case firstName = "first"
    case lastName = "last"
    case text = "text"
  }
}
