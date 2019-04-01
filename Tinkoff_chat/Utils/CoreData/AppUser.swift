//
//  AppUser.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 26/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit
import CoreData

extension AppUser {

    static func getRequest(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let template = "AppUserFetch"
        guard let request = model.fetchRequestTemplate(forName: template) as? NSFetchRequest<AppUser> else {
            assert(false, "⚠️ No template with typename \(template) was found")
            return nil }
        return request
    }

    static func insertProfile(in context: NSManagedObjectContext) -> AppUser? {
        guard let profile = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else {
            return nil
        }
        profile.profileName = UIDevice.current.name
        profile.profilePicture = UIImage(named: "placeholder-user")!.pngData()
        profile.profileDescription = "No descpriton was provided"
        return profile
    }

    static func getProfile(in context: NSManagedObjectContext, completion: @escaping (AppUser?) -> Void) {
        context.perform {
            guard let model = context.persistentStoreCoordinator?.managedObjectModel else { return }
            guard let request = AppUser.getRequest(model: model) else { return }
            var profile: AppUser?
            do {
                let results = try context.fetch(request)
                assert(results.count < 2, "⚠️ there are more than 2 profiles")
                if !results.isEmpty {
                    profile = results.first!
                } else {
                    profile = AppUser.insertProfile(in: context)
                }
                completion(profile)
            } catch {
                print("⚠️ Failed to fetch profile: \(error)")
                completion(nil)
            }
        }
    }
}
