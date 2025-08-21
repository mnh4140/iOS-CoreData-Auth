//
//  GradientBackgroundView.swift
//  CoreDataAuth
//
//  Created by NH on 8/21/25.
//

import UIKit

final class GradientBackgroundView: UIView {
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.52, blue: 0.52, alpha: 1.0).cgColor, // #FF8585, 100%
            UIColor(red: 0.6, green: 0.39, blue: 0.39, alpha: 0.38).cgColor  // #996464, 38%
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 위쪽 중앙
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // 아래쪽 중앙

        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 화면 회전 시 그라데이션 레이어가 잘리거나 안맞는 것 방지
        layer.sublayers?.first?.frame = bounds
    }
}
