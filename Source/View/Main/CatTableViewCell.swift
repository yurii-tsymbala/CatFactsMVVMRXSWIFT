//
//  CatTableViewCell.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/5/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit

class CatTableViewCell: UITableViewCell {
  @IBOutlet private weak var catImageView: UIImageView!
  @IBOutlet private weak var catNameLabel: UILabel!
  @IBOutlet private weak var catTextLabel: UILabel!

  var viewModel: CatCellViewModel? {
    didSet {
      setupView()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    setupView()
  }

  private func setupView() {
    selectionStyle = .none
    catImageView?.contentMode = .scaleToFill
    catImageView?.layer.cornerRadius = 15
    catImageView?.layer.borderWidth = 0.5
    catNameLabel.backgroundColor = ViewConfig.Colors.background
    catTextLabel.backgroundColor = ViewConfig.Colors.background
    catNameLabel.textColor = ViewConfig.Colors.textWhite
    catTextLabel.textColor = ViewConfig.Colors.textWhite
    backgroundView?.backgroundColor = ViewConfig.Colors.background
    backgroundColor = ViewConfig.Colors.background
    guard let viewModel = viewModel else { return }
    catImageView.image = viewModel.image
    catNameLabel.text = viewModel.name
    catTextLabel.text = viewModel.text
  }
}
