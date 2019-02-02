//
//  APIRaw+CoreDataProperties.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.//
//

import Foundation
import CoreData


extension APIRaw {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APIRaw> {
        return NSFetchRequest<APIRaw>(entityName: "APIRaw")
    }

    @NSManaged public var market: String?
    @NSManaged public var fromSymbol: String?
    @NSManaged public var toSymbol: String?
    @NSManaged public var flags: Int32
    @NSManaged public var price: Double
    @NSManaged public var lastUpdate: Int32
    @NSManaged public var lastVolume: Double
    @NSManaged public var lastVolumeTo: Double
    @NSManaged public var lastTradeId: String?
    @NSManaged public var volume24h: Double
    @NSManaged public var volume24hTo: Double
    @NSManaged public var open24h: Double
    @NSManaged public var high24h: Double
    @NSManaged public var low24h: Double
    @NSManaged public var lastMarket: String?
    @NSManaged public var change24h: Double
    @NSManaged public var changePCT24h: Double
    @NSManaged public var changeDay: Int32
    @NSManaged public var changePCTDay: Int32
    @NSManaged public var creationDate: Date?
    @NSManaged public var toRoot: APIRoot?
    
    enum CodingKeys: String, CodingKey {
        case market = "MARKET"
        case fromSymbol = "FROMSYMBOL"
        case toSymbol = "TOSYMBOL"
        case flags = "FLAGS"
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

extension APIRaw {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "creationDate", ascending: true)]
    }
    
    static var sortedFetchRequest: NSFetchRequest<APIRaw> {
        let request: NSFetchRequest<APIRaw> = APIRaw.fetchRequest()
        request.sortDescriptors = APIRaw.defaultSortDescriptors
        return request
    }
}
