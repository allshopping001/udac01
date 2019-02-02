//
//  APIRoot+CoreDataProperties.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//
//

import Foundation
import CoreData


extension APIRoot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APIRoot> {
        return NSFetchRequest<APIRoot>(entityName: "APIRoot")
    }

    @NSManaged public var toDisplay: APIDisplay?
    @NSManaged public var toRaw: APIRaw?

    enum CodingKeys : String, CodingKey {
        case toDisplay = "DISPLAY"
        case toRaw = "RAW"
    }
}
