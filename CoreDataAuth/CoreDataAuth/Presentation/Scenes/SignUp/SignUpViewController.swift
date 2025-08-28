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
            id: signUpView.idTextField.rx.text.orEmpty.asDriver(),
            nickname: signUpView.nicknameTextField.rx.text.orEmpty.asDriver(),
            password: signUpView.passwordTextField.rx.text.orEmpty.asDriver(),
            confirm: signUpView.ckpasswordTextField.rx.text.orEmpty.asDriver(),
            closeTapped: closeItem.rx.tap.asSignal(), // 메인스레드 보장 & 에러 무시
            signUpButtonTap: signUpView.registerButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.dismissRequested
            .emit(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.navigation
            .emit(onNext: { [weak self] nav in
                switch nav {
                case .main:
                    // TODO: 회원가입 완료 Alert 띄우기
                    self?.dismiss(animated: true)
                case .error(let message):
                    print("에러 : \(message)")
                }
            }).disposed(by: disposeBag)
        
        // 유효성 검사
        output.idValid
            .drive(onNext: { [weak self] ok in
                self?.signUpView.idUnderLineView.layer.borderColor = ok ? UIColor.black.cgColor : UIColor.red.cgColor
                self?.signUpView.idGuideLabel.textColor = ok ? .black : .red
                self?.signUpView.idGuideLabel.text = ok ? "사용 가능한 아이디입니다." : "아이디는 영문과 숫자만 입력이 가능합니다."
            }).disposed(by: disposeBag)
        
        output.nicknameValid
            .drive(onNext: { [weak self] ok in
                self?.signUpView.nicknameUnderLineView.backgroundColor = ok ? .black : .red
                self?.signUpView.nicknameGuideLabel.textColor = ok ? .black : .red
                //self?.signUpView.nicknameGuideLabel.isHidden = ok
                self?.signUpView.nicknameGuideLabel.text = ok ? "사용 가능한 닉네임입니다." : "닉네임은 한글 6자리까지 가능합니다."
            }).disposed(by: disposeBag)
        
        output.passwordValid
            .drive(onNext: { [weak self] ok in
                self?.signUpView.passwordUnderLineView.backgroundColor = ok ? .black : .red
                //self?.signUpView.passwordGuideLabel.isHidden = ok
                self?.signUpView.passwordGuideLabel.text = ok ? "사용 가능한 비밀번호입니다." : "비밀번호는 영문과 숫자 10자리 내로 입력이 가능합니다."
            }).disposed(by: disposeBag)
        
        output.confirmValid
            .drive(onNext: { [weak self] ok in
                self?.signUpView.ckpasswordUnderLineView.backgroundColor = ok ? .black : .red
                //self?.signUpView.ckpasswordGuideLabel.isHidden = ok
                self?.signUpView.ckpasswordGuideLabel.text = ok ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다."
            }).disposed(by: disposeBag)
    }

}
