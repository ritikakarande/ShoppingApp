//
//  CartData+CoreDataProperties.swift
//  
//
//  Created by Capgemini-DA087 on 9/27/22.
//
//

import Foundation
import CoreData


extension CartData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartData> {
        return NSFetchRequest<CartData>(entityName: "CartData")
    }

    @NSManaged public var productTitle: String?
    @NSManaged public var productImage: String?
    @NSManaged public var productDescription: String?

}
