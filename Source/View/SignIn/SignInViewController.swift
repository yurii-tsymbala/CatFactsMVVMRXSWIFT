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

fileprivate let minimalPasswordLength = 5

class SignInViewController: UIViewController, KeyboardContentAdjustable {
  @IBOutlet private weak var emailTextField: CustomTextField!
  @IBOutlet private weak var passwordTextField: CustomTextField!
  @IBOutlet private weak var emailValidOutlet: UILabel!
  @IBOutlet private weak var passwordValidOutlet: UILabel!
  @IBOutlet private weak var signInButton: CustomButton!
  
  @IBOutlet weak var stackView: UIStackView!
  var doneCallback: (() -> Void)?
  private var viewModel: SignInViewModelType!
  private var router: Router!
  private let disposeBag = DisposeBag()

  convenience init(withViewModel viewModel: SignInViewModelType, withRouter router: Router) {
    self.init()
    self.viewModel = viewModel
    self.router = router
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    observeViewModel()
    subscribeForKeyboard(visibleView: signInButton, disposeBag: disposeBag)
    hideKeyboardAfterTap()
    setupValidation()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
  }

  private func setupValidation() {
    emailValidOutlet.text = "Email is not valid"
    passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
    let emailnameValid = emailTextField.rx.text.orEmpty
      .map { $0.isValidEmail() }
      .share(replay: 5) 
    let passwordValid = passwordTextField.rx.text.orEmpty
      .map { $0.count >= minimalPasswordLength }
      .share(replay: 1)
    let everythingValid = Observable.combineLatest(emailnameValid, passwordValid) { $0 && $1 }
      .share(replay: 1)
    emailnameValid
      .bind(to: passwordTextField.rx.isEnabled)
      .disposed(by: disposeBag)
    emailnameValid
      .bind(to: emailValidOutlet.rx.isHidden)
      .disposed(by: disposeBag)
    passwordValid
      .bind(to: passwordValidOutlet.rx.isHidden)
      .disposed(by: disposeBag)
    everythingValid
      .bind(to: signInButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }

  private func setupView() {
    setupStackView()
    view.backgroundColor = ViewConfig.Colors.background
    emailValidOutlet.textColor = ViewConfig.Colors.blue
    passwordValidOutlet.textColor = ViewConfig.Colors.blue
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
    viewModel.showAlert
      .subscribe(onNext: { [weak self] alertViewModel in
        guard let strongSelf = self else { return }
        strongSelf.showAlert(withViewModel: alertViewModel)
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

  private func showAlert(withViewModel viewModel: AlertViewModel ) {
    router.showAlert(viewModel, inViewController: self)
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







