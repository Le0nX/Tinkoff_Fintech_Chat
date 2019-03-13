//
//  DataManager.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 13/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import Foundation

protocol ProfileDataManager {
    func getProfile(callback: @escaping (ProfileData) -> Void)
    func saveProfile(newProfile: ProfileData, oldProfile: ProfileData, callback: @escaping (Error?) -> Void)
}

enum ErrorProfile: Error {
    case imageToPng
}
