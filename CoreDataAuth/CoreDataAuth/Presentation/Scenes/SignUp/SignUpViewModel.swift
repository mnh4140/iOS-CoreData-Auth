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
    
    enum SignUpError: LocalizedError {
        case duplicateID
        case saveFailed

        var errorDescription: String? {
            switch self {
            case .duplicateID: return "이미 존재하는 아이디입니다."
            case .saveFailed:  return "사용자 생성에 실패했습니다."
            }
        }
    }
    
    enum State {
        case empty                  // 초기: 입력 없음 → 블랙 가이드
        case formatInvalid          // 형식 불일치(영문/숫자만 등) → 레드
        case available              // 사용 가능 → 블랙(또는 그린)
        case duplicate              // 중복 → 레드
        case error(String)          // 에러 → 레드
    }
    
    // 상태는 Driver, 이벤트는 Signal
    struct Input {
        let id: Driver<String>
        let nickname: Driver<String>
        let password: Driver<String>
        let confirm: Driver<String>
        let closeTapped: Signal<Void> // 우측 상단 닫기 버튼 탭
        let signUpButtonTap: Signal<Void> // 회원가입 버튼 탭
    }
    
    struct Output {
        let idState: Driver<State>
        let nicknameState: Driver<State>
        let passwordState: Driver<State>
        let confirmState: Driver<State>
        let dismissRequested: Signal<Void> // 닫기 버튼 이벤트
        let navigation: Signal<Navigation>
        let isEnabled: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // 유효성 검사
        /*
         ^ : 문자열 시작
         [가-힣] : 한글 범위 (가 ~ 힣)
         (?=.*[a-z]) → 소문자 영문이 반드시 하나 이상
         (?=.*[0-9]) → 숫자가 반드시 하나 이상
         [a-z0-9]+ → 전체 문자는 소문자나 숫자로만 구성
         $ : 문자열 끝
         */
        let idValidPattern = "^(?=.*[a-z])(?=.*[0-9])[a-z0-9]+$"
        let nicknameValidPattern = "^[A-Za-z0-9가-힣]{2,6}$"
        let passwordValidPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,16}$"
        
        // 아이디 유효성 검사
        let idState = input.id
            .debounce(.milliseconds(400)) // 마지막 이벤트가 발생하고 400ms 동안 추가 이벤트가 없을 때 그 마지막 이벤트를 방출.
            .distinctUntilChanged() // 이전 값과 새 값이 같으면 무시
            .flatMapLatest { id -> Driver<State> in
                guard !id.isEmpty else { return .just(.empty) }
                guard id.range(of: idValidPattern, options: .regularExpression) != nil
                else { return .just(.formatInvalid) }
                
                let result = Single<State>.create { single in
                    let exists = (CoreDataManager.shared.fetchUserID(id: id) != nil)
                    single(.success(exists ? .duplicate : .available))
                    return Disposables.create()
                }
                    .asDriver(onErrorJustReturn: .error("중복 확인 중 오류 발생"))
                
                return result.asDriver(onErrorJustReturn: .error("중복 확인 중 오류 발생"))
            }
            .startWith(.empty)
        
        // 닉네임 유효성 검사
        let nicknameState = input.nickname
            .debounce(.milliseconds(400))
            .distinctUntilChanged()
            .flatMapLatest { nickname -> Driver<State> in
                guard !nickname.isEmpty else { return .just(.empty) }
                guard nickname.range(of: nicknameValidPattern, options: .regularExpression) != nil else { return .just(.formatInvalid) }
                // TODO: DB 조회가 메인스레드에서 진행 -> 백그라운드로 진행하도록 리팩 해야됨
                let exists = (CoreDataManager.shared.fetchUserNickname(nickname: nickname) != nil)
                return .just(exists ? .duplicate : .available)
            }
            .startWith(.empty)
        
        // 비밀번호 유효성 검사
        let passwordState = input.password
            .debounce(.milliseconds(400))
            .distinctUntilChanged()
            .flatMapLatest { password -> Driver<State> in
                guard !password.isEmpty else { return .just(.empty) }
                guard password.range(of: passwordValidPattern, options: .regularExpression) != nil else { return .just(.formatInvalid) }
                
                return .just(.available)
            }
            .startWith(.empty)
        
        // 비밀번호와 비밀번호 확인 칸이 동일한지 체크
        let confirmState = Driver.combineLatest(input.password, input.confirm)
            .debounce(.milliseconds(400))
            .flatMapLatest { password, confirm -> Driver<State> in
                guard !confirm.isEmpty else { return .just(.empty) }
                guard password == confirm else { return .just(.formatInvalid) }
                
                return .just(.available)
            }
            .startWith(.empty)
        
        // 모든 항목이 다 맞으면 버튼 활성화
        let isEnabled = Driver
            .combineLatest(idState, nicknameState, passwordState, confirmState)
            .map { id, nickname, password, confirm in
                self.isAvailable(id) &&
                self.isAvailable(nickname) &&
                self.isAvailable(password) &&
                self.isAvailable(confirm)
            }
            .distinctUntilChanged()
        
        let userInfo = Driver
            .combineLatest(input.id, input.nickname, input.password)
        
        let saveData: Signal<Navigation> = input.signUpButtonTap.asDriver(onErrorDriveWith: .empty())
            .throttle(.milliseconds(500))
            .withLatestFrom(isEnabled)   // 탭 시점의 활성 여부
            .filter { $0 }
            .withLatestFrom(userInfo)
            .flatMapLatest { id, nickname, password in
                // TODO: 데이터 저장은 백그라운트 큐로 변경하기
                CoreDataManager.shared.createAppUser(id: id, nickname: nickname, password: password)
                    .andThen(Single.just(Navigation.main))
                    .asSignal(onErrorRecover: { error in
                        let message = (error as? SignUpError)?.errorDescription ?? error.localizedDescription
                        return .just(.error(message))
                    })
            }
        
        return Output(
            idState: idState,
            nicknameState: nicknameState,
            passwordState: passwordState,
            confirmState: confirmState,
            dismissRequested: input.closeTapped,
            navigation: saveData,
            isEnabled: isEnabled
        )
    }
    
    // 헬퍼 메서드
    private func isAvailable(_ state: State) -> Bool {
        if case .available = state { return true } else { return false }
    }
}
