//
//  UserEntity+CoreDataProperties.swift
//  CoreDataAuth
//
//  Created by NH on 8/25/25.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var nickname: String?
    @NSManaged public var passwordHash: String?

}

extension UserEntity : Identifiable {

}
