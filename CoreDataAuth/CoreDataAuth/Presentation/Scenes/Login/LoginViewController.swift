//
//  StartViewController.swift
//  CoreDataAuth
//
//  Created by NH on 8/20/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    // MARK: - Propertys
    private let loginView = LoginView()
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = loginView
    }
    
    // 네비게이션 영역 숨김
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Methods
}
