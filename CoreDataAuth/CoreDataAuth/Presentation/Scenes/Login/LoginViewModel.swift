//
//  StartViewModel.swift
//  CoreDataAuth
//
//  Created by NH on 8/26/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    enum Navigation {
        case main
        case signUp
        case error(String)
    }
    
    struct Input {
        let id: Driver<String>
        let password: Driver<String>
        let loginButtonTap: Signal<Void>
        let signUpButtonTap: Signal<Void>
        let adminButtonTap: Signal<Void>
    }
    
    struct Output {
        let moveToMain: Signal<Void>
        let moveToSignUp: Signal<Void>
        let moveToAdmin: Signal<Void>
        let showError: Signal<String>
    }
    
    var disposeBag = DisposeBag()
    
    private var session: SessionStore
    
    init(session: SessionStore = DefaultSessionStore()) {
        self.session = session
    }
    
    func transform(input: Input) -> Output {
        let creds = Driver.combineLatest(input.id, input.password)
        
        let errorRelay = PublishRelay<String>()
        let successRelay = PublishRelay<Void>()
        
        // 탭 시 최신 id/pw 로 로그인 시도
        input.loginButtonTap
            .throttle(.milliseconds(500))
            .withLatestFrom(creds.asSignal(onErrorSignalWith: .empty()))
            .flatMapLatest { id, pw -> Signal<UserEntity> in
                // 1) 입력 정리/가드
                let idTrim = id.trimmingCharacters(in: .whitespaces)
                let pwTrim = pw.trimmingCharacters(in: .whitespaces)
                guard !idTrim.isEmpty, !pwTrim.isEmpty else {
                    errorRelay.accept(LoginInError.emptyFields.localizedDescription)
                    return .empty()
                }
                // 2) 로그인 시도 (Single<UserEntity> -> Signal<UserEntity>)
                return CoreDataManager.shared.verifyLogin(id: idTrim, password: pwTrim)
                    .asSignal(onErrorRecover: { error in
                        switch error {
                        case CoreDataError.notFound:
                            errorRelay.accept("존재하지 않는 아이디입니다.")
                        case LoginInError.wrongPassword:
                            errorRelay.accept("비밀번호가 올바르지 않습니다.")
                        default:
                            errorRelay.accept("로그인 중 오류가 발생했습니다.")
                        }
                        return .empty() // 에러 시 대체 시그널
                    })
            }
            // 3) 성공 시 세션 저장
            .do(onNext: { [weak self] user in
                // user.id 가 Optional이면 안전하게 처리
                if let uid = user.id, !uid.isEmpty {
                    self?.session.currentUserId = uid
                } else {
                    // 혹시 모를 방어(없다면 자동로그인 off)
                    self?.session.currentUserId = nil
                }
            })
            // 4) 화면 전환 신호로 변환
            .map { _ in () } // 성공
            .emit(to: successRelay)
            .disposed(by: disposeBag)
        
        return Output(
            moveToMain: successRelay.asSignal(),
            moveToSignUp: input.signUpButtonTap,
            moveToAdmin: input.adminButtonTap,
            showError: errorRelay.asSignal()
        )
    }
}

// TODO: 로딩 인디케이터 추가하기
//final class ActivityIndicator: SharedSequenceConvertibleType {
//    typealias Element = Bool
//    typealias SharingStrategy = DriverSharingStrategy
//
//    private let relay = BehaviorRelay(value: false)
//    
//    func trackActivity<T>(_ source: Single<T>) -> Single<T> {
//        return Single.create { observer in
//            self.relay.accept(true)
//            let d = source.subscribe { event in
//                self.relay.accept(false)
//                observer(event)
//            }
//            return Disposables.create { d.dispose() }
//        }
//    }
//    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
//        relay.asDriver()
//    }
//    func asDriver() -> Driver<Bool> { relay.asDriver() }
//}
