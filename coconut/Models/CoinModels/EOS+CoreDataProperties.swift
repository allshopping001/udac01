//
//  EOS+CoreDataProperties.swift
//  coconut
//
//  Created by macos on 02/02/19.
//  Copyright © 2019 Notebook. All rights reserved.
//
//

import Foundation
import CoreData


extension EOS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EOS> {
        return NSFetchRequest<EOS>(entityName: "EOS")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var usd: Double
    @NSManaged public var brl: Double
    @NSManaged public var gbp: Double
    @NSManaged public var eur: Double
    @NSManaged public var cny: Double
    @NSManaged public var apiPrices: APIPrices?
}

extension EOS {
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case brl = "BRL"
        case eur = "EUR"
        case cny = "CNY"
        case gbp = "GBP"
    }
}
