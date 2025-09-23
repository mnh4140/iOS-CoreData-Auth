//
//  MainViewModel.swift
//  CoreDataAuth
//
//  Created by NH on 8/26/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
    enum Navigation {
        case logout
        case unregister
        case error(String)
    }
    
    struct Input {
        let logoutTap: Signal<Void> // 로그아웃
    }
    
    struct Output {
        let moveToLogin: Signal<Void>
    }
    
    // MARK: - Propertys
    private let session: SessionStore
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    init(session: SessionStore = DefaultSessionStore()) {
        self.session = session
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let moveToLogin = input.logoutTap
            .throttle(.milliseconds(500))
            .do(onNext: { [weak self] in
                self?.session.clear()   // 세션 제거
            })
            .map { }                    // Void로 방출
            .asSignal(onErrorSignalWith: .empty())
        
        
        return Output(
            moveToLogin: moveToLogin
        )
    }
}
