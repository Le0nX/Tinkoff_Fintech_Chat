//
//  ViewController.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 11/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    let logger = StateLogger.shared
    var pickerCtrl: UIImagePickerController? = UIImagePickerController()
    
    var profileInEditing: Bool = false {
        didSet{
            photoButton.isHidden = !photoButton.isHidden
            nameTextField.isHidden = !nameTextField.isHidden
            descriptionTextField.isHidden = !descriptionTextField.isHidden
            if profileInEditing {
                editButton.setTitle("Отменить редактирование", for: .normal)
            } else {
                editButton.setTitle("Редактировать", for: .normal)
            }
        }
    }
    
    
    /**
     Метод init работает по принципу:
     1. Находим .xib
     2. связываем/ассоциируем его с UIViewController
     3. В случае чего подгружаем view из этого файла.
     4. Никаких аутлетов и view у нас на этом этапе еще нет
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //print(editBtn.frame)
        //frame в init не доступен, так как view ещё не загрузилась
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //print(editBtn.frame)
        //frame в init не доступен, так как view ещё не загрузилась
    }
    
    /**
     Использование вычислений, основанных на width/height view, в методе viewDidload не имеет смысла.
     На данном этапе жизненного цикла UIViewController'a, размеры view не актуальны aka не равны тем, что будут выведены на экран
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerCtrl?.delegate = self
        
        print(editButton.frame)
        logger.printLog(about: #function)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    /**
     При вызове viewWillAppear, view уже имеет актуальные размеры,
     поэтому здесь обоснованно использование вычислений, основанных на width/height,
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logger.printLog(about: #function)
    }
    
    /**
     Поскольку viewDidAppear вызывается после viewWillAppear он также имеет актуальные размеры
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(editButton.frame) // frame с размерами после использования Auto layout
        
        logger.printLog(about: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        logger.printLog(about: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        prepareViews()
        logger.printLog(about: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        logger.printLog(about: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        logger.printLog(about: #function)
    }
    
    
//    @IBAction func exitBtnTapped (_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func editUsernamePhoto(_ sender: Any) {
        print("Выбери изображение профиля") /// task 1.6
        chooseImageAllert()
    }
    
    /**
     Метод подготовки вьюх кнопок и изображения пользователя
     */
    func prepareViews() {
        let widthPhotoBtn = photoButton.frame.size.width
        let rect = CGRect(x: widthPhotoBtn / 4,
                          y: widthPhotoBtn / 4,
                          width: widthPhotoBtn / 2,
                          height: widthPhotoBtn / 2)
        
        let imageView = UIImageView(frame: rect)
        imageView.image = UIImage(named: "slr-camera-2-xxl")
        
        photoButton.addSubview(imageView)
    
        photoButton.layer.cornerRadius = widthPhotoBtn / 2
        photoButton.clipsToBounds = true
        
        profileImage.layer.cornerRadius = widthPhotoBtn / 2
        profileImage.clipsToBounds = true
        
        editButton.layer.cornerRadius = 15
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.borderWidth = 2.0
        editButton.clipsToBounds = true
    }
    
    func presentGallery() {
        pickerCtrl!.allowsEditing = false
        pickerCtrl!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(pickerCtrl!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        weak var setImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profileImage.contentMode = .scaleToFill
        profileImage.image = setImage
        dismiss(animated: true, completion: nil)
    }
    
    func getCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            pickerCtrl!.allowsEditing = false
            pickerCtrl!.sourceType = UIImagePickerController.SourceType.camera
            pickerCtrl!.cameraCaptureMode = .photo
            present(pickerCtrl!, animated: true, completion: nil)
        } else {
            /// Обработка случаев, когда нет камеры
            let alert = UIAlertController(title: "Камера не обнаружена", message: "На вашем устройстве не обнаружена камера", preferredStyle: .alert)
            let result = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(result)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /// Метолд выбора картинки для профиля
    func chooseImageAllert() {
        let alertController = UIAlertController(title: "Выберите картинку", message: nil, preferredStyle: .actionSheet)
        
        let actionPresentGallery = UIAlertAction(title: "Установить из галлереи", style: .default) { (action: UIAlertAction) in
            self.presentGallery()
        }
        
        let actionGetCamera = UIAlertAction(title: "Сделать фото", style: .default) { (action: UIAlertAction) in
            self.getCamera()
        }
        
        alertController.addAction(actionPresentGallery)
        alertController.addAction(actionGetCamera)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func editButtonTaped(_ sender: UIButton) {
        profileInEditing = !profileInEditing
    }
    
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                
                self.view.frame.origin.y = 0
                
            } else {
                self.view.frame.origin.y = -(endFrame?.size.height ?? 0)
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
}

