//
//  SignUpView.swift
//  CoreDataAuth
//
//  Created by NH on 8/26/25.
//

import UIKit

final class SignUpView: BaseView {
    // MARK: - Propertys
    private let titleLabel = UILabel()
    
    let idTextField = UITextField()
    let idUnderLineView = UIView()
    let idGuideLabel = UILabel()
    
    let nicknameTextField = UITextField()
    let nicknameUnderLineView = UIView()
    let nicknameGuideLabel = UILabel()
    
    let passwordTextField = UITextField()
    let passwordUnderLineView = UIView()
    let passwordGuideLabel = UILabel()
    
    let ckpasswordTextField = UITextField()
    let ckpasswordUnderLineView = UIView()
    let ckpasswordGuideLabel = UILabel()
    
    let registerButton = AppButton(title: "회원가입", size: .large)
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func setUI() {
        // 타이틀
        titleLabel.text = "회원가입"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 32, weight: .regular)
        self.addSubview(titleLabel)
        
        // 아이디
        idTextField.font = .systemFont(ofSize: 17)
        idTextField.placeholder = "아이디"
        idTextField.clearButtonMode = .whileEditing // 입력 중 x 버튼 생성
        idTextField.autocapitalizationType = .none // 첫 영문자를 항상 소문자로 시작
        self.addSubview(idTextField)
        
        // 아이디 밑줄
        idUnderLineView.layer.borderWidth = 1
        idUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
        self.addSubview(idUnderLineView)
        
        // 아이디 안내 글
        idGuideLabel.text = "아이디는 영문과 숫자만 입력이 가능합니다."
        idGuideLabel.textColor = .black
        idGuideLabel.textAlignment = .left
        idGuideLabel.font = .systemFont(ofSize: 12)
        self.addSubview(idGuideLabel)
        
        // 닉네임
        nicknameTextField.font = .systemFont(ofSize: 17)
        nicknameTextField.placeholder = "닉네임"
        nicknameTextField.clearButtonMode = .whileEditing // 입력 중 x 버튼 생성
        nicknameTextField.autocapitalizationType = .none // 첫 영문자를 항상 소문자로 시작
        self.addSubview(nicknameTextField)
        
        // 닉네임 밑줄
        nicknameUnderLineView.layer.borderWidth = 1
        nicknameUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
        self.addSubview(nicknameUnderLineView)
        
        // 닉네임 안내 글
        nicknameGuideLabel.text = "닉네임은 한글 6자리까지 가능합니다."
        nicknameGuideLabel.textColor = .black
        nicknameGuideLabel.textAlignment = .left
        nicknameGuideLabel.font = .systemFont(ofSize: 12)
        self.addSubview(nicknameGuideLabel)
        
        // 비밀번호 입력 칸
        passwordTextField.font = .systemFont(ofSize: 17)
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.clearButtonMode = .whileEditing // 입력 중 x 버튼 생성
        passwordTextField.isSecureTextEntry = true // 문자열이 * 처리됨
        passwordTextField.textContentType = .oneTimeCode // auto fill 제한
        passwordTextField.autocapitalizationType = .none // 첫 영문자를 항상 소문자로 시작
        self.addSubview(passwordTextField)
        
        // 비밀번호 밑줄
        passwordUnderLineView.layer.borderWidth = 1
        passwordUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
        self.addSubview(passwordUnderLineView)
        
        // 비밀번호 안내 글
        passwordGuideLabel.text = "대소문자, 숫자, 특수문자를 조합하여 8~16자리까지 가능합니다."
        passwordGuideLabel.textColor = .black
        passwordGuideLabel.textAlignment = .left
        passwordGuideLabel.adjustsFontSizeToFitWidth = true
        passwordGuideLabel.minimumScaleFactor = 0.8
        passwordGuideLabel.font = .systemFont(ofSize: 12)
        passwordGuideLabel.numberOfLines = 0
        self.addSubview(passwordGuideLabel)
        
        // 비밀번호 확인 입력 칸
        ckpasswordTextField.font = .systemFont(ofSize: 17)
        ckpasswordTextField.placeholder = "비밀번호 확인"
        ckpasswordTextField.clearButtonMode = .whileEditing // 입력 중 x 버튼 생성
        ckpasswordTextField.isSecureTextEntry = true // 문자열이 * 처리됨
        ckpasswordTextField.textContentType = .oneTimeCode // auto fill 제한
        ckpasswordTextField.autocapitalizationType = .none // 첫 영문자를 항상 소문자로 시작
        self.addSubview(ckpasswordTextField)
        
        // 비밀번호 확인 밑줄
        ckpasswordUnderLineView.layer.borderWidth = 1
        ckpasswordUnderLineView.layer.borderColor = UIColor.lightGray.cgColor
        self.addSubview(ckpasswordUnderLineView)
        
        // 비밀번호 확인 안내 글
        ckpasswordGuideLabel.text = "비밀번호가 일치하지 않습니다."
        ckpasswordGuideLabel.textColor = .black
        ckpasswordGuideLabel.textAlignment = .left
        ckpasswordGuideLabel.font = .systemFont(ofSize: 12)
        self.addSubview(ckpasswordGuideLabel)
        
        // 가입하기 버튼
        self.addSubview(registerButton)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.height.equalTo(40)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(44)
        }
        
        idUnderLineView.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(1)
        }
        
        idGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(idUnderLineView.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.height.equalTo(22)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(idGuideLabel.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(44)
        }
        
        nicknameUnderLineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(1)
        }
        
        nicknameGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameUnderLineView.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.height.equalTo(22)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameGuideLabel.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(44)
        }
        
        passwordUnderLineView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(1)
        }
        
        passwordGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordUnderLineView.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.height.equalTo(22)
        }
        
        ckpasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordGuideLabel.snp.bottom).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(44)
        }
        
        ckpasswordUnderLineView.snp.makeConstraints { make in
            make.top.equalTo(ckpasswordTextField.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(1)
        }
        
        ckpasswordGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(ckpasswordUnderLineView.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            make.height.equalTo(22)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(ckpasswordGuideLabel.snp.bottom).offset(136)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(48)
        }
    }
}
