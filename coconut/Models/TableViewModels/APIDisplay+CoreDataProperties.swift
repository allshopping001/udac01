//
//  APIDisplay+CoreDataProperties.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//
//

import Foundation
import CoreData


extension APIDisplay {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<APIDisplay> {
        return NSFetchRequest<APIDisplay>(entityName: "APIDisplay")
    }

    @NSManaged public var fromSymbol: String?
    @NSManaged public var toSymbol: String?
    @NSManaged public var market: String?
    @NSManaged public var price: String?
    @NSManaged public var lastUpdate: String?
    @NSManaged public var lastVolume: String?
    @NSManaged public var lastVolumeTo: String?
    @NSManaged public var lastTradeId: String?
    @NSManaged public var volume24h: String?
    @NSManaged public var volume24hTo: String?
    @NSManaged public var open24h: String?
    @NSManaged public var high24h: String?
    @NSManaged public var low24h: String?
    @NSManaged public var lastMarket: String?
    @NSManaged public var change24h: String?
    @NSManaged public var changePCT24h: String?
    @NSManaged public var changeDay: String?
    @NSManaged public var changePCTDay: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var toRoot: APIRoot?
    
    enum CodingKeys: String, CodingKey {
        case market = "MARKET"
        case fromSymbol = "FROMSYMBOL"
        case toSymbol = "TOSYMBOL"
        case price = "PRICE"
        case lastUpdate = "LASTUPDATE"
        case lastVolume = "LASTVOLUME"
        case lastVolumeTo = "LASTVOLUMETO"
        case lastTradeId = "LASTTRADEID"
        case volume24h = "VOLUME24HOUR"
        case volume24hTo = "VOLUME24HOURTO"
        case open24h = "OPEN24HOUR"
        case high24h = "HIGH24HOUR"
        case low24h = "LOW24HOUR"
        case lastMarket = "LASTMARKET"
        case change24h = "CHANGE24HOUR"
        case changePCT24h = "CHANGEPCT24HOUR"
        case changeDay = "CHANGEDAY"
        case changePCTDay = "CHANGEPCTDAY"
        case creationDate
    }
}

extension APIDisplay {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "creationDate", ascending: true)]
    }
    
    static var sortedFetchRequest: NSFetchRequest<APIDisplay> {
        let request: NSFetchRequest<APIDisplay> = APIDisplay.fetchRequest()
        request.sortDescriptors = APIDisplay.defaultSortDescriptors
        return request
    }
}
