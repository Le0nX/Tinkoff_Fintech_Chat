//
//  ConversationsListVC+ThemesViewControllerDelegate.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 06/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit

extension ConversationsListViewController: ThemesViewControllerDelegate {

    func themesViewController(_ controller: ThemesViewController, didSelect selectedTheme: UIColor) {
        controller.view.backgroundColor = selectedTheme
        UINavigationBar.appearance().barTintColor = selectedTheme

        /// save Themes data
        DispatchQueue.global(qos: .utility).async {
            guard let themeData =  try? NSKeyedArchiver.archivedData(withRootObject: selectedTheme, requiringSecureCoding: false) else { return }
            UserDefaults.standard.set(themeData, forKey: "SavedTheme")
        }
        StateLogger.shared.logThemeChanged(selectedTheme: selectedTheme)
    }

}
