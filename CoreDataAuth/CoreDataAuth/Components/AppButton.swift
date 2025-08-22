//
//  AppButton.swift
//  CoreDataAuth
//
//  Created by NH on 8/22/25.
//

import UIKit
import SnapKit

class AppButton: UIButton {
    enum Size {
        case large, medium
        
        var height: Int {
            switch self {
            case .large: return 92
            case .medium: return 64
            }
        }
        
        var font: UIFont {
            switch self {
            case .large:
                return .systemFont(ofSize: 32, weight: .bold)
            case .medium:
                return .systemFont(ofSize: 20, weight: .bold)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, size: Size) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = .main
        self.titleLabel?.font = size.font
        setConfig(height: size.height) //init시 setConfig 메서드 호출
    }
    
//    convenience init(title: String) {
//        self.init(title: title,
//                  font: .systemFont(ofSize: 32, weight: .bold),
//                  color: .main,
//                  height: 92
//        )
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 인스턴스가 생성될때 초기 설정 값 설정 메서드
    func setConfig(height: Int) {
        self.layer.cornerRadius = 20
        self.setTitleColor(.white, for: .normal)
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
}
