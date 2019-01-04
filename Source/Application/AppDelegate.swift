//
//  AppDelegate.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var rootViewController: RootViewController!
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    viewSetup()
    return true
  }

  private func viewSetup() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = ViewConfig.Colors.background
    rootViewController = RootViewController(userDefaultsService: UserDefaultsService())
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }
}

