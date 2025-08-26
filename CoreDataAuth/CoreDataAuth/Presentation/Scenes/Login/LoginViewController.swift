//
//  StartViewController.swift
//  CoreDataAuth
//
//  Created by NH on 8/20/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    // MARK: - Propertys
    private let loginView = LoginView()
    
    private let viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = loginView
    }
    
    // 네비게이션 영역 숨김
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bindViewModel()
    }
    
    // MARK: - Methods
    /// 버튼 이벤트를 ViewModel로 전달
    private func bindViewModel() {
        let input = LoginViewModel.Input(
            loginButtonTap: loginView.startButton.rx.tap.asObservable(),
            signUpButtonTap: loginView.signUpButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.navigation
            .drive(onNext: { [weak self] nav in
                switch nav {
                case .login:
                    guard let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate else { return }
                    
                    // 로그인 이후 메인
                    let mainVC = MainViewController() // 로그인 후 메인화면
                    
                    // SceneDelegate 의 window 없는지 확인
                    guard let window = sceneDelegate.window else { return }
                    
                    // 화면 전환
                    UIView.transition(with: window,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        sceneDelegate.window?.rootViewController = mainVC
                    })
                case .signUp:
                    let vc = SignUpViewController()
                    let modalNav = UINavigationController(rootViewController: vc)
                    modalNav.modalPresentationStyle = .fullScreen
                    modalNav.modalTransitionStyle = .coverVertical
                    self?.present(modalNav, animated: true)
                    
                case .error(let message):
                    print("오류 발생: \(message)")
                }
            }).disposed(by: disposeBag)
    }
}
