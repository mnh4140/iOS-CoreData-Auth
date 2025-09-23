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
            logoutTap: mainView.logoutButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.moveToLogin
            .emit(onNext: { AppRouter.toLogin() })   // 루트 교체
            .disposed(by: disposeBag)
    }
}
