//
//  APIDisplay+CoreDataClass.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//
//

import Foundation
import CoreData

@objc(APIDisplay)
public class APIDisplay: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.managedObjectContext, let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "APIDisplay", in: managedObjectContext) else {
            fatalError()
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        market = try values.decode(String.self, forKey: .market)
        fromSymbol = try values.decode(String.self, forKey: .fromSymbol)
        toSymbol = try values.decode(String.self, forKey: .toSymbol)
        price = try values.decode(String.self, forKey: .price)
        lastUpdate = try values.decode(String.self, forKey: .lastUpdate)
        lastVolume = try values.decode(String.self, forKey: .lastVolume)
        lastVolumeTo = try values.decode(String.self, forKey: .lastVolumeTo)
        lastTradeId = try values.decode(String.self, forKey: .lastTradeId)
        volume24h = try values.decode(String.self, forKey: .volume24h)
        volume24hTo = try values.decode(String.self, forKey: .volume24hTo)
        open24h = try values.decode(String.self, forKey: .open24h)
        high24h = try values.decode(String.self, forKey: .high24h)
        low24h = try values.decode(String.self, forKey: .low24h)
        lastMarket = try values.decode(String.self, forKey: .lastMarket)
        change24h = try values.decode(String.self, forKey: .change24h)
        changePCT24h = try values.decode(String.self, forKey: .changePCT24h)
        changeDay = try values.decode(String.self, forKey: .changeDay)
        changePCTDay = try values.decode(String.self, forKey: .changePCTDay)
    }
    
    override public func awakeFromInsert() {
        super .awakeFromInsert()
        creationDate = Date()
    }
}
