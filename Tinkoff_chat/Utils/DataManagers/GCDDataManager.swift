//
//  GCDDataManager.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 13/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

class GCDDataManager: ProfileDataManager {
    
    /// Serial queue
    let serialQueue =  DispatchQueue(label: "com.nefedov.serial", qos: .userInitiated)
    let savePath: URL
    
    init() {
        let homeDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        savePath = homeDir.first!.appendingPathComponent("userProfile").appendingPathExtension("plist")
    }
    
    
    /// Метод сохранения картинки в png.
    ///
    /// - Parameter image: картинка для сохранения
    /// - Throws: ErrorProfile.imageToPng
    func saveImage(image: UIImage) throws {
        
        guard let imagePng = image.pngData() else {
            throw ErrorProfile.imageToPng
        }
        
        do {
            try imagePng.write(to: savePath, options: .noFileProtection)
        } catch let exception {
            throw exception
        }
    }
    
    func getProfile(callback: @escaping (ProfileData) -> Void) {
        serialQueue.async {
            let image: UIImage!
            let name = UserDefaults.standard.string(forKey: "user_name") ?? "Без имени"
            let description = UserDefaults.standard.string(forKey: "user_description") ?? ""
            
            if let imagePng =  try? Data(contentsOf: self.savePath), UIImage(data: imagePng) != nil {
                image = UIImage(data: imagePng)!
            } else {
                image = UIImage(named: "placeholder-user")! //default pic
            }
            
            let profile = ProfileData(name: name, description: description, userImage: image)
            DispatchQueue.main.async {
                callback(profile)
            }
        }
    }
    
    /// Сохранение профиля
    ///
    /// - Parameters:
    ///   - newProfile: Новый профиль, который нужно сохранить
    ///   - oldProfile: старый профиль для проверки. Если совпадает, то сохранять ничего не нужно
    ///   - callback: колбэк для отрисовки UI в main очереди
    func saveProfile(newProfile: ProfileData, oldProfile: ProfileData, callback: @escaping (Error?) -> Void) {
        serialQueue.async {
            //save new name
            if newProfile.name != oldProfile.name {
                UserDefaults.standard.set(newProfile.name, forKey: "user_name")
            }
            //save new description
            if newProfile.description != oldProfile.name {
                UserDefaults.standard.set(newProfile.description, forKey: "user_description")
            }
            //save new photo
            if newProfile.userImage.pngData() != oldProfile.userImage.pngData() {
                do {
                    try self.saveImage(image: newProfile.userImage)
                } catch let exception {
                    DispatchQueue.main.async {
                        // sUI routines
                        callback(exception)
                    }
                    return
                }
            }
            // UI routines
            DispatchQueue.main.async {
                callback(nil)
            }
        }
    }
}
