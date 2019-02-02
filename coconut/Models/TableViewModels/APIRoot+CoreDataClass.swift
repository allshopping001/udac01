//
//  APIRoot+CoreDataClass.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//
//

import Foundation
import CoreData

@objc(APIRoot)
public class APIRoot: NSManagedObject, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.managedObjectContext, let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "APIRoot", in: managedObjectContext) else {
            fatalError()
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        toRaw = try values.decode(APIRaw.self, forKey: .toRaw)
        toDisplay = try values.decode(APIDisplay.self, forKey: .toDisplay)
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
