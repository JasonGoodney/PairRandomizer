//
//  ViewController.swift
//  PairRandomizer
//
//  Created by Jason Goodney on 10/5/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit
import CoreData

class RandomizerViewController: UIViewController {
    
    // MARK: - Properties
private let cellId = String(describing: UITableViewCell.self)
    
    // MARK: - Subviews
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        ItemController.shared.fetchResultsController.delegate = self
        
        do {
            try ItemController.shared.fetchResultsController.performFetch()
        } catch {
            print("Error fetching core data items")
        }
        
//        createGroups()
        
        tableView.tableFooterView = UIView()
        
    }
    
    func createGroups() {
        guard let objects = ItemController.shared.fetchResultsController.fetchedObjects else { return }
        
        let shuffledItems = ItemController.shared.shuffle(objects)
        
        ItemController.shared.group(shuffledItems)
    }

    // MARK: - Actions
    @IBAction func addItemButtonPressed(_ sender: Any) {
        presentAlert(withTitle: "Add Person", message: "Add someone new to the litt") { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func randomizeButtonPressed(_ sender: Any) {
        createGroups()
    }
    
}

extension RandomizerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if ItemController.shared.groupedItems[0].count == 0 {
            return 1
        }
        
        return ItemController.shared.groupedItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ItemController.shared.groupedItems[0].count == 0 {
            return ItemController.shared.fetchResultsController.fetchedObjects?.count ?? 0
        }
        
        return ItemController.shared.groupedItems[section].count
        
//        return ItemController.shared.mockItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let item = ItemController.shared.fetchResultsController.object(at: indexPath)
//        let item = ItemController.shared.mockItems[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = ItemController.shared.fetchResultsController.sections?[section] else {
            return nil
        }
        let sectionNumber = Int(sectionInfo.name) ?? 0
        return "Group \(sectionNumber + 1)"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = ItemController.shared.fetchResultsController.fetchedObjects?[indexPath.row] else { return }
            
            ItemController.shared.remove(item: item)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension RandomizerViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }


}
