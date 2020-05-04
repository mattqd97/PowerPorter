// Bluetooth Sample stuff

import Foundation
import os.log
import CSV

class BTSample: NSObject, NSCoding {
  // NSObject and NSCoding for persistance
  // With help from https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html#//apple_ref/doc/uid/TP40015214-CH14-SW1
  
  //MARK: Properties
  
  var gsr:        Double?  // sample from gsr sensor
  var spO2:       Double?
  var heartrate:  Double   // heart rate from sensor
  var ECG:        Double?
  var EMG:        Double?
  var stressed:   Double?  // For training
  var time:       Date    // time that sample is taken
  
  //MARK: Global Array
  static var samples = [BTSample]()
  
  
  //MARK: Archiving Paths
   
  static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.appendingPathComponent("samples")
  
  
  //MARK: Types
  
  struct PropertyKey {
    static let gsr = "gsr"
    static let spO2 = "spO2"
    static let heartrate = "heartrate"
    static let time = "time"
  }
  
  
  
  //MARK: Initialization
  
  init?(gsr: Double?, spO2: Double?, heartrate: Double, time: Date) {
    // Initialize stored properties
    if heartrate == 0 {
      return nil
    }
    self.gsr = gsr
    self.spO2 = spO2
    self.heartrate = heartrate
    self.time = time
    
    // Check for init fail??
  }
  
  init?(ecg: Double?, heartrate: Double, gsr: Double?, emg: Double?, stress: Double?) {
    // Initialize stored properties
    if heartrate == 0 {
      return nil
    }
    
    self.ECG = ecg
    self.heartrate = heartrate
    self.gsr = gsr
    self.EMG = emg
    self.stressed = stress
    self.time = Date() // current date
  }
  
  
  //MARK: NSCoding
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(gsr, forKey: PropertyKey.gsr)
    aCoder.encode(spO2, forKey: PropertyKey.spO2)
    aCoder.encode(heartrate, forKey: PropertyKey.heartrate)
    aCoder.encode(time, forKey: PropertyKey.time)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    // heartrate is required
    guard let heartrate = aDecoder.decodeObject(forKey: PropertyKey.heartrate) as? Double
    else {
      os_log("Unable to decode heartrate for a BTSample.", log: OSLog.default, type: .debug)
      return nil
    }
    
    // decode rest as optional
    let gsr = aDecoder.decodeObject(forKey: PropertyKey.gsr) as? Double
    let spO2 = aDecoder.decodeObject(forKey: PropertyKey.spO2) as? Double
    guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? Date
    else {
      os_log("Unable to decode time for a BTSample.", log: OSLog.default, type: .debug)
      return nil
    }
    
    self.init(gsr: gsr, spO2: spO2, heartrate: heartrate, time: time)
  }
  
  static func readCSV() {
    // Get current path
    let packageRoot = #file.replacingOccurrences(of: "HeartRateMonitor/BTSample.swift", with: "")
    print("Directory = \(packageRoot)")
    
    
    let stream = InputStream(fileAtPath: String(packageRoot) + "/AppData.csv")!
    let csv = try! CSVReader(stream: stream)
    
    parseTrainingCSV(input: csv)
    
  }
  
  static func parseTrainingCSV(input csv: CSVReader) {
    // Get first row
    let _ = csv.next()
    
    // Parse rest
    while let row = csv.next() {
      
      // Convert data to double
      let rowAsDouble = row.compactMap(Double.init)
      if rowAsDouble.count != 5 {
        continue
      }
      print("\(rowAsDouble)")       // for debug
      
      // Here is how the CSV columns are
      // ECG | HR | handGSR | EMG | stress
      guard let sample = BTSample(ecg: rowAsDouble[0], heartrate: rowAsDouble[1],
                            gsr: rowAsDouble[2], emg: rowAsDouble[3], stress: rowAsDouble[4])
        else {
          print("Error parsing CSV")
          return
      }
      samples.append(sample)
      
    }
    
  }
  
}
