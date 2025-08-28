//
//  SignUpViewModel.swift
//  CoreDataAuth
//
//  Created by NH on 8/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    enum Navigation {
        case main
        case error(String)
    }
    
    struct Input {
        let closeTapped: Signal<Void> // 우측 상단 닫기 버튼 탭
        let buttonTap: Signal<Void> // 회원가입 버튼 탭
    }
    
    struct Output {
        let dismissRequested: Signal<Void> // 닫기 버튼 이벤트
        let navigation: Signal<Navigation>
    }
    
    var disposbag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let SuccessSignUp = input.buttonTap
            .throttle(.milliseconds(500))
            .map {Navigation.main}
        
        
        return Output(
            dismissRequested: input.closeTapped,
            navigation: SuccessSignUp
        )
    }
}
