//
//  SignInViewController.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignInViewController: UIViewController, KeyboardContentAdjustable {
  @IBOutlet private weak var emailTextField: CustomTextField!
  @IBOutlet private weak var passwordTextField: CustomTextField!
  @IBOutlet private weak var signInButton: CustomButton!
  var doneCallback: (() -> Void)?
  private var viewModel: SignInViewModelType!
  private let disposeBag = DisposeBag()

  convenience init(viewModel: SignInViewModelType) {
    self.init()
    self.viewModel = viewModel
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    observeViewModel()
    subscribeForKeyboard(visibleView: signInButton, disposeBag: disposeBag)
    hideKeyboardAfterTap()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
  }

  private func setupView() {
    view.backgroundColor = ViewConfig.Colors.background
    emailTextField.autocorrectionType = .no
    passwordTextField.autocorrectionType = .no
    emailTextField.placeholder = viewModel.emailPlaceholder
    passwordTextField.placeholder = viewModel.passwordPlaceholder
    emailTextField.keyboardType = .emailAddress
    passwordTextField.isSecureTextEntry = true
    signInButton.addTarget(self, action: #selector(pressedSignInButton), for: .touchUpInside)
    signInButton.setTitle(viewModel?.signInBtnTitle, for: .normal)
    emailTextField.delegate = self
    passwordTextField.delegate = self
    emailTextField.tag = 0
    passwordTextField.tag = 1
    emailTextField.autocorrectionType = .no
    passwordTextField.autocorrectionType = .no
  }

  private func setupNavigationBar() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.barTintColor = ViewConfig.Colors.background
  }

  private func observeViewModel() {
    emailTextField.rx.text
      .orEmpty
      .bind(to: viewModel.emailInput)
      .disposed(by: disposeBag)
    passwordTextField.rx.text
      .orEmpty
      .bind(to: viewModel.passwordInput)
      .disposed(by: disposeBag)
    viewModel
      .onFinish
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.doneCallback?()
      })
      .disposed(by: disposeBag)
  }

  private func hideKeyboardAfterTap() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapGesture)
  }

  @objc
  private func dismissKeyboard() {
    view.endEditing(true)
  }

  @objc
  private func pressedSignInButton(_ sender: UIButton) {
    viewModel.signIn()
  }
}

extension SignInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = textField.tag + 1
    if let nextResponder = textField.superview?.viewWithTag(nextTag) {
      nextResponder.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
}







