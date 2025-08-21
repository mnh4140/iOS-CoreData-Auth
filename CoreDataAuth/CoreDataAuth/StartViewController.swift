//
//  StartViewController.swift
//  CoreDataAuth
//
//  Created by NH on 8/20/25.
//

import UIKit
import SnapKit

final class StartViewController: BaseViewController {
    
    // MARK: - Propertys
    private lazy var gradientView = GradientBackgroundView(frame: view.bounds)
    private let logoImageView = UIImageView()
    private let startLabel = UILabel()
    private let startButton = UIButton()
    
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

        // 로고 이미지
        logoImageView.image = .spartaLogo
        view.addSubview(logoImageView)
        
        // 시작화면 텍스트
        startLabel.text = "실무 경험이 필요할 때,\n바로인턴"
        startLabel.textAlignment = .center
        startLabel.font = .systemFont(ofSize: 32, weight: .bold)
        startLabel.numberOfLines = 0
        view.addSubview(startLabel)
 
        // 시작하기 버튼
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        startButton.backgroundColor = .main
        startButton.layer.cornerRadius = 20
        view.addSubview(startButton)
        
    }
    
    override func setConstraints() {
        gradientView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(146)
            make.horizontalEdges.equalToSuperview().inset(44)
        }
        
        startLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(43)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(startLabel.snp.bottom).offset(74)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(48)
            make.height.equalTo(92)
        }
    }
}
