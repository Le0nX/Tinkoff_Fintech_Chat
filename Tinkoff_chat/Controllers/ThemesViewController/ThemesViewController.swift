//
//  ThemesViewController.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 06/03/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet var themeButtons: [UIButton]!

    typealias ThemeHandler = (UIColor) -> Void
    var changeThemeHandler: ThemeHandler!

    private let model: Themes = Themes(color1: UIColor.red, color2: UIColor.green, color3: UIColor.blue)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = navigationController?.navigationBar.barTintColor
    }

    @IBAction func choosedThemeButton(_ sender: UIButton) {
        if sender == themeButtons[0] {
            changeThemeHandler(model.theme1)
            navigationController?.navigationBar.barTintColor = model.theme1
            view.backgroundColor = model.theme1
        } else if sender == themeButtons[1] {
            changeThemeHandler(model.theme2)
            navigationController?.navigationBar.barTintColor = model.theme2
            view.backgroundColor = model.theme2
        } else {
            changeThemeHandler(model.theme3)
            navigationController?.navigationBar.barTintColor = model.theme3
            view.backgroundColor = model.theme3
        }
    }

}
