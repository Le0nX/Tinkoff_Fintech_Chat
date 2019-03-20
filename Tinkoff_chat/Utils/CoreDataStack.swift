//
//  CoreDataStack.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 20/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var storeUrl: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("MyStore.sqlite")
    }
    
    
    let dataModelName = "DataModel"
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var presistanceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            assert(false, "error adding store \(error)")
        }
        
        return coordinator
    }()
    
    
    lazy var mainContext : NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = self.presistanceStoreCoordinator
        return mainContext
    }()
    
    typealias saveCompletion = () -> Void
    func performSave(with context: NSManagedObjectContext, completion: saveCompletion? = nil) {
        guard context.hasChanges else {
            completion?()
            return
        }
        
        context.perform {
            do {
                try context.save()
                
            } catch {
                print("Context save error \(error)")
            }
            
            // recursive save parrent
            completion?()
        }
    }
}


extension AppUser {
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else {return nil}
        
        return appUser
    }
    
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            print("ERRRRO")
            return nil
        }
        
        return fetchRequest
    }
    
    static func findOrInsertAppUser(in context:NSManagedObjectContext) -> AppUser? {
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("model error")
            return nil
        }
        
        
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do {
            let results = try? context.fetch(fetchRequest)
            //assert(results.count < 2)
            if let foundUser = results?.first {
                appUser = foundUser
            }
        } catch {
            print("FAILD")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }
        
}
