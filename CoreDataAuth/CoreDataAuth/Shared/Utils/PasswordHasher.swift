//
//  PasswordHasher.swift
//  CoreDataAuth
//
//  Created by NH on 8/25/25.
//

import Foundation
import CryptoKit

/// 단순 SHA256 해시 유틸
final class PasswordHasher {
    init() {}

    func hash(_ plain: String) -> String {
        let data = Data(plain.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    func verify(plain: String, hashed: String) -> Bool {
        return hash(plain) == hashed
    }
}
