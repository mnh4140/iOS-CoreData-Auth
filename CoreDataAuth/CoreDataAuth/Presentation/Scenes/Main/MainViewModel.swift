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
        let deleteConfirmTap: Signal<Void>  // “정말 탈퇴” 확인 버튼 탭
    }
    
    struct Output {
        let moveToLogin: Signal<Void>
        let showError: Signal<String>
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
        let errorRelay = PublishRelay<String>()
        
        // 로그아웃
        let logout: Signal<Void> = input.logoutTap
            .throttle(.milliseconds(500))
            .do(onNext: { [weak self] in
                self?.session.clear()   // 세션 제거
            })
            .map { }                    // Void로 방출
        
        // 회원탈퇴
        let delete: Signal<Void> = input.deleteConfirmTap
            .throttle(.milliseconds(500))
            .flatMapLatest { [weak self] _ -> Signal<Void> in
                guard let self = self,
                      let uid = self.session.currentUserId, !uid.isEmpty
                else {
                    errorRelay.accept("로그인 정보가 없습니다.")
                    return .empty()
                }
                // Completable -> Signal<Void>
                return CoreDataManager.shared.deleteAppUser(withId: uid)
                    .andThen(Single.just(()))
                    .asSignal(onErrorRecover: { error in
                        switch error {
                        case CoreDataError.notFound:
                            errorRelay.accept("계정을 찾을 수 없습니다.")
                        default:
                            errorRelay.accept("탈퇴 중 오류가 발생했습니다.")
                        }
                        return .empty()
                    })
            }
            .do(onNext: { [weak self] in self?.session.clear() })
        
        // 3) 두 흐름을 합쳐서 "로그인으로 이동" 신호 하나로
        let moveToLogin = Signal.merge(logout, delete)
        
        return Output(
            moveToLogin: moveToLogin,
            showError: errorRelay.asSignal()
        )
    }
}
