//
//  CoreDataManager.swift
//  CoreDataAuth
//
//  Created by NH on 8/25/25.
//

import UIKit
import CoreData

final class CoreDataManager {
    // MARK: - Propertys
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Create
    /// 사용자 정보 생성
    func createAppUser(id: String, nickname: String, password: String) {
        if fetchUser(id: id, password: password) != nil {
            print("이미 존재하는 사용자입니다.")
            return
        }
        let user = UserEntity(context: context)
        user.id = id
        user.nickname = nickname
        user.passwordHash = password
        saveContext()
    }
    
    // MARK: - Read
    /// 로그인 시 유저 유효성 검사
    func fetchUser(id: String, password: String) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND passwordHash == %@", id, password)
        do {
            return try context.fetch(request).first
        } catch {
            print("Login Fetch Failed: \(error)")
            return nil
        }
    }
    
    /// 중복 아이디 유무 확인
    func fetchUserID(id: String) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try context.fetch(request).first
        } catch {
            print("Login Fetch Failed: \(error)")
            return nil
        }
    }
    
    // MARK: - Update
    
    // MARK: - Delete
    func deleteAppUser(user: UserEntity) {
        context.delete(user)
        saveContext()
    }
    
    // MARK: - Save
    /// 코어데이터에 데이터 저장
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save Failed: \(error)")
            }
        }
    }
}
