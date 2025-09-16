//
//  DefaultSessionStore.swift
//  CoreDataAuth
//
//  Created by NH on 9/16/25.
//

import Foundation

/// 세션 저장 키 (UserDefaults)
enum SessionKey {
    static let loggedInUserId = "loggedInUserId"
}

/// 세션 저장 / 조회 전용 래퍼
protocol SessionStore {
    var currentUserId: String? { get set }
    func clear()
}

final class DefaultSessionStore: SessionStore {
    private let ud = UserDefaults.standard // 앱의 기본 저장소 인스턴스
    
    var currentUserId: String? {
        get { ud.string(forKey: SessionKey.loggedInUserId) }
        set {
            if let id = newValue {
                ud.set(id, forKey: SessionKey.loggedInUserId)
            } else {
                ud.removeObject(forKey: SessionKey.loggedInUserId)
            }
        }
    }
    
    // 세션 초기화
    func clear() {
        ud.removeObject(forKey: SessionKey.loggedInUserId)
    }
}
