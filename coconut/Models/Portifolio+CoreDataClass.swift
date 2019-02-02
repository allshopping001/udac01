//
//  Portifolio+CoreDataClass.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Portifolio)
public class Portifolio: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
}

extension Portifolio {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "creationDate", ascending: true)]
    }
    
    static var sortedFetchRequest: NSFetchRequest<Portifolio> {
        let request: NSFetchRequest<Portifolio> = Portifolio.fetchRequest()
        request.sortDescriptors = Portifolio.defaultSortDescriptors
        return request
    }
}
