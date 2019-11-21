//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by Ahmad Murad on 13/10/2019.
//  Copyright © 2019 Ahmad Murad. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ProgressViewController: UIViewController {
    
    let data = DataController()
    
    @IBOutlet weak var timeSegment: UISegmentedControl!
    
    
    @IBAction func timeSegmentValueChanged(_ sender: Any) {
//        setData(data.monthlyAchivedGoals(), range: UInt32(data.totalGoals()))
    }
    @IBOutlet weak var chartView: BarChartView!
    
    
    
    
    
    
    
    
    
    
//        didSet {
//            configure()
//            let monthlyAchievedGoals = data.totalNumberOfAchievedGoals()
//            let totalGoals = data.totalGoals()
//
//
//            chartView.data = {
//                let dataSet1 = BarChartDataSet(
//                    entries:
//                          monthlyAchievedGoals
//                          .enumerated()
//                          .map{
//                            (arg) -> BarChartDataEntry in let (dayIndex, total) = arg; return BarChartDataEntry(
//                                x: Double(total + 1),
//                              y: Double(total)
//                            )
//                          },
//                        label: nil
//                      )
//                        let dataSet2 = BarChartDataSet(
//                        entries:
//                              monthlyAchievedGoals
//                              .enumerated()
//                              .map{
//                                (arg) -> BarChartDataEntry in let (dayIndex, total) = arg; return BarChartDataEntry(
//                                  x: Double(total),
//                                  y: Double(totalGoals)
//                                )
//                              },
//                            label: nil
//                          )
//                        dataSet2.colors = [.blue]
//                      let data = BarChartData(dataSets: [dataSet1,dataSet2])
//                      return data
//                    }()
//
//      }
//    }
//
//                monthlyAchievedGoals.enumerated().map {(arg) -> ChartData([Double:Double]) in
//
//
//
//
//
//                    let (indexMonth, monthly) = arg
//                    return BarChartDataEntry(
//                    x: Double(indexMonth),
//                    y: monthly
//                    )
//
//                }
//
//
//                }
//            }
    
    var labels = [String]()
    var completedGoals = [Double]()
    var totalGoals = [Double]()
    var goalDataSet: BarChartData!
    
    
    func configure() {
        
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false
        chartView.isUserInteractionEnabled = false
        for axis in [XAxis(), YAxis()] {
            axis.drawAxisLineEnabled = false
            axis.drawGridLinesEnabled = false
        }
        chartView.rightAxis.enabled = false
        
        chartView.delegate = self as? ChartViewDelegate
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.barData?.barWidth = 0.2
        
        
    }
    func setData(_ count: Int, range: UInt32) {
        let start = 1
        
        let yVals = (start..<data.totalGoals()).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1.replaceEntries(yVals)
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "The year 2019")
            set1.colors = ChartColorTemplates.material()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.9
            chartView.data = data
        }
        
        
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
//        setData(data.monthlyAchivedGoals, range: UInt32(data.totalGoals()))
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
