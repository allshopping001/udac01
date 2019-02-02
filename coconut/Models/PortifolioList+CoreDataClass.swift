//
//  PortifolioList+CoreDataClass.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PortifolioList)
public class PortifolioList: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
}

extension PortifolioList {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "creationDate", ascending: true)]
    }
    
    static var sortedFetchRequest: NSFetchRequest<PortifolioList> {
        let request: NSFetchRequest<PortifolioList> = PortifolioList.fetchRequest()
        request.sortDescriptors = PortifolioList.defaultSortDescriptors
        return request
    }
}
