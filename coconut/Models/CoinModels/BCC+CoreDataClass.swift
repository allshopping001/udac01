//
//  BCC+CoreDataClass.swift
//  coconut
//
//  Created by macos on 02/02/19.
//  Copyright © 2019 Notebook. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BCC)
public class BCC: NSManagedObject, Decodable{
    required convenience public init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.managedObjectContext, let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "BCC", in: managedObjectContext) else {
            fatalError()
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        usd = try values.decode(Double.self, forKey: .usd)
        brl = try values.decode(Double.self, forKey: .brl)
        eur = try values.decode(Double.self, forKey: .eur)
        gbp = try values.decode(Double.self, forKey: .gbp)
        cny = try values.decode(Double.self, forKey: .cny)
    }
}
