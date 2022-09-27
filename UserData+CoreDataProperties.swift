//
//  UserData+CoreDataProperties.swift
//  
//
//  Created by Capgemini-DA087 on 9/26/22.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var userMobile: String?
    @NSManaged public var userName: String?
    @NSManaged public var userEmailId: String?
    @NSManaged public var userPassword: String?

}
