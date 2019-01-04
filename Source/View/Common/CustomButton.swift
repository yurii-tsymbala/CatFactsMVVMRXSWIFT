//
//  CustomButton.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomButton: UIButton {

  private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  private let disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupButtonView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    setupButtonView()
  }

  override var isEnabled: Bool {
    didSet {
      super.isEnabled = isEnabled
      if isEnabled {
        setDefaultView()
      } else {
        setDisableView()
      }
    }
  }

  private func setupButtonView() {
    layer.cornerRadius = 5
    backgroundColor = ViewConfig.Colors.blue
    setTitleColor(ViewConfig.Colors.textWhite, for: .normal)

    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).cgColor
    layer.shadowOffset = CGSize(width: 5, height: 5)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 10.0

    contentEdgeInsets = padding
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    layer.shadowRadius = 20.0
    transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.5,
                   initialSpringVelocity: 6,
                   options: .allowUserInteraction,
                   animations: {
                    self.transform = CGAffineTransform.identity
    }, completion: nil)
    super.touchesBegan(touches, with: event)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    layer.shadowRadius = 10.0
    super.touchesEnded(touches, with: event)
  }

  func setDisableView() {
    self.backgroundColor = .gray
  }

  func setDefaultView() {
    self.backgroundColor = ViewConfig.Colors.blue
  }
}

