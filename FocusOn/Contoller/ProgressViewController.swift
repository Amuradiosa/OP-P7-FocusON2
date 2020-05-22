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
  private let formatter = DateFormatter()
  
  @IBOutlet weak var currentDate: UILabel!
  
  @IBOutlet weak var timeSegment: UISegmentedControl!
  
  @IBAction func timeSegmentValueChanged(_ sender: Any) {
    configure()
  }
  
  @IBOutlet weak var chartView: BarChartView!
  
  var completedGoals = [Double]()
  var totalGoals = [Double]()
  let months = ["Jan", "Feb", "Mar", "Apr", "May","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
  let weeks = ["Week 1","Week 2","Week 3","Week 4","Week 5"]
  
  func configure() {
    chartView.delegate = self as? ChartViewDelegate
    chartView.isUserInteractionEnabled = false
    chartView.drawBarShadowEnabled = false
    chartView.drawValueAboveBarEnabled = false
    chartView.rightAxis.enabled = false
    
    if timeSegment.selectedSegmentIndex == 0 {
      let xAxis = chartView.xAxis
      xAxis.drawGridLinesEnabled = false
      xAxis.labelPosition = .bottom
      xAxis.centerAxisLabelsEnabled = true
      xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
      xAxis.granularity = 1
      xAxis.labelCount = 12
      xAxis.centerAxisLabelsEnabled = false
      
      
      let leftAxisFormatter = NumberFormatter()
      leftAxisFormatter.maximumFractionDigits = 1
      
      let yaxis = chartView.leftAxis
      yaxis.spaceTop = 0.35
      yaxis.axisMinimum = 0
      yaxis.drawGridLinesEnabled = false
      setChartForMonths()
      
    } else {
      let xAxis = chartView.xAxis
      xAxis.drawGridLinesEnabled = false
      xAxis.labelPosition = .bottom
      xAxis.centerAxisLabelsEnabled = true
      xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
      xAxis.granularity = 1
      xAxis.labelCount = 4
      
      let leftAxisFormatter = NumberFormatter()
      leftAxisFormatter.maximumFractionDigits = 1
      
      let yaxis = chartView.leftAxis
      yaxis.spaceTop = 0.35
      yaxis.axisMinimum = 0
      yaxis.drawGridLinesEnabled = false
      setChartForWeeks()
    }
  }
  
  func setChartForMonths() {
    var dataEntries1 = [BarChartDataEntry]()
    var dataEntries2 = [BarChartDataEntry]()
    let xValuesForTotalGoals = [0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5]
    if data.allGoalsObjects(achieved: true) != nil || data.allGoalsObjects(achieved: false) != nil {
      totalGoals = data.monthly(goals: data.allGoalsObjects(achieved: false)!)
      completedGoals = data.monthly(goals: data.allGoalsObjects(achieved: true)!)
      for i in 0..<months.count {
        dataEntries1.append(BarChartDataEntry(x: xValuesForTotalGoals[i] - 0.3, y: totalGoals[i]))
        dataEntries2.append(BarChartDataEntry(x: Double(i) - 0.3, y: completedGoals[i]))
      }
    }
    let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Total Number Of Goals")
    let chartDataSet2 = BarChartDataSet(entries: dataEntries2, label: "Completed Goals")
    chartDataSet1.colors = [UIColor.black]
    chartDataSet1.valueTextColor = UIColor.white
    chartDataSet2.colors = [UIColor.gray]
    chartDataSet2.valueTextColor = UIColor.white
    let chartData = BarChartData(dataSets: [chartDataSet1, chartDataSet2])
    let barWidth = 0.5
    chartData.barWidth = barWidth
    chartView.notifyDataSetChanged()
    chartView.data = chartData
    chartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
  }
  
  func setChartForWeeks() {
    var dataEntries1 = [BarChartDataEntry]()
    var dataEntries2 = [BarChartDataEntry]()
    let xValuesForTotalGoals = [0.5,1.5,2.5,3.5,4.5]
    if data.allGoalsObjects(achieved: true) != nil || data.allGoalsObjects(achieved: false) != nil {
      totalGoals = data.weekly(goals: data.allGoalsObjects(achieved: false)!)
      completedGoals = data.weekly(goals: data.allGoalsObjects(achieved: true)!)
      for i in 0..<weeks.count {
        dataEntries1.append(BarChartDataEntry(x: xValuesForTotalGoals[i] + 0.3, y: totalGoals[i]))
        dataEntries2.append(BarChartDataEntry(x: Double(i) + 0.3, y: completedGoals[i]))
      }
    }
    let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Total Number Of Goals")
    let chartDataSet2 = BarChartDataSet(entries: dataEntries2, label: "Completed Goals")
    chartDataSet1.colors = [UIColor.black]
    chartDataSet1.valueTextColor = UIColor.white
    chartDataSet2.colors = [UIColor.gray]
    chartDataSet2.valueTextColor = UIColor.white
    let chartData = BarChartData(dataSets: [chartDataSet1, chartDataSet2])
    let barWidth = 0.5
    chartData.barWidth = barWidth
    chartView.notifyDataSetChanged()
    chartView.data = chartData
    chartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
  }
  
  func configureDate() {
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    currentDate.text = formatter.string(from: Date())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureDate()
//    print(data.monthly(goals: data.allGoalsObjects(achieved: true)!))
//    print(data.monthly(goals: data.allGoalsObjects(achieved: false)!))
//    print(data.weekly(goals: data.allGoalsObjects(achieved: true)!))
//    print(data.weekly(goals: data.allGoalsObjects(achieved: false)!))
  }
}
