//
//  MainView.swift
//  CoreDataAuth
//
//  Created by NH on 8/26/25.
//

import UIKit

final class MainView: BaseView {
    // MARK: - Propertys
    private lazy var gradientView = GradientBackgroundView(frame: self.bounds)
    private let nicknameLabel = UILabel()
    private let welcomeLabel = UILabel()
    let logoutButton = AppButton(title: "로그아웃", size: .medium)
    let unregisterButton = AppButton(title: "회원탈퇴", size: .medium)
    
    // MARK: - Methods
    override func setUI() {
        // 바탕 색
        gradientView.alpha = 0.38
        self.addSubview(gradientView)

        // 닉네임
        nicknameLabel.text = "닉네임입니다"
        nicknameLabel.textColor = .main
        nicknameLabel.textAlignment = .center
        nicknameLabel.font = .systemFont(ofSize: 36, weight: .bold)
        nicknameLabel.numberOfLines = 0
        self.addSubview(nicknameLabel)
        
        // 환영 문구
        welcomeLabel.text = "환영합니다."
        welcomeLabel.textColor = .black
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = .systemFont(ofSize: 36, weight: .bold)
        welcomeLabel.numberOfLines = 0
        self.addSubview(welcomeLabel)
 
        // 로그아웃 버튼
        self.addSubview(logoutButton)

        // 회원탈퇴 버튼
        self.addSubview(unregisterButton)
    }
    
    override func setConstraints() {
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(258)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(88)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(88)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(140)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(48)
        }
        
        unregisterButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(48)
        }
    }
}
