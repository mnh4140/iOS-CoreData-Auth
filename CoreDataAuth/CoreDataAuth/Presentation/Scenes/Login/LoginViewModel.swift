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
//        let isLoginEnabled: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let creds = Driver.combineLatest(input.id, input.password)
        
        // 버튼 활성화: 공백이 아니면 true
//        let isLoginEnabled = creds
//            .map { !$0.0.trimmingCharacters(in: .whitespaces).isEmpty && // TODO: trimmingCharacters 가 뭐냐?
//                !$0.1.trimmingCharacters(in: .whitespaces).isEmpty }
//            .distinctUntilChanged()
        
        let errorRelay = PublishRelay<String>()
        let successRelay = PublishRelay<Void>()
        
        // 탭 시 최신 id/pw 로 로그인 시도
        input.loginButtonTap
            .throttle(.milliseconds(500))
            .withLatestFrom(creds.asSignal(onErrorSignalWith: .empty()))
            .flatMapLatest { id, pw -> Signal<Void> in
                // 빈값 가드
                let idTrim = id.trimmingCharacters(in: .whitespaces)
                let pwTrim = pw.trimmingCharacters(in: .whitespaces)
                guard !idTrim.isEmpty, !pwTrim.isEmpty else {
                    errorRelay.accept(LoginInError.emptyFields.localizedDescription)
                    return .empty()
                }
                
                return CoreDataManager.shared.verifyLogin(id: idTrim, password: pwTrim)
                    .asSignal(onErrorSignalWith: .deferred {
                        errorRelay.accept("아이디 또는 비밀번호가 올바르지 않습니다.")
                        return .empty()
                    })
                    .map { _ in () } // 성공
            }
            .emit(to: successRelay)
            .disposed(by: disposeBag)
        
//        let loginButtonTap = input.loginButtonTap
//            .throttle(.milliseconds(500))
//            .map { Navigation.main }
        
        return Output(
            moveToMain: successRelay.asSignal(),
            moveToSignUp: input.signUpButtonTap,
            moveToAdmin: input.adminButtonTap,
            showError: errorRelay.asSignal()
//            isLoginEnabled: isLoginEnabled
        )
    }
    
    /// 로그인 처리
    /// - 로그인 버튼을 누르면
    /// - 아이디와 비밀번호를 코어데이터에 있는 계정 정보를 불러와 비교
    /// - 아이디와 비밀번호가 일치하면 main 화면으로 이동
    /// - 정보가 틀리면 alert 띄움
    func login() {
        
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
