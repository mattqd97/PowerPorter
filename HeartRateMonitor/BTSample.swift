// Bluetooth Sample stuff

import Foundation
import os.log

class BTSample: NSObject, NSCoding {
  // NSObject and NSCoding for persistance
  // With help from https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html#//apple_ref/doc/uid/TP40015214-CH14-SW1
  
  //MARK: Properties
  
  var gsr:        Int32?  // sample from gsr sensor
  var spO2:       Int32?  //
  var heartrate:  Int32   // heart rate from sensor
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
  
  init?(gsr: Int32?, spO2: Int32?, heartrate: Int32, time: Date) {
    // Initialize stored properties
    if spO2 == 0 || heartrate == 0 {
      return nil
    }
    self.gsr = gsr
    self.spO2 = spO2
    self.heartrate = heartrate
    self.time = time
    
    // Check for init fail??
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
    guard let heartrate = aDecoder.decodeObject(forKey: PropertyKey.heartrate) as? Int32
    else {
      os_log("Unable to decode heartrate for a BTSample.", log: OSLog.default, type: .debug)
      return nil
    }
    
    // decode rest as optional
    let gsr = aDecoder.decodeObject(forKey: PropertyKey.gsr) as? Int32
    let spO2 = aDecoder.decodeObject(forKey: PropertyKey.spO2) as? Int32
    guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? Date
    else {
      os_log("Unable to decode time for a BTSample.", log: OSLog.default, type: .debug)
      return nil
    }
    
    self.init(gsr: gsr, spO2: spO2, heartrate: heartrate, time: time)
  }
}
