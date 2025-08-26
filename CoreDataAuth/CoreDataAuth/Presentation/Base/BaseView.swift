//
//  BaseView.swift
//  CoreDataAuth
//
//  Created by NH on 8/26/25.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {}
    
    func setConstraints() {}
}
