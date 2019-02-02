//
//  LTC+CoreDataProperties.swift
//  coconut
//
//  Created by macos on 01/02/19.
//  Copyright © 2019 Notebook. All rights reserved.
//
//

import Foundation
import CoreData


extension LTC {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LTC> {
        return NSFetchRequest<LTC>(entityName: "LTC")
    }

    @NSManaged public var brl: Double
    @NSManaged public var eur: Double
    @NSManaged public var usd: Double
    @NSManaged public var cny: Double
    @NSManaged public var gbp: Double
    @NSManaged public var symbol: String?
    @NSManaged public var apiPrices: APIPrices?

}

extension LTC {
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case brl = "BRL"
        case eur = "EUR"
        case cny = "CNY"
        case gbp = "GBP"
    }
}
