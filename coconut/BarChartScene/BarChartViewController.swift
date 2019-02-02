//
//  DetailViewController.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var segmentControlView: SegmentControlView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelIcon: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    
    
    // Properties
    var activityIndicator = UIActivityIndicatorView()
    var items = [[ModelGraph]]()
    var fromSymbol : String?
    var toSymbol : String?
    var dateSelected: String?
    var queryDate: String?
    var limit: Int?
    
    var optionSelected = String()
    let queryBuilder = QueryBuilder()
    let client = Client()
    let formatter = NumberFormatter()
    let formatters = Formatters()
    var inputTextTag = Int()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerConfiguration()
        activityIndicatorConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllerConfiguration()
    }
    
    //MARK: - View Controller Configuration
    
    func barViewConfiguration() {
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.legend.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = true
        barChartView.xAxis.labelPosition = .bottom
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelRotationAngle = 35
        barChartView.rightAxis.valueFormatter = YAxisValueFormatter()
        barChartView.xAxis.granularity = 0
        barChartView.extraBottomOffset = 5
        barChartView.xAxis.labelFont = UIFont(name: "Helvetica Neue", size: 8)!
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
    
    func viewControllerConfiguration(){
        view.backgroundColor = .clear
        titleView.layer.maskedCorners =  [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.layer.cornerRadius = 10
        titleView.layer.borderWidth = 0.5
        segmentControlView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        segmentControlView.layer.cornerRadius = 10
        let coinString = ConvertSymbol(symbolString: fromSymbol!)
        label.text = coinString.name
        labelIcon.image = coinString.image
        
        //Blur Effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
    }
    
    // MARK: - API Call
    
    func buildQuery(){
        items.removeAll()
        let query = queryBuilder.buildQueryGraph(idBase: fromSymbol!, idQuote: toSymbol!, queryDate: queryDate!, limit: limit!)
        loadView(query)
    }
    
    func loadView(_ query:String) {
        client.taskForGetMethodGraph(query) { (result, response, error) in
            guard (error == nil) else {
                self.presentUIAlert("Error", error?.localizedDescription, nil)
                return
            }
            if let statusCode = response, statusCode <= 200 || statusCode >= 299  {
                self.presentUIAlert("Error: Data Not Available", "Status_Code:" + statusCode.description, nil)
            }
            if let result = result {
                self.items.append(result as! [ModelGraph])
                DispatchQueue.main.async {
                    self.barViewConfiguration()
                    self.loadChartWithData()
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Load BarChartView
    
    func loadChartWithData(){
        var dataEntries : [BarChartDataEntry] = []
        var months: [String] = []
        barChartView.xAxis.labelCount = limit!
        for i in (0..<items.first!.count).reversed(){
            let dataEntry =  BarChartDataEntry(x: Double(i), y: items[0][i].priceClose)
            dataEntries.append(dataEntry)
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "" )
            let chartData =  BarChartData(dataSet: chartDataSet)
            let format = DefaultValueFormatter(formatter: formatters.setChartFormatter(option: optionSelected))
            chartData.setValueFormatter(format)
            months.append(items[0][i].periodStart.completeDate)
            barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
            barChartView.data = chartData
            if items.first!.count > 10 {
                barChartView.barData?.setDrawValues(false)
                barChartView.xAxis.labelRotationAngle = 90
            }
        }
        items.removeAll()
    }
    
    // MARK: - SegmentControl Period Selection
    
    @IBAction func segmentControlSetValue(_ sender: SegmentControlView) {
        switch sender.selectedSegmentIndex {
        case 0: queryDate = "1DAY"; limit = 30
        case 1: queryDate = "10DAY"; limit = 9
        case 2: queryDate = "1MTH"; limit = 6
        case 3: queryDate = "1MTH"; limit = 12
        default: queryDate = "1MTH"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.activityIndicator.startAnimating()
            self.buildQuery()
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Alerts

extension BarChartViewController {
    //Present UIAlert
    func presentUIAlert(_ title: String?, _ message: String?,_ handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    //Create Activity Indicator
    func activityIndicatorConfiguration(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
}










