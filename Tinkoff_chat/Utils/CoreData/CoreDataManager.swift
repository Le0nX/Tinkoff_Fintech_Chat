//
//  CoreDataManager.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 26/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

class CoreDataManager {

    private let coreDataStack = CoreDataStack.shared

    func loadProfile(completion: @escaping (AppUser?) -> Void) {
        AppUser.getProfile(in: coreDataStack.saveContext) { (userProfile) in
            DispatchQueue.main.async {
                completion(userProfile)
            }
        }
    }

    func saveProfile(completion: @escaping (Error?) -> Void) {
        coreDataStack.performSave(context: coreDataStack.saveContext) { (error) in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

}
