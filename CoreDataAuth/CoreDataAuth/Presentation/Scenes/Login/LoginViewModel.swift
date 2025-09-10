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
        let loginButtonTap: Observable<Void>
        let signUpButtonTap: Observable<Void>
        let loginButtonTap: Signal<Void>
        let signUpButtonTap: Signal<Void>
        let adminButtonTap: Signal<Void>
    }
    
    struct Output {
        let moveToMain: Signal<Void>
        let moveToSignUp: Signal<Void>
        let moveToAdmin: Signal<Void>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // 로그인 버튼 탭
        // id, pw 필드에 값을 본다.
        // 비어있으면 비어있다는 에러 출력
        // id, pw 필드에 값이 모두 있다면
        // id, pw 값과 coredata 의 정보와 일치하는지 확인
        //
        let loginButtonTap = input.loginButtonTap
            .throttle(.milliseconds(500))
            .map { Navigation.main }
        
        let signUpButtonTap = input.signUpButtonTap
            .throttle(.milliseconds(500))
            .map { Navigation.signUp }
        
        return Output(
            moveToMain: input.loginButtonTap,
            moveToSignUp: input.signUpButtonTap,
            moveToAdmin: input.adminButtonTap
        )
    }
}
