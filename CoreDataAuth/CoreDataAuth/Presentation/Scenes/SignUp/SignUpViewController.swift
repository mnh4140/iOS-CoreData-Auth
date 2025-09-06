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
        output.idState
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .empty:
                    self.signUpView.idUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
                    self.signUpView.idGuideLabel.textColor = .black
                    self.signUpView.idGuideLabel.text = "아이디는 영문과 숫자만 입력이 가능합니다." // 초기 가이드
                    
                case .formatInvalid:
                    self.signUpView.idUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.idGuideLabel.textColor = .red
                    self.signUpView.idGuideLabel.text = "아이디는 영문과 숫자 4~12자만 입력이 가능합니다."
                case .duplicate:
                    self.signUpView.idUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.idGuideLabel.textColor = .red
                    self.signUpView.idGuideLabel.text = "중복된 아이디입니다."
                case .available:
                    self.signUpView.idUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
                    self.signUpView.idGuideLabel.textColor = .black // 혹은 .systemGreen
                    self.signUpView.idGuideLabel.text = "사용 가능한 아이디입니다."
                case .error(let msg):
                    self.signUpView.idUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.idGuideLabel.textColor = .red
                    self.signUpView.idGuideLabel.text = msg
                    
                }
            }).disposed(by: disposeBag)
        
        output.nicknameState
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .empty:
                    self.signUpView.nicknameUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
                    self.signUpView.nicknameGuideLabel.textColor = .black
                    self.signUpView.nicknameGuideLabel.text = "사용할 닉네임을 입력해주세요." // 초기 가이드
                    
                case .formatInvalid:
                    self.signUpView.nicknameUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.nicknameGuideLabel.textColor = .red
                    self.signUpView.nicknameGuideLabel.text = "닉네임는 한글, 영문, 숫자 조합 2~6자리까지 가능합니다."
                case .duplicate:
                    self.signUpView.nicknameUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.nicknameGuideLabel.textColor = .red
                    self.signUpView.nicknameGuideLabel.text = "중복된 닉네임입니다."
                case .available:
                    self.signUpView.nicknameUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
                    self.signUpView.nicknameGuideLabel.textColor = .black // 혹은 .systemGreen
                    self.signUpView.nicknameGuideLabel.text = "사용 가능한 닉네임입니다."
                case .error(let msg):
                    self.signUpView.nicknameUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.nicknameGuideLabel.textColor = .red
                    self.signUpView.nicknameGuideLabel.text = msg
                    
                }
            }).disposed(by: disposeBag)
        
        output.passwordState
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .empty:
                    self.signUpView.passwordUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
                    self.signUpView.passwordGuideLabel.textColor = .black
                    self.signUpView.passwordGuideLabel.text = "대소문자, 숫자, 특수문자를 조합하여 8~16자리까지 가능합니다." // 초기 가이드
                    
                case .formatInvalid:
                    self.signUpView.passwordUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.passwordGuideLabel.textColor = .red
                    self.signUpView.passwordGuideLabel.text = "대소문자, 숫자, 특수문자를 조합하여 8~16자리까지 가능합니다."
                case .available:
                    self.signUpView.passwordUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
                    self.signUpView.passwordGuideLabel.textColor = .black // 혹은 .systemGreen
                    self.signUpView.passwordGuideLabel.text = "사용 가능한 비밀번호입니다."
                case .error(let msg):
                    self.signUpView.passwordUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.passwordGuideLabel.textColor = .red
                    self.signUpView.passwordGuideLabel.text = msg
                    
                // TODO: 비밀번호는 중복 검사 필요가 없음.
                case .duplicate:
                    self.signUpView.passwordGuideLabel.text = "비밀번호가 중복될일이 없음"
                }
            }).disposed(by: disposeBag)
        
//        output.confirmValid
//            .drive(onNext: { [weak self] ok in
//                
//                self?.signUpView.ckpasswordUnderLineView.layer.borderColor = ok ? UIColor.lightGray.cgColor : UIColor.red.cgColor
//                self?.signUpView.ckpasswordGuideLabel.textColor = ok ? .black : .red
//                //self?.signUpView.ckpasswordGuideLabel.isHidden = ok
//                self?.signUpView.ckpasswordGuideLabel.text = ok ? "비밀번호가 일치합니다." : "비밀번호가 일치하지 않습니다."
//            }).disposed(by: disposeBag)
        
        output.confirmState
            .drive(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .empty:
                    self.signUpView.ckpasswordUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
                    self.signUpView.ckpasswordGuideLabel.textColor = .black
                    self.signUpView.ckpasswordGuideLabel.text = "비밀번호가 일치하지 않습니다." // 초기 가이드
                    
                case .formatInvalid:
                    self.signUpView.ckpasswordUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.ckpasswordGuideLabel.textColor = .red
                    self.signUpView.ckpasswordGuideLabel.text = "비밀번호가 일치하지 않습니다."
                case .available:
                    self.signUpView.ckpasswordUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
                    self.signUpView.ckpasswordGuideLabel.textColor = .black // 혹은 .systemGreen
                    self.signUpView.ckpasswordGuideLabel.text = "비밀번호가 일치합니다."
                case .error(let msg):
                    self.signUpView.ckpasswordUnderLineView.layer.borderColor = UIColor.red.cgColor
                    self.signUpView.ckpasswordGuideLabel.textColor = .red
                    self.signUpView.ckpasswordGuideLabel.text = msg
                    
                    // TODO: 비밀번호는 중복 검사 필요가 없음.
                case .duplicate:
                    self.signUpView.ckpasswordGuideLabel.text = "비밀번호가 중복될일이 없음"
                }
            }).disposed(by: disposeBag)
        
        output.isEnabled
            .drive(onNext: { [weak self] bool in
                self?.signUpView.registerButton.isEnabled = bool
                self?.signUpView.registerButton.backgroundColor = bool ? .main : .lightGray
            })
            .disposed(by: disposeBag)
    }
}
