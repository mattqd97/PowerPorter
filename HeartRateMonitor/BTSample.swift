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
