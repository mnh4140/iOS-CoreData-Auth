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
    struct Input {
        let closeTapped: Signal<Void>
    }
    
    struct Output {
        let dismissRequested: Signal<Void>
    }
    
    var disposbag = DisposeBag()
    
    func transform(input: Input) -> Output {
        return Output(
            dismissRequested: input.closeTapped
        )
    }
}
