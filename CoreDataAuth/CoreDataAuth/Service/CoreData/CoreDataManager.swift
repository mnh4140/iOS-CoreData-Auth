//
//  CoreDataManager.swift
//  CoreDataAuth
//
//  Created by NH on 8/25/25.
//

import UIKit
import CoreData
import RxSwift

enum CoreDataError: Error { case notFound }

final class CoreDataManager {
    // MARK: - Propertys
    static let shared = CoreDataManager()
    
    // TODO: 백그라운드 context 생성해서 분리해야됨.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let hasher = PasswordHasher() // 패스워드 해시로 저장
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Create
    /// 사용자 정보 생성
    func createAppUser(id: String, nickname: String, password: String) -> Completable {
        return Completable.create { completable in
            if self.fetchUser(id: id, password: password) != nil {
                // 이미 존재하는 경우
                completable(.error(SignUpViewModel.SignUpError.duplicateID))
            } else {
                let user = UserEntity(context: self.context)
                user.id = id
                user.nickname = nickname
                user.passwordHash = PasswordHasher().hash(password)
                self.saveContext()
                completable(.completed)
            }
            return Disposables.create()
        }
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
    
    func rxFetchUser() -> Single<[(id: String, nickname: String, password: String)]> {
        return Single.create { single in
            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            
            self.context.perform {
                do {
                    let users = try self.context.fetch(request).compactMap { m -> (id: String, nickname: String, password: String)? in
                        guard let id = m.id,
                                let nick = m.nickname,
                                let pw = m.passwordHash else { return nil }
                        return .init((id: id, nickname: nick, password: pw))
                    }
                    single(.success(users))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
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
    
    /// 닉네임 중복 검사
    func fetchUserNickname(nickname: String) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "nickname == %@", nickname)
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
