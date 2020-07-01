//
//  DeliveryOrderManager.swift
//  Deliverable
//
//  Created by EisenWolf on 6/28/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import UIKit
import CoreData

final class DeliveryOrder {
    /* ---------------------------- Initializer ----------------------------- */
    private init() { }
    /* -------------------------- Internal Access --------------------------- */
    /**
     Internal function to perform simple liener seach on the fetched storage.
     
     - Note:
     
     - Parameters:
        -   fetchedStorage: Fetched list of saved delivery orders.
        -   orderID: D of the order to be matched
     */
    private func searchDatabase(fetchedStorage: [FavoriteDeliveryOrder], orderID: String) -> Int? {
        var searchIndex = 0
        for order in fetchedStorage {
            if order.orderID == orderID {
                return searchIndex
            }
            searchIndex += 1
        }
        return nil
    }
    
    /* -------------------------- External Access --------------------------- */
    public static let manager = DeliveryOrder()
    
    /**
     External function to seach database and check if given order has been set favorite.
     
     - Note:
     Return false if not matched order found.
     
     - Parameters:
        -   orderID: ID of the order to be set favorite.
     */
    public func checkFavorite(orderID: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteDeliveryOrder> = FavoriteDeliveryOrder.fetchRequest()
        
        let fetchedResults = HelperPersistence.manager.fetchCoreData(fetchRequest: fetchRequest)
        
        if !fetchedResults.isEmpty, let entryIndex = self.searchDatabase(fetchedStorage: fetchedResults, orderID: orderID) {
            let orderEntry = fetchedResults[entryIndex]
            
            return orderEntry.isFavourite
        } else {
            return false
        }
    }
    
    /**
     External function to set a order to favorite.
     
     - Note:
     If there are no exist record for given order ID, create a new entry then set to favorite.
     
     - Parameters:
        -   orderID: ID of the order to be set favorite.
     */
    public func setFavorite(orderID: String) {
        let fetchRequest: NSFetchRequest<FavoriteDeliveryOrder> = FavoriteDeliveryOrder.fetchRequest()
        
        let fetchedResults = HelperPersistence.manager.fetchCoreData(fetchRequest: fetchRequest)
        
        if !fetchedResults.isEmpty, let entryIndex = self.searchDatabase(fetchedStorage: fetchedResults, orderID: orderID) {
            let orderEntry = fetchedResults[entryIndex]
            
            orderEntry.isFavourite = true
        } else {
            let newEntry = FavoriteDeliveryOrder(context: HelperPersistence.manager.retreiveCoreDataContext())
            
            newEntry.orderID = orderID
            newEntry.isFavourite = true
            
            HelperPersistence.manager.saveCoreData()
        }
        
        HelperPersistence.manager.saveCoreData()
    }
    
    /**
     External function to remove a order from favorite.
     
     - Note:
     
     - Parameters:
        -   orderID: ID of the order to be unfavorite.
     */
    public func removeFavorite(orderID: String) {
        let fetchRequest: NSFetchRequest<FavoriteDeliveryOrder> = FavoriteDeliveryOrder.fetchRequest()
        
        let fetchedResults = HelperPersistence.manager.fetchCoreData(fetchRequest: fetchRequest)
        
        if !fetchedResults.isEmpty, let entryIndex = self.searchDatabase(fetchedStorage: fetchedResults, orderID: orderID) {
            let orderEntry = fetchedResults[entryIndex]
            
            orderEntry.isFavourite = false
        } else {
            debugPrint("<DeliveryOrderManager> Error, no entry found")
        }
        
        HelperPersistence.manager.saveCoreData()
    }
    
    /**
     External function to remove all unfavorited orders during current session before terminate.
     
     - Note:
     Remove unfavorive order from persistence to reduce the storage footprint.
     
     - Parameters:
     
     */
    public func clearUnfavoriteOrders() {
        let fetchRequest: NSFetchRequest<FavoriteDeliveryOrder> = FavoriteDeliveryOrder.fetchRequest()
        
        let fetchedResults = HelperPersistence.manager.fetchCoreData(fetchRequest: fetchRequest)
        
        for orderEntry in fetchedResults {
            if orderEntry.isFavourite == false {
                HelperPersistence.manager.deleteCoreData(deletionEntry: orderEntry)
            }
        }
        
        HelperPersistence.manager.saveCoreData()
    }
    
}

extension AppDelegate {
    /**
     Extension function to enable auto-save when user terminate the app.
     
     - Note:
     This function is used by AppDelegation.
     
     - Parameters:
     
     */
    func applicationWillTerminate(_ application: UIApplication) {
        DeliveryOrder.manager.clearUnfavoriteOrders()
    }
}
