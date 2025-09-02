//
//  AdminTableViewCell.swift
//  CoreDataAuth
//
//  Created by NH on 9/3/25.
//

import UIKit

final class AdminTableViewCell: UITableViewCell {
    let idLabel = UILabel()
    let nicknameLabel = UILabel()
    let passwordLabel = UILabel()
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        idLabel.text = "아이디"
        idLabel.textColor = .black
        idLabel.font = .systemFont(ofSize: 18, weight: .medium)
        contentView.addSubview(idLabel)
        
        nicknameLabel.text = "닉네임"
        nicknameLabel.textColor = .black
        nicknameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        contentView.addSubview(nicknameLabel)
        
        passwordLabel.text = "패스워드"
        passwordLabel.textColor = .black
        passwordLabel.font = .systemFont(ofSize: 18, weight: .medium)
        contentView.addSubview(passwordLabel)
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(nicknameLabel)
        stackView.addArrangedSubview(passwordLabel)
        contentView.addSubview(stackView)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(id: String, nickname: String, password: String) {
        self.idLabel.text = id
        self.nicknameLabel.text = nickname
        self.passwordLabel.text = password
    }
}
