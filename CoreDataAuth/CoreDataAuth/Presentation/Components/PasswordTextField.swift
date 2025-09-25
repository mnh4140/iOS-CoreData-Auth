//
//  PasswordTextField.swift
//  CoreDataAuth
//
//  Created by NH on 9/25/25.
//

import UIKit
import SnapKit

final class PasswordTextField: UITextField {
    // MARK: - Propertys
    let showPlainTextButton = UIButton()
    var rightPadding: CGFloat = 64
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        toggleButton()
        bindEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    /// 텍스트필드가 편집 중이 아닐 때 텍스트와 placeholder가 그려질 영역(Rect)을 정의.
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightPadding))
    }
    
    /// 텍스트필드가 편집 중일 때 (즉, 커서가 활성화된 상태) 텍스트가 그려질 영역(Rect)을 정의.
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }
    
    private func setUI() {
        font = .systemFont(ofSize: 17)
        placeholder = "비밀번호"
        clearButtonMode = .whileEditing // 입력 중 x 버튼 생성
        isSecureTextEntry = true // 문자열이 * 처리됨
        textContentType = .password
        autocapitalizationType = .none // 첫 영문자를 항상 소문자로 시작
        
        showPlainTextButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPlainTextButton.setImage(UIImage(systemName: "eye.slash"), for: .selected) // 탭 시
        showPlainTextButton.accessibilityLabel = "비밀번호 보기" // 마우스 오버로 보이는 텍스트
        showPlainTextButton.tintColor = .gray
        showPlainTextButton.layer.zPosition = 1
        showPlainTextButton.isHidden = true
        
        bringSubviewToFront(showPlainTextButton)
        addSubview(showPlainTextButton)
    }
    
    private func setConstraints() {
        showPlainTextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(32)
            make.width.height.equalTo(24)
        }
    }
    
    private func toggleButton() {
        showPlainTextButton.addTarget(self, action: #selector(toggleSecure), for: .touchUpInside)
    }
    
    @objc private func toggleSecure() {
        // 눈 모양 변경
        showPlainTextButton.isSelected.toggle()
        
        // 평문 전환
        isSecureTextEntry.toggle()
        
        // 접근성 라벨 갱신
        showPlainTextButton.accessibilityLabel = showPlainTextButton.isSelected ? "비밀번호 숨기기" : "비밀번호 표시"
        
        // 버튼 가시성도 최신 상태로
        updateEyeVisibility()
    }
    
    private func bindEvents() {
        // 가시성 업데이트 트리거들
        addTarget(self, action: #selector(onEditingDidBegin), for: .editingDidBegin) // 포커스 시작 시점
        addTarget(self, action: #selector(onEditingDidEnd),   for: .editingDidEnd) // 포커스 해제 시점
        addTarget(self, action: #selector(onEditingChanged),  for: .editingChanged) // 실시간 입력 변화 시점
        
        // 초기 상태
        updateEyeVisibility()
    }

    @objc private func onEditingDidBegin() { updateEyeVisibility() }
    @objc private func onEditingDidEnd()   { updateEyeVisibility() }
    @objc private func onEditingChanged()  { updateEyeVisibility() }
    
    private func updateEyeVisibility() {
        let hasText = !(text ?? "").isEmpty
        // 편집 중이고 && 텍스트가 있을 때만 표시
        showPlainTextButton.isHidden = !(isFirstResponder && hasText)
    }
}
