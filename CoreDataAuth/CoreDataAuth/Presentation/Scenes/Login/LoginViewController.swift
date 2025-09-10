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
            id: loginView.idTextField.rx.text.orEmpty.asDriver(),
            password: loginView.passwordTextField.rx.text.orEmpty.asDriver(),
            loginButtonTap: loginView.startButton.rx.tap.asSignal(),
            signUpButtonTap: loginView.signUpButton.rx.tap.asSignal(),
            adminButtonTap: loginView.adminButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        // 로그인 성공 → 메인 전환
        output.moveToMain
            .emit(onNext: { _ in
                guard let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate else { return }
                
                // 로그인 이후 메인
                let vc = MainViewController() // 로그인 후 메인화면
                
                // SceneDelegate 의 window 없는지 확인
                guard let window = sceneDelegate.window else { return }
                
                // 화면 전환
                UIView.transition(with: window,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
                })
            })
            .disposed(by: disposeBag)
        
        // 회원가입
        output.moveToSignUp
            .emit(onNext: { [weak self] _ in
                let vc = SignUpViewController()
                let modalNav = UINavigationController(rootViewController: vc)
                modalNav.modalPresentationStyle = .fullScreen
                modalNav.modalTransitionStyle = .coverVertical
                self?.present(modalNav, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 관리자(테스트)
        output.moveToAdmin
            .emit(onNext: { [weak self] _ in
                let vc = AdminViewController()
                let modalNav = UINavigationController(rootViewController: vc)
                modalNav.modalPresentationStyle = .fullScreen
                modalNav.modalTransitionStyle = .coverVertical
                self?.present(modalNav, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 에러 Alert
        output.showError
            .emit(onNext: { [weak self] msg in
                let ac = UIAlertController(title: "로그인 실패", message: msg, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(ac, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 버튼 활성화
//        output.isLoginEnabled
//            .drive(onNext: { [weak self] enabled in
//                self?.loginView.startButton.isEnabled = enabled
//                self?.loginView.startButton.alpha = enabled ? 1.0 : 0.5
//            })
//            .disposed(by: disposeBag)
    }
}
