//
//  CoreDataStack.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 26/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    private var storeURL: URL {
        let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = directoryURL.appendingPathComponent("Store.sqlite")
        return url
    }
    
    
    private let managedObjectModelName = "Tinkoff_chat"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        } catch {
            assert(false, "⚠️ Error in adding persistent store to coordinator: \(error)")
        }
        
        return coordinator
    }()
    
    
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    
    func performSave(context: NSManagedObjectContext, completionHandler: ((Error?)->())? ) {
        
        
            context.perform {
                if context.hasChanges {
                    do {
                        try context.save()
                    }
                    catch {
                        print(error.localizedDescription)
                        completionHandler?(error)
                    }
                    
                    if let parent = context.parent {
                        self.performSave(context: parent, completionHandler: completionHandler)
                    } else {
                        completionHandler?(nil)
                    }
            
            } else {
                completionHandler?(nil)
            }
        }
    
    }
}
