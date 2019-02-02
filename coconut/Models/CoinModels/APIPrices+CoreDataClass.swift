//
//  APIPrices+CoreDataClass.swift
//  coconut
//
//  Created by macos on 01/02/19.
//  Copyright © 2019 Notebook. All rights reserved.
//
//

import Foundation
import CoreData

@objc(APIPrices)
public class APIPrices: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.managedObjectContext, let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "APIPrices", in: managedObjectContext) else {
            fatalError()
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        btc = try values.decode(BTC.self, forKey: .btc)
        dash = try values.decode(DASH.self, forKey: .dash)
        eth = try values.decode(ETH.self, forKey: .eth)
        doge = try values.decode(DOGE.self, forKey: .doge)
        ltc = try values.decode(LTC.self, forKey: .ltc)
        xrp = try values.decode(XRP.self, forKey: .xrp)
        zec = try values.decode(ZEC.self, forKey: .zec)
        etc = try values.decode(ETC.self, forKey: .etc)
        trx = try values.decode(TRX.self, forKey: .trx)
        bcc = try values.decode(BCC.self, forKey: .bcc)
        neo = try values.decode(NEO.self, forKey: .neo)
        eos = try values.decode(EOS.self, forKey: .eos)
    }
}


