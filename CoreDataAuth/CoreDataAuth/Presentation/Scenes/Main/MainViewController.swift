//
//  MainViewController.swift
//  CoreDataAuth
//
//  Created by NH on 8/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    // MARK: - Propertys
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private var disposeBag = DisposeBag()
    
    // "탈퇴 확인"을 흘려보낼 릴레이
    private let deleteConfirmRelay = PublishRelay<Void>()
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindDeleteAlert()  // 탈퇴 확인 알럿 트리거
    }
    
    // MARK: - Methods
    func bindViewModel() {
        let input = MainViewModel.Input(
            logoutTap: mainView.logoutButton.rx.tap.asSignal(),
            deleteConfirmTap: deleteConfirmRelay.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.moveToLogin
            .emit(onNext: { AppRouter.toLogin() })   // 루트 교체
            .disposed(by: disposeBag)
        
        output.showError
            .emit(onNext: { [weak self] msg in
                let ac = UIAlertController(title: "오류", message: msg, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(ac, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    /// 탈퇴 버튼 탭 → 확인 알럿 → '탈퇴' 선택 시 deleteConfirmRelay 방출
        private func bindDeleteAlert() {
            mainView.unregisterButton.rx.tap
                .bind(onNext: { [weak self] in
                    let ac = UIAlertController(
                        title: "회원 탈퇴",
                        message: "정말 탈퇴하시겠어요?",
                        preferredStyle: .alert
                    )
                    ac.addAction(UIAlertAction(title: "취소", style: .cancel))
                    ac.addAction(UIAlertAction(title: "탈퇴", style: .destructive, handler: { _ in
                        self?.deleteConfirmRelay.accept(())
                    }))
                    self?.present(ac, animated: true)
                })
                .disposed(by: disposeBag)
        }
}
