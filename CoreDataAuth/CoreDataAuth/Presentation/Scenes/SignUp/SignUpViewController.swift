//
//  SignUpViewController.swift
//  CoreDataAuth
//
//  Created by NH on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    
    // MARK: - Propertys
    private let signUpView = SignUpView()
    
    private let disposeBag = DisposeBag()
        private let viewModel = SignUpViewModel()
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = signUpView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - Methods
    func bindViewModel() {
        let closeItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: nil,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = closeItem
        
        let input = SignUpViewModel.Input(
            closeTapped: closeItem.rx.tap.asSignal() // 메인스레드 보장 & 에러 무시
        )
        
        let output = viewModel.transform(input: input)
        
        output.dismissRequested
            .emit(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

}
