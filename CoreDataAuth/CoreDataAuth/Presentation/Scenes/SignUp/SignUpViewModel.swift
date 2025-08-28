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
        let buttonTap: Signal<Void> // 회원가입 버튼 탭
        let signUpButtonTap: Signal<Void> // 회원가입 버튼 탭
    }
    
    struct Output {
        let idValid: Driver<Bool>
        let nicknameValid: Driver<Bool>
        let passwordValid: Driver<Bool>
        let confirmValid: Driver<Bool>
        let dismissRequested: Signal<Void> // 닫기 버튼 이벤트
        let navigation: Signal<Navigation>
    }
    
    var disposbag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let SuccessSignUp = input.buttonTap
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
        let idValid = input.id
            .map { $0.range(of: idValidPattern, options: .regularExpression) != nil }
            .distinctUntilChanged()
        
        // 닉네임 유효성 검사
        let nicknameValid = input.nickname
            .map { $0.range(of: nicknameValidPattern, options: .regularExpression) != nil }
            .distinctUntilChanged()
        
        // 비밀번호 유효성 검사
        let passwordValid = input.password
            .map { $0.range(of: passwordValidPattern, options: .regularExpression) != nil }
            .distinctUntilChanged()
        
        // 비밀번호와 비밀번호 확인 칸이 동일한지 체크
        let confirmValid = Driver.combineLatest(input.password, input.confirm)
            .map { $0 == $1 && !$1.isEmpty }
            .distinctUntilChanged()
        
        // 모든 항목이 다 맞으면 버튼 활성화 (아직 미구현)
        let isEnabled = Driver.combineLatest(idValid, nicknameValid, passwordValid, confirmValid)
            .map { $0 && $1 && $2 && $3 }
            .distinctUntilChanged()
        
        let SuccessSignUp = input.signUpButtonTap
            .throttle(.milliseconds(500))
            .map {Navigation.main}
        
        
        return Output(
            idValid: idValid,
            nicknameValid: nicknameValid,
            passwordValid: passwordValid,
            confirmValid: confirmValid,
            dismissRequested: input.closeTapped,
            navigation: SuccessSignUp
        )
    }
}
