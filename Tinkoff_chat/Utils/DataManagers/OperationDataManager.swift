//
//  OperationDataManager.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 13/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

class OperationDataManager: ProfileDataManager {
    let savePath: URL
    let operationQueue = OperationQueue()

    init() {
        let homeDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        savePath = homeDir.first!.appendingPathComponent("userProfile").appendingPathExtension("plist")

        /// Serial queue for avoiding race conditions
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 1
    }

    func saveProfile(newProfile: ProfileData, oldProfile: ProfileData, callback: @escaping (Error?) -> Void) {
        let saveOperation = SaveProfileOperation()
        saveOperation.savePath = savePath
        saveOperation.callback = callback
        saveOperation.newProfile = newProfile
        saveOperation.oldProfile = oldProfile
        operationQueue.addOperation(saveOperation)
    }

    func getProfile(callback: @escaping (ProfileData) -> Void) {
        let loadOperation = LoadProfileOperation()
        loadOperation.savePath = savePath
        loadOperation.callback = callback
        operationQueue.addOperation(loadOperation)
    }
}

class LoadProfileOperation: Operation {
    var profile: ProfileData!
    var savePath: URL!
    var callback: ((ProfileData) -> Void)!

    override func main() {
        let name = UserDefaults.standard.string(forKey: "user_name") ?? "Без имени"
        let description = UserDefaults.standard.string(forKey: "user_description") ?? ""
        let image: UIImage
        if let imageData =  try? Data(contentsOf: savePath), UIImage(data: imageData) != nil {
            image = UIImage(data: imageData)!
        } else {
            image = UIImage(named: "placeholder-user")!
        }
        profile = ProfileData(name: name, description: description, userImage: image)
        OperationQueue.main.addOperation { self.callback(self.profile) }
    }
}

class SaveProfileOperation: Operation {
    var callback: ((Error?) -> Void)!
    var savePath: URL!

    var newProfile: ProfileData!
    var oldProfile: ProfileData!

    override func main() {
        if newProfile.name != oldProfile.name {
            UserDefaults.standard.set(newProfile.name, forKey: "user_name")
        }
        if newProfile.description != oldProfile.name {
            UserDefaults.standard.set(newProfile.description, forKey: "user_description")
        }
        if newProfile.userImage.pngData() != oldProfile.userImage.pngData() {
            guard let imageData = newProfile.userImage.pngData() else {
                OperationQueue.main.addOperation {
                    self.callback(ErrorProfile.imageToPng)
                }
                return
            }
            do {
                try imageData.write(to: savePath, options: .noFileProtection)
            } catch let error {
                self.callback(error)
            }
        }
        OperationQueue.main.addOperation {
            self.callback(nil)
        }
    }
}
