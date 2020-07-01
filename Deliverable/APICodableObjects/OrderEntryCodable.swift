//
//  OrderEntryCodable.swift
//  Deliverable
//
//  Created by Wolf on 6/29/20.
//  Copyright © 2020 EisenWolf Studio. All rights reserved.
//

import Foundation

public struct DeliveryOrderEntry: Codable {
    public let orderID: String
    public let orderRemarkMessage: String
    public let orderTimestamp: String
    public let orderPictureURL: String
    public let orderDeliveryFee: String
    public let orderSurcharge: String
    public let orderRoute: OrderRoute
    public let orderSender: OrderSender
    
    private enum CodingKeys: String, CodingKey {
        case orderID = "id"
        case orderRemarkMessage = "remarks"
        case orderTimestamp = "pickupTime"
        case orderPictureURL = "goodsPicture"
        case orderDeliveryFee = "deliveryFee"
        case orderSurcharge = "surcharge"
        case orderRoute = "route"
        case orderSender = "sender"
    }
}

public struct OrderRoute: Codable {
    public let routeStart: String
    public let routeEnd: String
    
    private enum CodingKeys: String, CodingKey {
        case routeStart = "start"
        case routeEnd = "end"
    }
}

public struct OrderSender: Codable {
    public let senderPhone: String
    public let senderName: String
    public let senderEmail: String
    
    private enum CodingKeys: String, CodingKey {
        case senderPhone = "phone"
        case senderName = "name"
        case senderEmail = "email"
    }
}
