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

class ActivitiesViewController: UIViewController {

  @IBOutlet weak var BreatheButton: UIButton!
  @IBOutlet weak var BreatheButton2: UIButton!
  @IBOutlet weak var BreatheButton3: UIButton!
  @IBOutlet weak var BreatheButton4: UIButton!
  @IBOutlet weak var BreatheWatchButton: UIButton!
  
  @IBAction func BreathingExercise(_ sender: UIButton) {
    UIApplication.shared.open(NSURL(string:"https://www.verywellmind.com/how-to-reduce-stress-with-breathing-exercises-3144508")! as URL)
  }
  
  @IBAction func StressRed(_ sender: UIButton) {
    UIApplication.shared.open(NSURL(string:"https://www.youtube.com/watch?v=SEfs5TJZ6Nk")! as URL)
  }
  
  @IBAction func Yoga(_ sender: UIButton) {
    UIApplication.shared.open(NSURL(string:"https://www.yogajournal.com/practice/yoga-for-inner-peace-stress-relief-daily-practice-challenge")! as URL)
  }
  
  @IBAction func Music(_ sender: UIButton) {
    UIApplication.shared.open(NSURL(string:"https://www.youtube.com/watch?v=lFcSrYw-ARY")! as URL)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    BreatheButton.layer.cornerRadius = 6
    BreatheButton2.layer.cornerRadius = 6
    BreatheButton3.layer.cornerRadius = 6
    BreatheButton4.layer.cornerRadius = 6
    BreatheWatchButton.layer.cornerRadius = 6
    // Do any additional setup after loading the view.
    }
    

}
