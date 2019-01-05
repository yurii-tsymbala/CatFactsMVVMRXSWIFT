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
    cellDesign(cell: self)
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

  private func cellDesign(cell: UITableViewCell ) {
    cell.layer.cornerRadius = ViewConfig.Design.cornerRadius
    cell.layer.borderWidth = ViewConfig.Design.borderWidth
    cell.alpha = 0
    cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
    UIView.animate(withDuration: 0.8, animations: { () -> Void in
      cell.alpha = 1
      cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
    })
  }
}
