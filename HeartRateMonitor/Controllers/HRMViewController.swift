// View Controller for main page

import UIKit
import CoreBluetooth



class HRMViewController: UIViewController {
  //MARK: ViewController stuff

  @IBOutlet weak var heartRateLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
      
    // set up bluetooth
    let bluetooth = BluetoothController()
    bluetooth.centralManager = CBCentralManager(delegate: bluetooth, queue: nil)
    bluetooth.delegate = self;

    // Make the digits monospaces to avoid shifting when the numbers change
    heartRateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: heartRateLabel.font!.pointSize, weight: .regular)
  }

}

extension HRMViewController: ModelDelegate {
  func didReceiveData(_ data: String) {
    heartRateLabel.text = data
    print("BPM: \(data)")
  }
}

