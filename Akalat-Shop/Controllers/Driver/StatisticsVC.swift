//
//  StatisticsVC.swift
//  Akalat Driver
//
//  Created by Macbook on 09/07/2021.
//

import UIKit
import Charts

class StatisticsVC: UIViewController , ChartViewDelegate, IAxisValueFormatter{


    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var viewChart: BarChartView!
    
    var weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var dayValues = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewChart.delegate = self
        viewChart.xAxis.valueFormatter = self
        configureMenu()
        initializeChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataToChart()
    }
    
    //Delegate For Naming X Axis
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return weekdays[Int(value)]
    }
    
    func configureMenu() {
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    func initializeChart() {

        viewChart.noDataText = "No Data To Be Shown By Charts Yet"
        viewChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        viewChart.xAxis.labelPosition = .bottom
        viewChart.xAxis.setLabelCount(7, force: false)

        viewChart.legend.enabled = false
        viewChart.scaleYEnabled = false
        viewChart.scaleXEnabled = false
        viewChart.pinchZoomEnabled = false
        viewChart.doubleTapToZoomEnabled = false

        viewChart.leftAxis.axisMinimum = 0.0
        viewChart.leftAxis.axisMaximum = 200.00
        viewChart.highlighter = nil
        viewChart.rightAxis.enabled = false
        viewChart.xAxis.drawGridLinesEnabled = false

    }
    func loadDataToChart() {
        NetworkManager.DriverRevenue { (data, error) in
            if error == nil {
                
                //Save Values In Array
                let day1 = data?.Mon
                self.dayValues.append(day1!)
                let day2 = data?.Tue
                self.dayValues.append(day2!)
                let day3 = data?.Wed
                self.dayValues.append(day3!)
                let day4 = data?.Thu
                self.dayValues.append(day4!)
                let day5 = data?.Fri
                self.dayValues.append(day5!)
                let day6 = data?.Sat
                self.dayValues.append(day6!)
                let day7 = data?.Sun
                self.dayValues.append(day7!)
 
              
                print(self.dayValues)

                var dataEntries: [BarChartDataEntry] = []
 
                for i in 0..<self.weekdays.count {
                    
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(self.dayValues[i]))
                    
                    dataEntries.append(dataEntry)
                }
                
                let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Revenue By Day")
                chartDataSet.colors = ChartColorTemplates.material()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.viewChart.data = chartData
                
            } else {
                print(error!.rawValue)
            }
        }
    }
    

}
