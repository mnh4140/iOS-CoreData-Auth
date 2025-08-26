//
//  MainViewController.swift
//  CoreDataAuth
//
//  Created by NH on 8/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    // MARK: - Propertys
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private var disposeBag = DisposeBag()
    private let logoutButtonTrigger = PublishRelay<Void>()
    private let unregisterButtonTrigger = PublishRelay<Void>()
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindButtons()
        bindViewModel()
    }
    
    // MARK: - Methods
    func bindButtons() {
        mainView.logoutButton.rx.tap
            .bind(to: logoutButtonTrigger)
            .disposed(by: disposeBag)
        
        mainView.unregisterButton.rx.tap
            .bind(to: unregisterButtonTrigger)
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = MainViewModel.Input(
            logoutButtonTrigger: logoutButtonTrigger.asObservable(),
            unregisterButtonTrigger: unregisterButtonTrigger.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.navigation
            .drive(onNext: { nav in
                switch nav {
                case .logout:
                    guard let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate else { return }
                    
                    // 로그인 이후 메인
                    let loginVC = LoginViewController() // 로그인 후 메인화면
                    
                    // SceneDelegate 의 window 없는지 확인
                    guard let window = sceneDelegate.window else { return }
                    
                    // 화면 전환
                    UIView.transition(with: window,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: loginVC)
                    })
                case .unregister:
                    guard let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate else { return }
                    
                    // 로그인 이후 메인
                    let loginVC = LoginViewController() // 로그인 후 메인화면
                    
                    // SceneDelegate 의 window 없는지 확인
                    guard let window = sceneDelegate.window else { return }
                    
                    // 화면 전환
                    UIView.transition(with: window,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: loginVC)
                    })
                case .error:
                    print("에러 발생")
                }
            }).disposed(by: disposeBag)
    }
}
