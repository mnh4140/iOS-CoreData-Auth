//
//  AdminViewController.swift
//  CoreDataAuth
//
//  Created by NH on 9/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AdminViewController: UIViewController {

    // MARK: - Propertys
    let titleLabel = UILabel()
    let tableView = UITableView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        bindTable()
    }
    
    // MARK: - Methods
    func setUI() {
        view.backgroundColor = .white
        
        titleLabel.text = "회원 정보"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        tableView.backgroundColor = .blue
        tableView.rowHeight = 60
        tableView.register(AdminTableViewCell.self, forCellReuseIdentifier: String(describing: AdminTableViewCell.self))
        view.addSubview(tableView)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bindTable() {
        let closeItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: nil,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = closeItem
        
        closeItem.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        CoreDataManager.shared.rxFetchUser()
            .asObservable()
            .bind(to: tableView.rx.items(
                cellIdentifier: String(describing: AdminTableViewCell.self),
                cellType: AdminTableViewCell.self)
            ) { _, user, cell in
                cell.configure(id: user.id, nickname: user.nickname, password: user.password)
            }
            .disposed(by: disposeBag)
    }
}
