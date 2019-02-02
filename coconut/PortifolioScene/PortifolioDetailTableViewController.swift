//
//  PortifolioDetailTableViewController.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import CoreData

class PortifolioDetailTableViewController: UITableViewController {
    
    // Properties
    var backgroundViewContext : NSManagedObjectContext!
    var sharedViewContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Portifolio>!
    var portifolioListSelected: PortifolioList!
    var compareValue : Double?
    let client = Client()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        viewControllerConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func deletePortifolio(at indexPath: IndexPath) {
        let portifolioToDelete = fetchedResultsController.object(at: indexPath)
        backgroundViewContext.delete(portifolioToDelete)
        try? backgroundViewContext.save()
    }
    
    // MARK: - Data Source Methods
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! PortifolioTableViewHeaderCell
        headerCell.backgroundColor = UIColor.clear
        return headerCell
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PortifolioDetailTableViewCell else {fatalError()}
        let aPortifolio = fetchedResultsController.object(at: indexPath)
        
        cell.setCell = aPortifolio
        
        if let calc = calcPercent(coin: aPortifolio.coin!, amount: aPortifolio.amount, total: aPortifolio.total, currency: (aPortifolio.currency?.lowercased())!){
            cell.differenceLabel.text = String(calc[0].currencyFormatString)
            cell.percentLabel.text = String(calc[1].decimalFormatString) + "%"
            
            if calc[0] > 0 {
                cell.percentLabel.textColor = UIColor.green
                cell.percentImage.image = #imageLiteral(resourceName: "arrow_up")
            } else  if calc[1] < 0{
                cell.percentLabel.textColor = UIColor.red
                cell.percentImage.image = #imageLiteral(resourceName: "arrow_down")
            } else {
                cell.percentLabel.textColor = UIColor.black
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deletePortifolio(at: indexPath)
        default: () // Unsupported
        }
    }
    
    // MARK: - View Controller Configuration
    
    func viewControllerConfiguration(){
        navigationItem.title = portifolioListSelected.name
        tableView.rowHeight = 55
    }
    
    //MARK: - Fetched Results Controller
    
    func setupFetchedResultsController() {
        let request: NSFetchRequest<Portifolio> = Portifolio.fetchRequest()
        request.sortDescriptors = Portifolio.defaultSortDescriptors
        let predicate = NSPredicate(format: "portifolioList == %@", portifolioListSelected)
        request.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: backgroundViewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Fetch Request For Comparing Prices
    
    func fetchCurrentValue(entityName: String, property: String){
        let request = NSFetchRequest(entityName: entityName) as NSFetchRequest<NSManagedObject>
        do {
            let data = try sharedViewContext.fetch(request)
            for obj in data {
                if let value = obj.value(forKey: property) {
                    compareValue = value as? Double
                }
            }
        }catch{
            presentUIAlert("Error", "Couldn't Retrieve Data", nil)
        }
        return
    }
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToCreatePortifolio"{
            if let destination = segue.destination as? PortifolioCreateViewController{
                destination.portifolioListSelected = portifolioListSelected
                destination.backgroundViewContext = backgroundViewContext
                destination.sharedViewContext = sharedViewContext
            }
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension PortifolioDetailTableViewController: NSFetchedResultsControllerDelegate {
    
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

extension PortifolioDetailTableViewController {

    func calcPercent(coin: String, amount: Double, total: Double, currency: String) -> [Double]?{
        var difference = Double()
        var differencePercent = Double()
        fetchCurrentValue(entityName: coin, property: currency.lowercased())
        if let currentValues = compareValue {
            difference = (currentValues * amount) - total
            differencePercent = difference / (currentValues * amount) * 100
        }
        return [difference, differencePercent]
    }

    func presentUIAlert(_ title: String?, _ message: String?,_ handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
