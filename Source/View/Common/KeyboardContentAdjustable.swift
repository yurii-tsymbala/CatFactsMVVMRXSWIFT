//
//  KeyboardContentAdjustable.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol KeyboardContentAdjustable: class {
  func subscribeForKeyboard(visibleView: UIView, disposeBag: DisposeBag)
}

extension KeyboardContentAdjustable where Self: UIViewController {
  func subscribeForKeyboard(visibleView: UIView, disposeBag: DisposeBag) {
    self.unSubscribeForKeyboard()
    NotificationCenter.default.rx.notification(UIResponder.keyboardDidShowNotification,
                                               object: nil).subscribe(onNext: {
                                                notification in
                                                self.onKeyboardShow(notification, visibleView: visibleView)
                                               }).disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification,
                                               object: nil).subscribe(onNext: { notification in
                                                self.onKeyboardHide(notification)
                                               }).disposed(by: disposeBag)
  }

  func unSubscribeForKeyboard() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  func onKeyboardShow(_ notification: Notification, visibleView: UIView) {
    guard
      self.view.transform == CGAffineTransform.identity,
      let info = notification.userInfo,
      let keyboardFrame = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
      let windowHeight = self.view.window?.bounds.height
      else { return }

    let keyboardTop = windowHeight - keyboardFrame.size.height
    let btnSignInBottom = visibleView.convert(visibleView.bounds, to: nil).maxY
    let offset = keyboardTop - btnSignInBottom - 20
    UIView.animate(withDuration: 0.3) {
      self.view.transform = CGAffineTransform(translationX: 0, y: offset)
    }
  }

  func onKeyboardHide(_ notification: Notification) {
    guard self.view.transform != CGAffineTransform.identity else { return }

    UIView.animate(withDuration: 0.3) {
      self.view.transform = CGAffineTransform.identity
    }
  }
}

