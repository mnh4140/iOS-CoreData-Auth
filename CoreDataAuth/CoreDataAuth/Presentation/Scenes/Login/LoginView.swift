//
//  LoginView.swift
//  CoreDataAuth
//
//  Created by NH on 8/26/25.
//

import UIKit

final class LoginView: BaseView {
    // MARK: - Propertys
    private lazy var gradientView = GradientBackgroundView(frame: self.bounds)
    private let logoImageView = UIImageView()
    private let textLogoImageView = UIImageView()
    
    private let idTextField = UITextField()
    private let idUnderLineView = UIView()
    private let idGuideLabel = UILabel()
    
    private let passwordTextField = UITextField()
    private let passwordUnderLineView = UIView()
    private let passwordGuideLabel = UILabel()
    
    // 외부에서 접근
    let startButton = AppButton(title: "로그인", size: .large)
    let signUpButton = UIButton()

    // MARK: - Methods
    override func setUI() {
        // 바탕 색
        gradientView.alpha = 0.38
        self.addSubview(gradientView)

        // 로고 이미지
        logoImageView.image = .itsGoodLogo
        self.addSubview(logoImageView)
        
        // 시작화면 텍스트
        textLogoImageView.image = .itsGoodLabel
        self.addSubview(textLogoImageView)
        
        // 아이디
        idTextField.font = .systemFont(ofSize: 17)
        idTextField.placeholder = "아이디"
        idTextField.clearButtonMode = .whileEditing // 입력 중 x 버튼 생성
        idTextField.autocapitalizationType = .none // 첫 영문자를 항상 소문자로 시작
        self.addSubview(idTextField)
        
        // 아이디 밑줄
        idUnderLineView.layer.borderWidth = 1
        idUnderLineView.layer.borderColor = UIColor.subColor1.cgColor
        self.addSubview(idUnderLineView)
        
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
        passwordUnderLineView.layer.borderColor = UIColor.subColor1.cgColor
        self.addSubview(passwordUnderLineView)
 
        // 시작하기 버튼
        self.addSubview(startButton)
        
        // 회원가입 버튼
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        signUpButton.setTitleColor(.black, for: .normal)
        self.addSubview(signUpButton)
        
    }
    
    override func setConstraints() {
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(136)
            make.centerX.equalToSuperview()
        }
        
        textLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(textLogoImageView.snp.bottom).offset(64)
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
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idUnderLineView.snp.bottom).offset(32)
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
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(passwordUnderLineView.snp.bottom).offset(64)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(48)
            make.height.equalTo(92)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}
