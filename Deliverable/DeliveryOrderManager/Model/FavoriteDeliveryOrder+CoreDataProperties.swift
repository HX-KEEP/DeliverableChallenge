//
//  FavoriteDeliveryOrder+CoreDataProperties.swift
//  Deliverable
//
//  Created by Wolf on 6/30/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteDeliveryOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteDeliveryOrder> {
        return NSFetchRequest<FavoriteDeliveryOrder>(entityName: "FavoriteDeliveryOrder")
    }

    @NSManaged public var isFavourite: Bool
    @NSManaged public var orderID: String?

}
