/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Charts

class GraphViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
  // segment for day/week/month
  @IBOutlet weak var segment: UISegmentedControl!
  
  // Picker for data on graph
  @IBOutlet weak var displayDataText: UITextField!
  var selectedDataType = "Stress"
  var displayDataTypes = ["Stress", "Heartrate", "GSR"]
  
  // Graph
  @IBOutlet weak var chartView: LineChartView!
  @IBOutlet weak var graphLabel: UILabel!
  
  // This is where we are going to store all the numbers.
  // Great name too
  var numbers : [Double] = []
  // samples from Stress Detector in BTSample.sample
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Picker Stuff
    createPickerView()
    dismissPickerView()
    selectedDataType = displayDataTypes[0]
    displayDataText.text = selectedDataType
    updateGraph()
    graphLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    
  }
    
  //MARK: UI: Tab and Picker
  
  @IBAction func indexChanged(_ sender: Any) {
    switch segment.selectedSegmentIndex
    {
    case 0:
      // Filter for day
      #if DEBUG
      print("Graph: Day")
      #endif
    case 1:
      // filter for week
      #if DEBUG
      print("Graph: Week")
      #endif
    case 2:
      // filter for month
      #if DEBUG
      print("Graph: Month")
      #endif
    default:
      //
      print("Graph switch statement out of bounds")
    }
    updateGraph()
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return displayDataTypes.count // number of dropdown items
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return displayDataTypes[row] // dropdown item
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      selectedDataType = displayDataTypes[row] // selected item
      displayDataText.text = selectedDataType
      updateGraph()
  }
  
  func createPickerView() {
      let pickerView = UIPickerView()
      pickerView.delegate = self
      displayDataText.inputView = pickerView
  }
  
  func dismissPickerView() {
      let toolBar = UIToolbar()
      toolBar.sizeToFit()
      
      let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
      toolBar.setItems([button], animated: true)
      toolBar.isUserInteractionEnabled = true
      displayDataText.inputAccessoryView = toolBar
  }
  @objc func action() {
      view.endEditing(true)
  }
  
  
  //MARK: Update Graph
  
  // Function that updates graph
  func updateGraph(){
    //  This array will be displayed on the graph.
    let lineChartEntry = createLineChart()
    
    //Here we convert lineChartEntry to a LineChartDataSet
    let line1 = LineChartDataSet(values: lineChartEntry, label: "") //label: selectedDataType + " Data")
    makeLineLookPretty(line1)
    
    // Make data set from line
    let data = LineChartData() //This is the object that will be added to the chart
    data.addDataSet(line1) //Adds the line to the dataSet
      
    // Update the chart
    updateChart(data)
    
  }
  
  // Creates the line from the data set specified in the picker
  func createLineChart() -> [ChartDataEntry] {
    var lineChartEntry  = [ChartDataEntry]()

    // HeartRate graph
    // TODO: Need to add filtering for date
    for i in 0..<BTSample.samples.count {
      // Here we set the X and Y status in a data chart entry
      // Get correct data
      var data: Double
      switch selectedDataType
      {
      case "Stress":
        guard let temp = BTSample.samples[i].stressed else { continue }
        data = temp
      case "Heartrate":
        data = BTSample.samples[i].heartrate
      case "GSR":
        data = BTSample.samples[i].gsr!
      default:
        data = BTSample.samples[i].heartrate
      }
      let plotPoint = ChartDataEntry(x: Double(i), y: data)
      lineChartEntry.append(plotPoint) // here we add it to the data set
    }

    // If no entries
    if lineChartEntry.count == 0 {
      print("No entries")
    }
    
    return lineChartEntry
  }
  
  func makeLineLookPretty(_ line : LineChartDataSet) {
    // Make the chart look pretty
    line.colors = [NSUIColor.blue] //Sets the colour to blue
    line.circleRadius = 0.5
    
    line.axisDependency = .right

  }
  
  func updateChart(_ data : LineChartData) {
    // Update data
    chartView.data = data  // adds the chart data to the chart, updates
    
    // Description
    chartView.chartDescription?.text = ""
    chartView.scaleYEnabled = false;
    
    // Move xaxis, legend
    chartView.xAxis.labelPosition = .bottom
    chartView.legend.enabled = false
    
    // Get rid of right axis
    chartView.leftAxis.enabled = false
    chartView.leftAxis.drawAxisLineEnabled = false
    
    // Reset axies
    chartView.fitScreen()
    
    // Set the data specific stuff
    switch selectedDataType {
    case "Stress":
      graphLabel.text = "Stress level"
      chartView.rightAxis.axisMinimum = 0
      chartView.rightAxis.axisMaximum = 1.1
    case "Heartrate":
      graphLabel.text = "BPM"
      chartView.rightAxis.axisMinimum = 0
      chartView.rightAxis.axisMaximum = min(data.getYMax(), 250)
    case "GSR":
      graphLabel.text = "Skin Conductance"
      chartView.rightAxis.axisMinimum = 0
      chartView.rightAxis.axisMaximum = data.getYMax()
    default:
      graphLabel.text = ""
    }
    
  }
  
}


