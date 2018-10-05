//
//  ItemController.swift
//  PairRandomizer
//
//  Created by Jason Goodney on 10/5/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    // MARK: - Properties
    static let shared = ItemController(); private init() {}
    
    let fetchResultsController: NSFetchedResultsController<Item> = {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.context,
                                          sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    var groupedItems: [[Item]] = [[]]
    
    var mockItems: [Item] = []
    
    // MARK: - Add
    func add(item: Item) {
        mockItems.append(item)
        saveToPersistentStorage()
    }
    
    // MARK: - Remove
    func remove(item: Item) {
        item.managedObjectContext?.delete(item)
        saveToPersistentStorage()
    }
    
    // MARK: - Update
    func updateGroup(item: Item, group: Int) {
        item.group = Int64(group)
        saveToPersistentStorage()
    }
    
    // MARK: - Save
    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch let error {
            print("🎅🏻\nError saving to persistent storage \(#function): \(error)\n\n\(error.localizedDescription)\n🎄")
        }
    }
    
    // MARK: - Shuffle
    func shuffle(_ items: [Item]) -> [Item] {
        var tempItems = items
        var shuffledItems: [Item] = []
        
        for _ in 0..<tempItems.count {
            
            let randomIndex = Int(arc4random_uniform(UInt32(tempItems.count)))
            shuffledItems.append(tempItems[randomIndex])
            tempItems.remove(at: randomIndex)
            
        }
        saveToPersistentStorage()
        return shuffledItems
    }
    
    // MARK: - Group
    func group(_ items: [Item]) {
        let numberOfGroups = items.count / 2
        
        for i in 0..<numberOfGroups{
            
            for j in 0..<2 {
                let itemsIndex = i + j
                
                updateGroup(item: items[itemsIndex], group: i)
                
                groupedItems[i].append(items[itemsIndex])
                
            }
        }
    }
}
