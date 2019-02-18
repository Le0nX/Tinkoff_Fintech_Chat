//
//  Logger.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 11/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation


/**
    Logs App's state transition
 
 ## Important Notes ##
 1. Logger is a singleton class
 2. Uses DEBUG target to enable/disable logging
 3. UIApplication.State has extension CustomStringConvertible
 
 ### Usage Example: ###
 
 ```
 let logger = StateLogger.shared
 logger.printInfo(about: #function)
 
 logger.appStateTransitionInfo(#function, "some state")
 
 ```
*/
class StateLogger {
    
    /// This is a **singleton** for the only one instance of Logger in our system
    static let shared = StateLogger()
    
    private init(){}
    
    /**
        Function of logging current state's transition information
     ## Important Notes ##
     
     Method understands if the calling function has "Will" in it's name and
     automaticly makes a decision about current state of the App.
    */
    func appStateTransitionInfo(_ fromFunction: String, from oldState: String, to newState: String) {
        if oldState != newState {
            if fromFunction.contains("Will") {
                self.printLog(about: "Application will move from \(oldState) to \(newState): \(fromFunction)")
            } else {
                self.printLog(about: "Application moved from \(oldState) to \(newState): \(fromFunction)")

            }
        } else {
            self.printLog(about: "ERROR occured in StateLogger")
        }
        
    }
    
    /**
      Just prints a string.
      Uses DEBUG target to enable/disable printing
    */
    func printLog(about: String) {
        #if DEBUG
        print(about)
        #endif
    }
}
