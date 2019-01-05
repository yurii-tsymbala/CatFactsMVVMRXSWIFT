//
//  ViewConfig.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

struct ViewConfig {
  struct Colors {
    // used for background color
    static let background = UIColor(red: 0.17, green: 0.17, blue: 0.20, alpha: 1.00)
    // used for navigation bar
    static let dark = UIColor(red: 0.12, green: 0.13, blue: 0.16, alpha: 1.00)
    // main white color
    static let white = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    // used for text fields
    static let grey = UIColor(red: 0.26, green: 0.26, blue: 0.29, alpha: 1.00)
    // used for buttons
    static let blue = UIColor(red: 0.03, green: 0.37, blue: 0.62, alpha: 1.00)
    static let textWhite = UIColor(red: 0.95, green: 0.95, blue: 0.92, alpha: 1.00)
    static let textLightGrey = UIColor(red: 0.53, green: 0.53, blue: 0.56, alpha: 1.00)
    static var grayLighter = UIColor(red: 0.26, green: 0.30, blue: 0.33, alpha: 1.0)
    static var grayLight = UIColor(red: 0.15, green: 0.17, blue: 0.18, alpha: 1.0)
    static var grayDark = UIColor(red: 0.08, green: 0.09, blue: 0.11, alpha: 1.0)
    static var grayDarkAlpha = UIColor(red: 0.08, green: 0.09, blue: 0.11, alpha: 0.7)
  }

  struct Design {
    static var cornerRadius: CGFloat { return 2.0 }
    static var borderWidth: CGFloat { return 1.0 }
    static var enabledButtonAlpha: CGFloat { return 1 }
    static var disabledButtonAlpha: CGFloat { return 0.5 }
  }
}

