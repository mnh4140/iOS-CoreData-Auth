//
//  SignUpViewController.swift
//  CoreDataAuth
//
//  Created by NH on 8/22/25.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController {
    
    // MARK: - Propertys
    private let signUpView = SignUpView()
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = signUpView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    // MARK: - Methods
    @objc private func didTapClose() {
            dismiss(animated: true)
        }
}
