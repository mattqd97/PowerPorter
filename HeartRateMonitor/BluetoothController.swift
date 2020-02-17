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

import CoreBluetooth

let heartRateServiceCBUUID = CBUUID(string: "0x00FF")
let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "FFF1")
let gsrMeasurementCharacteristicCBUUID = CBUUID(string: "FFF2")
let rosMeasurementCharacteristicCBUUID = CBUUID(string: "FFF3")


class BluetoothController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
  //MARK: Properties
  var centralManager: CBCentralManager!
  var heartRatePeripheral: CBPeripheral!
  
  weak var delegate: ModelDelegate?
  
  required init(_ delegate: ModelDelegate) {
    super.init()
    
    centralManager = CBCentralManager(delegate: self, queue: nil)
    self.delegate = delegate
  }
  
  //MARK: CBCentralManager stuff
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .unknown:
      print("central.state is .unknown")
    case .resetting:
      print("central.state is .resetting")
    case .unsupported:
      print("central.state is .unsupported")
    case .unauthorized:
      print("central.state is .unauthorized")
    case .poweredOff:
      print("central.state is .poweredOff")
    case .poweredOn:
      print("central.state is .poweredOn")
//      centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
      centralManager.scanForPeripherals(withServices: nil)
    @unknown default:
      print("central.state is unknown")
    }
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                      advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print(peripheral)
    if(peripheral.name == "Shape the World 001") {
      // hardcoded to name right now
      print("Got it")
      heartRatePeripheral = peripheral
      heartRatePeripheral.delegate = self
      centralManager.stopScan()
      centralManager.connect(heartRatePeripheral)
    }
//    heartRatePeripheral = peripheral
//    heartRatePeripheral.delegate = self
//    centralManager.stopScan()
//    centralManager.connect(heartRatePeripheral)
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Connected!")
    heartRatePeripheral.discoverServices([heartRateServiceCBUUID])
  }

  
  //MARK: CBCPeripheral stuff

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }
    for service in services {
      print(service)
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard let characteristics = service.characteristics else { return }

    for characteristic in characteristics {
      print(characteristic)

      if characteristic.properties.contains(.read) {
        print("\(characteristic.uuid): properties contains .read")
        peripheral.readValue(for: characteristic)
      }
      if characteristic.properties.contains(.notify) {
        print("\(characteristic.uuid): properties contains .notify")
        peripheral.setNotifyValue(true, for: characteristic)
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    switch characteristic.uuid {
    case heartRateMeasurementCharacteristicCBUUID:
      let bpm = heartRate(from: characteristic)
//      delegate?.didReceiveData(String(bpm))
    case gsrMeasurementCharacteristicCBUUID:
      #if DEBUG
        print("GSR = \(bluetoothCharacteristicToData(from: characteristic))")
      #endif
    case rosMeasurementCharacteristicCBUUID:
      #if DEBUG
//        print("ROS = \(bluetoothCharacteristicToData(from: characteristic))")
      #endif
    default:
      print("Unhandled Characteristic UUID: \(characteristic.uuid)")
    }
  }

  private func heartRate(from characteristic: CBCharacteristic) -> Int {
    guard let characteristicData = characteristic.value else { return -1 }
    let byteArray = [UInt8](characteristicData)

    // Assume data is just first byte
    return Int(byteArray[0])

  }
  
  private func bluetoothCharacteristicToData(from characteristic: CBCharacteristic) -> Int {
    guard let characteristicData = characteristic.value else { return -1 }
    let byteArray = [UInt8](characteristicData)
    print(byteArray[0])
    print(byteArray[1])
    print(byteArray[2])


    // Assume data is just first byte
    return Int(byteArray[0])

  }
}

protocol ModelDelegate: class {
  func didReceiveData(_ data: String)
}
