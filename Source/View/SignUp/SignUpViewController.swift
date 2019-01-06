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

fileprivate let minimalPasswordLength = 5

class SignUpViewController: UIViewController, KeyboardContentAdjustable {
  @IBOutlet private weak var userEmailTextField: CustomTextField!
  @IBOutlet private weak var userPasswordTextField: CustomTextField!
  @IBOutlet private weak var userPasswordConfirmTextField: CustomTextField!
  @IBOutlet private weak var emailValidOutlet: UILabel!
  @IBOutlet private weak var passwordValidOutlet: UILabel!
  @IBOutlet private weak var signUpButton: CustomButton!
  @IBOutlet weak var stackView: UIStackView!
  

  var doneCallback: (() -> Void)?
  private var alert: UIAlertController?
  private var router: Router!
  private var viewModel: SignUpViewModel!
  private let disposeBag = DisposeBag()

  convenience init(withViewModel viewModel: SignUpViewModel, withRouter router: Router) {
    self.init()
    self.router = router
    self.viewModel = viewModel
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    setupNavigationBar()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupValidation()
    observeViewModel()
    subscribeForKeyboard(visibleView: signUpButton, disposeBag: disposeBag)
    hideKeyboardAfterTap()
  }

  private func setupValidation() {
    emailValidOutlet.text = "Email is not valid"
    passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
    let emailnameValid = userEmailTextField.rx.text.orEmpty
      .map { $0.isValidEmail() }
      .share(replay: 5)
    let passwordValid = userPasswordTextField.rx.text.orEmpty
      .map { $0.count >= minimalPasswordLength }
      .share(replay: 1)
    let everythingValid = Observable.combineLatest(emailnameValid, passwordValid) { $0 && $1 }
      .share(replay: 1)
    emailnameValid
      .bind(to: userPasswordTextField.rx.isEnabled)
      .disposed(by: disposeBag)
    emailnameValid
      .bind(to: emailValidOutlet.rx.isHidden)
      .disposed(by: disposeBag)
    passwordValid
      .bind(to: passwordValidOutlet.rx.isHidden)
      .disposed(by: disposeBag)
    everythingValid
      .bind(to: signUpButton.rx.isEnabled)
      .disposed(by: disposeBag)
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
    viewModel.showAlert
      .subscribe(onNext: { [weak self] alertViewModel in
        guard let strongSelf = self else { return }
        strongSelf.showAlert(withViewModel: alertViewModel)
      })
      .disposed(by: disposeBag)
  }

  private func setupView() {
    setupStackView()
    view.backgroundColor = ViewConfig.Colors.background
    emailValidOutlet.textColor = ViewConfig.Colors.blue
    passwordValidOutlet.textColor = ViewConfig.Colors.blue
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

  private func setupStackView() {
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 10
  }

  private func setupNavigationBar() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.isNavigationBarHidden = false
    navigationController?.navigationBar.barTintColor = ViewConfig.Colors.background
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

  private func showAlert(withViewModel viewModel: AlertViewModel ) {
    router.showAlert(viewModel, inViewController: self)
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

