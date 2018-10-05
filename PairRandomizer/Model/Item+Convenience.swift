//
//  Item+Convenience.swift
//  PairRandomizer
//
//  Created by Jason Goodney on 10/5/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

import CoreData

extension Item {
    
    convenience init(name: String, group: Int = 0, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.group = Int64(group)
    }
}
