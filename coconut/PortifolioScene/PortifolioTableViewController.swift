//
//  PortifolioTableViewController.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import CoreData

class PortifolioTableViewController: UITableViewController {
    
    // Properties
    var fetchedResultsController : NSFetchedResultsController<PortifolioList>!
    var backgroundViewContext: NSManagedObjectContext!
    var sharedViewContext: NSManagedObjectContext!
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        viewControllerConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    @IBAction func addTapped(_ sender: Any) {
        presentNewPortifolioAlert()
    }
    
    //MARK: - Present Alert Controller
    
    fileprivate func presentNewPortifolioAlert() {
        let alert = UIAlertController(title: "New Portifolio", message: "Enter a name for this portifolio", preferredStyle: .alert)
        
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addPortifolioList(name: name)
            }
        }
        saveAction.isEnabled = false
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    //add Portifolio
    func addPortifolioList(name: String) {
        let portifolioList = PortifolioList(context: backgroundViewContext)
        portifolioList.name = name
        portifolioList.creationDate = Date()
        try? backgroundViewContext.save()
    }
    
    //delete Portifolio
    func deletePortifolioList(at indexPath: IndexPath) {
        let portifolioListToDelete = fetchedResultsController.object(at: indexPath)
        backgroundViewContext.delete(portifolioListToDelete)
        try? backgroundViewContext.save()
    }
    
    // MARK: - Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aPortifolio = fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PortifolioTableViewCell else {fatalError()}
        
        cell.nameLabel.text = aPortifolio.name
        if let creationDate = aPortifolio.creationDate {
            cell.dateLabel.text = creationDate.fullDate
        }
        if let count = aPortifolio.portifolio?.count {
            let pageString = count > 1 ? "items" : "item"
            cell.pageCountLabel.text = "\(count) \(pageString)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deletePortifolioList(at: indexPath)
        default: () // Unsupported
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // MARK: - View Controller Configuration
    
    func viewControllerConfiguration(){
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: - Fetched Results Controller
    
     func setupFetchedResultsController() {
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: PortifolioList.sortedFetchRequest, managedObjectContext: backgroundViewContext, sectionNameKeyPath: nil, cacheName: "PortifolioList")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToPortifolioDetail"{
            if let destination = segue.destination as? PortifolioDetailTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destination.portifolioListSelected = fetchedResultsController.object(at: indexPath)
                    destination.backgroundViewContext = backgroundViewContext
                    destination.sharedViewContext = sharedViewContext
                }
            }
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension PortifolioTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

