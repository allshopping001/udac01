//
//  APIPrices+CoreDataProperties.swift
//  coconut
//
//  Created by macos on 01/02/19.
//  Copyright © 2019 Notebook. All rights reserved.
//
//

import Foundation
import CoreData


extension APIPrices {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APIPrices> {
        return NSFetchRequest<APIPrices>(entityName: "APIPrices")
    }

    @NSManaged public var btc: BTC?
    @NSManaged public var dash: DASH?
    @NSManaged public var doge: DOGE?
    @NSManaged public var eth: ETH?
    @NSManaged public var ltc: LTC?
    @NSManaged public var xrp: XRP?
    @NSManaged public var zec: ZEC?
    @NSManaged public var etc: ETC?
    @NSManaged public var trx: TRX?
    @NSManaged public var bcc: BCC?
    @NSManaged public var neo: NEO?
    @NSManaged public var eos: EOS?
    @NSManaged public var creationDate: Date?

    
    enum CodingKeys : String, CodingKey {
        case btc = "BTC"
        case dash = "DASH"
        case doge = "DOGE"
        case eth = "ETH"
        case ltc = "LTC"
        case xrp = "XRP"
        case zec = "ZEC"
        case etc = "ETC"
        case trx = "TRX"
        case bcc = "BCC"
        case neo = "NEO"
        case eos = "EOS"
        case creationDate
    }
}
