//
//  WelcomeViewController.swift
//  CoreDataAuth
//
//  Created by NH on 8/21/25.
//

import UIKit
import SnapKit

final class WelcomeViewController: BaseViewController {
    
    // MARK: - Propertys
    private lazy var gradientView = GradientBackgroundView(frame: view.bounds)
    private let nicknameLabel = UILabel()
    private let welcomeLabel = UILabel()
    private let logoutButton = AppButton(title: "로그아웃", size: .medium)
    private let unregisterButton = AppButton(title: "회원탈퇴", size: .medium)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Methods
    override func setUI() {
        // 바탕 색
        gradientView.alpha = 0.38
        view.addSubview(gradientView)

        // 닉네임
        nicknameLabel.text = "닉네임입니다"
        nicknameLabel.textColor = .black
        nicknameLabel.textAlignment = .center
        nicknameLabel.font = .systemFont(ofSize: 36, weight: .bold)
        nicknameLabel.numberOfLines = 0
        view.addSubview(nicknameLabel)
        
        // 환영 문구
        welcomeLabel.text = "환영합니다."
        welcomeLabel.textColor = .main
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = .systemFont(ofSize: 36, weight: .bold)
        welcomeLabel.numberOfLines = 0
        view.addSubview(welcomeLabel)
 
        // 로그아웃 버튼
        view.addSubview(logoutButton)

        // 회원탈퇴 버튼
        view.addSubview(unregisterButton)
    }
    
    override func setConstraints() {
        gradientView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(258)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(88)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(88)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(140)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
        
        unregisterButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(48)
        }
    }
}
