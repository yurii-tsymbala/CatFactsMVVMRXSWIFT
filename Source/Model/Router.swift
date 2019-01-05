//
//  Router.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/5/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import UIKit

class Router {
  func showAlert(_ alertViewModel: AlertViewModel, inViewController: UIViewController) {
    let alert = UIAlertController(title: alertViewModel.title,
                                  message: alertViewModel.message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    inViewController.present(alert, animated: true, completion: nil)
  }
}

