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
        case login
        case signUp
        case error(String)
    }
    
    struct Input {
        let loginButtonTap: Observable<Void>
        let signUpButtonTap: Observable<Void>
        let adminButtonTap: Signal<Void>
    }
    
    struct Output {
        let navigation: Driver<Navigation>
        let moveToAdmin: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    
    let stepRelay = PublishRelay<Navigation>()
    
    func transform(input: Input) -> Output {
        input.loginButtonTap
            .subscribe(onNext: { [weak self] in
                self?.stepRelay.accept(.login)
            }).disposed(by: disposeBag)
        
        input.signUpButtonTap
            .subscribe(onNext: { [weak self] in
                self?.stepRelay.accept(.signUp)
            }).disposed(by: disposeBag)
        
        return Output(
            navigation: stepRelay.asDriver(onErrorJustReturn: .error("알 수 없는 오류")),
            moveToAdmin: input.adminButtonTap
        )
    }
}
