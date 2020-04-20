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

class GraphViewController: UIViewController {
  // segment for day/week/month
  @IBOutlet weak var segment: UISegmentedControl!
  
  // debug label for switch
  //TODO: Remove
  @IBOutlet weak var textDebug: UILabel!
  
  // Preliminary graph
  @IBOutlet weak var txtBox: UITextField!
  @IBOutlet weak var chartView: LineChartView!
  
  // This is where we are going to store all the numbers.
  // Great name too
  var numbers : [Double] = []
  // samples from Stress Detector in BTSample.sample
  
  override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  }
    

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
  
  //MARK: Update Graph
  
  // Function that updates graph
  func updateGraph(){
    //this is the Array that will eventually be displayed on the graph.
    var lineChartEntry  = [ChartDataEntry]()

    // HeartRate graph
    // TODO: Need to add filtering for date
    for i in 0..<BTSample.samples.count {
      // here we set the X and Y status in a data chart entry
      let value = ChartDataEntry(x: Double(i), y: Double(BTSample.samples[i].heartrate))
      lineChartEntry.append(value) // here we add it to the data set
    }

    //Here we convert lineChartEntry to a LineChartDataSet
    let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
    line1.colors = [NSUIColor.blue] //Sets the colour to blue

    let data = LineChartData() //This is the object that will be added to the chart
    data.addDataSet(line1) //Adds the line to the dataSet
      

    chartView.data = data //finally - it adds the chart data to the chart and causes an update
    chartView.chartDescription?.text = "Heartrate Chart" // Here we set the description for the graph
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


