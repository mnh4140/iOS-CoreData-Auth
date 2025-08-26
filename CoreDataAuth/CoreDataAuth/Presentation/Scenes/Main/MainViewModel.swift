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
        let logoutButtonTrigger: Observable<Void>
        let unregisterButtonTrigger: Observable<Void>
    }
    
    struct Output {
        let navigation: Driver<Navigation>
    }
    
    var disposeBag = DisposeBag()
    private let navRelay = PublishRelay<Navigation>()
    
    func transform(input: Input) -> Output {
        input.logoutButtonTrigger
            .subscribe(onNext: { [weak self] in
                self?.navRelay.accept(.logout)
            }).disposed(by: disposeBag)
        
        input.unregisterButtonTrigger
            .subscribe(onNext: { [ weak self] in
                self?.navRelay.accept(.unregister)
            }).disposed(by: disposeBag)
        
        return Output(
            navigation: navRelay.asDriver(onErrorJustReturn: .error("에러 발생"))
        )
    }
}
