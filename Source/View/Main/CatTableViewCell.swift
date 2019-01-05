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
    imageView?.contentMode = .scaleAspectFit
    guard let viewModel = viewModel else { return }
    catImageView.image = viewModel.image
    catNameLabel.text = viewModel.name
    catTextLabel.text = viewModel.text
  }
}
