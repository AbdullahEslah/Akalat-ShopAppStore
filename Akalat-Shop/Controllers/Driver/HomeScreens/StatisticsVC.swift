//
//  StatisticsVC.swift
//  Akalat Driver
//
//  Created by Macbook on 09/07/2021.
//

import UIKit
import Charts

class StatisticsVC: UIViewController , ChartViewDelegate, IAxisValueFormatter, SWRevealViewControllerDelegate{


    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var viewChart: BarChartView!
    
    var weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var dayValues = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewChart.delegate = self
        viewChart.xAxis.valueFormatter = self
        initializeChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMenu()
        loadDataToChart()
    }
    
    //Delegate For Naming X Axis
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return weekdays[Int(value)]
    }
    
    func configureMenu() {
        if AppLocalization.currentAppleLanguage() == "ar" {
            if self.revealViewController() != nil {
                let storyboard = UIStoryboard(name: "DriverMain", bundle: nil)
                let sidemenuViewController = storyboard.instantiateViewController(withIdentifier: "DriverMenuVC") as! DriverMenuVC
                revealViewController().rightViewController = sidemenuViewController
                revealViewController().delegate = self
                self.revealViewController().rightViewRevealWidth = self.view.frame.width * 0.8
                menuBarButton.target = self.revealViewController()
                menuBarButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            }
        } else {
            if self.revealViewController() != nil {
                menuBarButton.target = self.revealViewController()
                menuBarButton.action = #selector(revealViewController().revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
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
        viewChart.leftAxis.axisMaximum = 5000.00
        viewChart.highlighter = nil
        viewChart.rightAxis.enabled = false
        viewChart.xAxis.drawGridLinesEnabled = false

    }
    func loadDataToChart() {
        NetworkManager.DriverRevenue { (data, error) in
            if error == nil {
//                let allDays = DispatchQueue.global(qos: .userInitiated)
//                allDays.async {
                
                
                    //Save Values In Array
                    if let day1 = data?.Mon {
                        self.dayValues.append(day1)
                    }
                    if let day2 = data?.Tue {
                    self.dayValues.append(day2)
                    }
                    if let day3 = data?.Wed {
                    self.dayValues.append(day3)
                    }
                    if let day4 = data?.Thu {
                    self.dayValues.append(day4)
                    }
                    if let day5 = data?.Fri {
                    self.dayValues.append(day5)
                    }
                    if  let day6 = data?.Sat {
                    self.dayValues.append(day6)
                    }
                    if let day7 = data?.Sun {
                    self.dayValues.append(day7)
                    }
//                }

//                    DispatchQueue.main.async {
                var dataEntries: [BarChartDataEntry] = []
 
                for i in 0..<self.weekdays.count {
                    
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(self.dayValues[i]))
                    
                    dataEntries.append(dataEntry)
                }
                
                let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Revenue By Day")
                chartDataSet.colors = ChartColorTemplates.material()
                let chartData = BarChartData(dataSet: chartDataSet)
                self.viewChart.data = chartData
                
//                }
            } else {
//                DispatchQueue.main.async {
                    
                
                print(error!.rawValue)
//                }
            }
        }
    }
    

}
