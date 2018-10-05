//
//  CoreDataStack.swift
//  PairRandomizer
//
//  Created by Jason Goodney on 10/5/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    static var context: NSManagedObjectContext{ return container.viewContext }
}
