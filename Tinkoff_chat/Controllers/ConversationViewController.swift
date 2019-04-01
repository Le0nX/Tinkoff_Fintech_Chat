//
//  ConversationViewController.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 25/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextField: UITextField!

    @IBOutlet var bottomTextFieldConstraint: NSLayoutConstraint!

    @IBOutlet var tableView: UITableView! {
        didSet {
        /// трюк, чтобы UITableView не отрисовывал пустые ячейки, после того, как отрисовал все нужные ячейки
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        }
    }
    var conversation: Conversation!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupButtonView()

        CommunicationManager.shared.delegate = self
        conversation.hasUnreadMessages = false

        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = conversation.name ?? "No name"
    }

    func setupButtonView() {
        sendButton.setTitle("send", for: .normal)
        sendButton.layer.cornerRadius = sendButton.frame.width * 0.1
        sendButton.clipsToBounds = true
        sendButton.isEnabled = false
    }

    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            let isKeyboardHiding = notification.name == UIResponder.keyboardWillShowNotification

            bottomTextFieldConstraint.constant = isKeyboardHiding ? keyboardHeight + 5 - view.safeAreaInsets.bottom : 0

            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {

                self.view.layoutIfNeeded()

                }, completion: { [unowned self](_) in

                    if isKeyboardHiding {
                        if !self.conversation.history.isEmpty {
                            let indexPath = IndexPath(row: self.conversation.history.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                })
        }
    }

    @objc func dismissKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func messageWasChanged(_ sender: UITextField) {
        if messageTextField.text == "" {
            sendButton.isEnabled = false
        } else if conversation.online {
            sendButton.isEnabled = true
        }
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text else { return }

        CommunicationManager.shared.communicator.sendMessage(string: text, to: conversation.userId) { succes, error in

            if succes {
                self.messageTextField.text = ""
                self.sendButton.isEnabled = false
            }

            if let error = error {
                print(error.localizedDescription)
                self.view.endEditing(true)
                let alert = UIAlertController(title: "Отправка сообщения не удалась", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }

        }
    }

}
