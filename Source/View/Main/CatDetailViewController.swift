//
//  CatDetailViewController.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/5/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class CatDetailViewController: UIViewController {
  @IBOutlet private weak var catDetailName: UILabel!
  @IBOutlet private weak var catDetailText: UILabel!
  @IBOutlet private weak var catDetailImageView: UIImageView!
  private var viewModel: CatDetailViewModel!
  
  convenience init(viewModel: CatDetailViewModel) {
    self.init()
    self.viewModel = viewModel
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupData()
  }
  
  private func setupData() {
    catDetailName.text = viewModel.name
    catDetailText.text = viewModel.text
    catDetailImageView.image = viewModel.image
  }
  
  private func setupView() {
    view.backgroundColor = ViewConfig.Colors.background
    catDetailImageView?.contentMode = .scaleToFill
    catDetailImageView?.layer.cornerRadius = 15
    catDetailImageView?.layer.borderWidth = 0.5
    catDetailText.backgroundColor = ViewConfig.Colors.background
    catDetailName.backgroundColor = ViewConfig.Colors.background
    catDetailText.textColor = ViewConfig.Colors.textWhite
    catDetailName.textColor = ViewConfig.Colors.textWhite
  }
  
}
