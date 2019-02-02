//
//  TableViewController.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//
//

import UIKit
import CoreData

class TableViewController: UITableViewController , optionViewDelegate {
    
    //Outlets
    @IBOutlet weak var navigationButton: UIBarButtonItem!
    
    //Properties
    var activityIndicator = UIActivityIndicatorView()
    var indexPaths : Set<IndexPath> = []
    
    var optionSelected : String?
    var fetchedResultsController : NSFetchedResultsController<APIDisplay>!
    let transitionController2 = TransitionController_2()
    let transitionController = TransitionController()
    let reversedController = ReverseTransitionController()
    let client = Client()
    let queryBuilder =  QueryBuilder()
    var sharedViewContext : NSManagedObjectContext!
    
    // Mark: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerConfiguration()
        buildQuery(optionSelected!)
        setupFetchedResultsController()
        activityIndicatorConfiguration()
    }
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            for object in (self.fetchedResultsController?.fetchedObjects)! {
                self.sharedViewContext.delete(object)
            }
            self.buildQuery(self.optionSelected!)
            self.tableView.reloadSections(IndexSet(0..<1), with: .automatic)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    // MARK: - Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TableViewHeaderCell
        
        headerCell.backgroundColor = UIColor.clear
        if let optionSelected = optionSelected {
            let selected = ConvertOption(optionSelected)
            headerCell.iconLabel.image = selected.image
        }
        return headerCell.contentView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableViewCell else {fatalError()}
        
        cell.setCollapsedLabel = aCell
        cell.setExpandedLabel = aCell
        cell.loadDetailButton.tag = indexPath.row
        
        if let displayPercent = aCell.changePCT24h  {
            if let percent  = Double(displayPercent) {
                var percentColor = UIColor()
                var percentImage = UIImage()
                if percent > 0 {
                    percentColor = UIColor.green
                    percentImage = #imageLiteral(resourceName: "arrow_up")
                } else  if percent < 0{
                    percentColor = UIColor.red
                    percentImage = #imageLiteral(resourceName: "arrow_down")
                } else {
                    percentColor = UIColor.black
                }
                cell.imagePercentView.image = percentImage
                cell.collapsedLabelPercent.textColor = percentColor
            }
        }
        if indexPaths.contains(indexPath){
            cell.isExpanded = true
        } else {
            cell.isExpanded = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TableViewCell
        cell?.isExpanded.toggle()
        if cell?.isExpanded == true {
            indexPaths.insert(indexPath)
        } else {
            indexPaths.remove(indexPath)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TableViewCell
        cell?.isExpanded = false
        indexPaths.remove(indexPath)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - View Controller Configuration
    
    func viewControllerConfiguration(){
        self.title = "Rates"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .singleLine
        optionSelected = UserDefaults.standard.string(forKey: "optionSelected")
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }
    
    // Set OptionView
    func setOption(with string: String) {
        optionSelected = string
        DispatchQueue.main.async {
            for object in (self.fetchedResultsController?.fetchedObjects)! {
                self.sharedViewContext.delete(object)
            }
            self.buildQuery(self.optionSelected!)
            self.tableView.reloadSections(IndexSet(0..<1), with: .automatic)
        }

    }
    
    // MARK: - API Call
    
    func buildQuery(_ query: String){
        let query = queryBuilder.buildQueryExchange(query)
        var finalquery = [String]()
        for i in 0..<self.queryBuilder.coinQuery.count {
            finalquery.append(query[i])
        }
        for i in 0..<self.queryBuilder.coinQuery.count {
            loadViews(finalquery[i])
        }
    }
    
    func loadViews(_ query: String) {
        client.taskForGetMethod(query) { (data, response, error) in
            guard (error == nil) else {
                self.presentUIAlert("Error", error?.localizedDescription, nil)
                return
            }
            if let statusCode = response, statusCode <= 200 || statusCode >= 299  {
                self.presentUIAlert("Error", error?.localizedDescription, nil)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            self.activityIndicator.stopAnimating()
        }
    }
    
    //MARK: - Fetch Results Controller
    
     func setupFetchedResultsController() {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: APIDisplay.sortedFetchRequest, managedObjectContext: sharedViewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDetail"{
            if let destination = segue.destination as? BarChartViewController {
                let sender = sender as! UIButton
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let selectedItem = fetchedResultsController.object(at: indexPath)
                let fromSymbol = ConvertSymbol(symbolString: selectedItem.fromSymbol!)
                let toSymbol = ConvertCurrency(currencyString: selectedItem.toSymbol!)
                destination.fromSymbol = fromSymbol.tickerSymbol
                destination.toSymbol = toSymbol.name
                if let optionSelected = optionSelected{
                    destination.optionSelected = optionSelected
                } else {
                    destination.optionSelected = "en_US"
                }
            }
        }
        
        if segue.identifier == "SegueToOption"{
            if let destination = segue.destination as? OptionsViewController {
                destination.delegate = self
                destination.transitioningDelegate = self
            }
        }
    }
}

//MARK: - TableViewControllerTransitionDelegate

extension TableViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            let storyboard = UIStoryboard(name: "OptionsViewController", bundle: nil)
            let optionVC = storyboard.instantiateInitialViewController()
            var transition : UIViewControllerAnimatedTransitioning?
            if presented.restorationIdentifier == optionVC?.restorationIdentifier{
                transition = transitionController
            } else {
                transition = transitionController2
            }
            return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard let _ = dismissed as? OptionsViewController else {
                return nil
            }
            return reversedController
    }
}

// MARK: - FetchedResultsControllerDelegate

extension TableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .none)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .none)
        case .delete: tableView.deleteSections(indexSet, with: .none)
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

//MARK: - Alerts

private extension TableViewController {
    func presentUIAlert(_ title: String?, _ message: String?,_ handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Create Activity Indicator
    func activityIndicatorConfiguration(){
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}






