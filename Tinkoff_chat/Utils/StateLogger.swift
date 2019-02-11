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
    
    /// Previous/Starting state of our App
    private var lastState: String = "Not running"
    
    /**
        Function of logging current state's transition information
     ## Important Notes ##
     
     Method understands if the calling function has "Will" in it's name and
     automaticly makes a decision about current state of the App.
    */
    func appStateTransitionInfo(_ fromFunction: String, to state: String) {
        if fromFunction.contains("Will"), lastState != state {
            self.printInfo(about: "Application will move from \(lastState) to \(state): \(fromFunction)")
        } else {
            self.printInfo(about: "Application moved from \(lastState) to \(state): \(fromFunction)")

        }
        lastState = state // updating state
    }
    
    /**
      Just prints a string.
      Uses DEBUG target to enable/disable printing
    */
    func printInfo(about: String) {
        #if DEBUG
        print(about)
        #endif
    }
}
