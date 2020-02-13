// View Controller for main page

import UIKit
import CoreBluetooth


class HRMViewController: UIViewController {
  //MARK: ViewController stuff

  @IBOutlet weak var heartRateLabel: UILabel!
  var bluetooth : BluetoothController!

  override func viewDidLoad() {
    super.viewDidLoad()
      
    // set up bluetooth
    bluetooth = BluetoothController(self)

    // Make the digits monospaces to avoid shifting when the numbers change
    heartRateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: heartRateLabel.font!.pointSize, weight: .regular)
  }

}

// Gets infomraiton from bluetooth through delegate
extension HRMViewController: ModelDelegate {
  func didReceiveData(_ data: String) {
    heartRateLabel.text = data
    #if DEBUG
      print("BPM = \(data)")
    #endif
  }
}

