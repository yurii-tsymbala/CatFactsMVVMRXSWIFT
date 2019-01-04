//
//  SignUpViewController.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController, KeyboardContentAdjustable {
  @IBOutlet private weak var userEmailTextField: CustomTextField!
  @IBOutlet private weak var userPasswordTextField: CustomTextField!
  @IBOutlet private weak var userPasswordConfirmTextField: CustomTextField!
  @IBOutlet private weak var signUpButton: CustomButton!

  var doneCallback: (() -> Void)?
  private var alert: UIAlertController?
  private var viewModel: SignUpViewModel!
  private let disposeBag = DisposeBag()

  convenience init(viewModel: SignUpViewModel) {
    self.init()
    self.viewModel = viewModel
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAlertController()
    observeViewModel()
    subscribeForKeyboard(visibleView: signUpButton, disposeBag: disposeBag)
    hideKeyboardAfterTap()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    setupNavigationBar()
  }

  private func setupView() {
    view.backgroundColor = ViewConfig.Colors.background
    userPasswordConfirmTextField.autocorrectionType = .no
    userEmailTextField.autocorrectionType = .no
    userPasswordTextField.autocorrectionType = .no
    userPasswordConfirmTextField.placeholder = viewModel.passwordConfirmPlaceholder
    userEmailTextField.placeholder = viewModel.emailPlaceholder
    userPasswordTextField.placeholder = viewModel.passwordPlaceholder
    userEmailTextField.keyboardType = .emailAddress
    userPasswordTextField.isSecureTextEntry = true
    userPasswordConfirmTextField.isSecureTextEntry = true
    signUpButton.addTarget(self, action: #selector(pressedSignUpButton), for: .touchUpInside)
    userPasswordConfirmTextField.delegate = self
    userEmailTextField.delegate = self
    userPasswordTextField.delegate = self
    userEmailTextField.tag = 0
    userPasswordTextField.tag = 1
    userPasswordConfirmTextField.tag = 2
  }

  private func setupNavigationBar() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.barTintColor = ViewConfig.Colors.background
  }

  private func observeViewModel() {
    userPasswordConfirmTextField.rx.text
      .orEmpty
      .bind(to: viewModel.passwordConfirmInput)
      .disposed(by: disposeBag)
    userEmailTextField.rx.text
      .orEmpty
      .bind(to: viewModel.emailInput)
      .disposed(by: disposeBag)
    userPasswordTextField.rx.text
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
  private func pressedSignUpButton() {
    viewModel.signUp()
  }

  @objc
  private func editUserFotoAction() {
    guard let alert = self.alert else { return }
    present(alert, animated: true, completion: nil)
  }

  private func setupAlertController() {
    alert = UIAlertController(title: viewModel.alertTitle,
                              message: viewModel.alertMessage,
                              preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "viewModel.Cancel", style: .cancel, handler: nil)
    guard let alert = self.alert else { return }
    alert.addAction(cancelAction)
  }
}

extension SignUpViewController: UITextFieldDelegate {
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

