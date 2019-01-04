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

class SignUpViewController: UIViewController, KeyboardContentAdjustable { // fix costraints
  @IBOutlet private weak var userNameTextField: CustomTextField!
  @IBOutlet private weak var userEmailTextField: CustomTextField!
  @IBOutlet private weak var userPasswordTextField: CustomTextField!
  @IBOutlet private weak var signUpButton: CustomButton!

  var doneCallback: (() -> Void)?
  private var alert: UIAlertController?
  private var viewModel: SignUpViewModel!
  private let disposeBag = DisposeBag()
  private let imagePicker = UIImagePickerController()

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
    userNameTextField.autocorrectionType = .no
    userEmailTextField.autocorrectionType = .no
    userPasswordTextField.autocorrectionType = .no
    userNameTextField.placeholder = viewModel.namePlaceholder
    userEmailTextField.placeholder = viewModel.emailPlaceholder
    userPasswordTextField.placeholder = viewModel.passwordPlaceholder
    userEmailTextField.keyboardType = .emailAddress
    userPasswordTextField.isSecureTextEntry = true
    signUpButton.addTarget(self, action: #selector(pressedSignUpButton), for: .touchUpInside)
    userNameTextField.delegate = self
    userEmailTextField.delegate = self
    userPasswordTextField.delegate = self
    userNameTextField.tag = 0
    userEmailTextField.tag = 1
    userPasswordTextField.tag = 2
  }

  private func setupNavigationBar() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.barTintColor = ViewConfig.Colors.background
  }

  private func observeViewModel() {
    userNameTextField.rx.text
      .orEmpty
      .bind(to: viewModel.nameInput)
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
                              message: viewModel.alertMessageTitle,
                              preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: viewModel.alertCancelActionTitle, style: .cancel, handler: nil)
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

