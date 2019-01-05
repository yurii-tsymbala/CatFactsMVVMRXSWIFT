//
//  WelcomeViewController.swift
//  CatFacts
//
//  Created by Yurii Tsymbala on 1/4/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WelcomeViewController: UIViewController {
  var doneCallback: (() -> Void)?
  @IBOutlet weak private var signUpButton: CustomButton!
  @IBOutlet weak private var signInButton: CustomButton!
  @IBOutlet weak private var logoImageView: UIImageView!
  private var viewModel: WelcomeViewModelType!
  private let disposeBag = DisposeBag()

  convenience init(viewModel: WelcomeViewModelType) {
    self.init()
    self.viewModel = viewModel
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    observeViewModel()
    setupView()
  }

  private func observeViewModel() {
    viewModel.showSignIn
      .subscribe(onNext: { [weak self] (viewModel) in
        guard let strongSelf = self else { return }
        let signInViewController = SignInViewController(withViewModel: viewModel, withRouter: Router())
        signInViewController.doneCallback = strongSelf.doneCallback
        strongSelf.navigationController?.pushViewController(signInViewController, animated: true)
      }).disposed(by: disposeBag)
    viewModel.showSignUp
      .subscribe(onNext: { [weak self] (viewModel) in
        guard let strongSelf = self else { return }
        let signUpViewController = SignUpViewController(withViewModel: viewModel, withRouter: Router())
        signUpViewController.doneCallback = strongSelf.doneCallback
        strongSelf.navigationController?.pushViewController(signUpViewController, animated: true)
      }).disposed(by: disposeBag)
  }


  private func setupView() {
    logoImageView.image = UIImage(named: "catlogo")
    logoImageView.contentMode = .scaleAspectFill
    view.backgroundColor = ViewConfig.Colors.background
    signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    signUpButton.setTitle(viewModel?.signUpButtonTitle, for: .normal)
    signInButton.setTitle(viewModel?.signInButtonTitle, for: .normal)
  }

  @objc
  private func signIn() {
    viewModel.signIn()
  }

  @objc
  private func signUp() {
    viewModel.signUp()
  }
}
