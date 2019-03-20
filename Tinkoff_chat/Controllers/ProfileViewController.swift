//
//  ViewController.swift
//  Tinkoff_chat
//
//  Created by Denis Nefedov on 11/02/2019.
//  Copyright © 2019 X. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var gcdButton: UIButton!
    @IBOutlet var operationButton: UIButton!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    var dataStack = CoreDataStack()
    
    //MARK: - Models
    var profile: ProfileData!
    
    //MARK: - Data Managers
    var dataManager: ProfileDataManager!
    let gcdDataManager = GCDDataManager()
    let operationDataManager = OperationDataManager()
    
    //MARK: - Utils
    let logger = StateLogger.shared
    var pickerCtrl: UIImagePickerController? = UIImagePickerController()
    
    //MARK: - Controll Helpers
    private var savingInProcess = false /// находимся в процессе сохранения.
    private var photoIsEstablished = false /// если есть фото, то дать возможность его удалить
    
    private var profileInEditing: Bool = false {
        didSet{
            photoButton.isHidden = !photoButton.isHidden
            nameTextField.isHidden = !nameTextField.isHidden
            descriptionTextField.isHidden = !descriptionTextField.isHidden
            gcdButton.isHidden = !gcdButton.isHidden
            operationButton.isHidden = !operationButton.isHidden
            if profileInEditing {
                gcdButton.isEnabled = false
                operationButton.isEnabled = false
                editButton.setTitle("Отменить редактирование", for: .normal)
            } else {
                editButton.setTitle("Редактировать", for: .normal)
                updateView()
            }
        }
    }
    
    //MARK: - ViewController LifeCycle(HW1)
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
    NotificationCenter.default.addObserver(self,selector:#selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification,object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        loadProfileSettings()
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
    
    // MARK: - photoButton routine
    @IBAction func editUsernamePhoto(_ sender: Any) {
        print("Выбери изображение профиля") /// task 1.6
        chooseImageAllert()
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
//        prepareSaveButtons()
        operationButton.isEnabled = true
        gcdButton.isEnabled = true
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
        
        
        if photoIsEstablished {
            let deleteAlertAction = UIAlertAction(title: "Удалить фотографию", style: .destructive) { [weak self] action in
                guard let `self` = self else { return }
                self.profileImage.image = UIImage(named: "placeholder-user")
                self.photoIsEstablished = false
                self.prepareSaveButtons()
            }
            alertController.addAction(deleteAlertAction)
        }
        
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
    
    //MARK: - UI settings
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
        
        editButton.clipsToBounds = true
        
        styleProfileButton(editButton, with: UIColor.black.cgColor, cornerRaius: 10)
        styleProfileButton(gcdButton, with: UIColor.black.cgColor, cornerRaius: 10)
        styleProfileButton(operationButton, with: UIColor.black.cgColor, cornerRaius: 10)
    }
    
    func styleProfileButton(_ button: UIButton, with borderColor: CGColor, cornerRaius: CGFloat) {
        button.layer.borderColor = borderColor
        button.layer.cornerRadius = cornerRaius
        button.layer.borderWidth = 2.0
    }
    
    private func updateView() {
        userNameLabel.text = profile.name
        descriptionLabel.text = profile.description
        profileImage.image = profile.userImage
    }
    
    // MARK: - Profile saving/loading routines
    @IBAction func editButtonTaped(_ sender: UIButton) {
        profileInEditing = !profileInEditing
    }
    
    
    @IBAction func saveProfileGCD(_ sender: UIButton) {
        
        
        let appUser = AppUser.findOrInsertAppUser(in: self.dataStack.mainContext)
        appUser?.setValue(nameTextField.text, forKey: "name")
        //appUser?.setValue(Data(), forKey: "timestamp")
        dataStack.performSave(with: self.dataStack.mainContext)
        
        
        let model = dataStack.managedObjectModel
        let name = AppUser.fetchRequestAppUser(model: model)
        let result = try! dataStack.mainContext.fetch(name!)
        print(result.first!.name)
        
        dataManager = gcdDataManager
        saveProfileSettings()
        // MARK: update userName
//        CommunicationManager.shared.communicator.updateUserName()
    }
    
    @IBAction func saveProfileOperation(_ sender: UIButton) {
        dataManager = operationDataManager
        saveProfileSettings()
        // MARK: update userName
//        CommunicationManager.shared.communicator.updateUserName()
    }
    
    private func loadProfileSettings() {
        editButton.isHidden = true
        dataManager = operationDataManager
        activityIndicator.startAnimating()
        gcdDataManager.getProfile { (profile) in
            self.profile = profile
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.editButton.isHidden = false
            // compare with default photo
            self.photoIsEstablished = UIImage(named: "placeholder-user")!.pngData() != profile.userImage.pngData()
            self.updateView()
        }
    }
    
    private func saveProfileSettings() {
        // на время сохранения делаем кнопки неактивными
        
        savingInProcess = true
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        //get new profileData from view
        let newProfileData = ProfileData(name: nameTextField.text!, description: descriptionTextField.text!, userImage: profileImage.image!)
        
        // здесь self не делаем weak, т.к. "Passing a block to dispatch_async on a global or main queue will NEVER produce a retain cycle.
        dataManager.saveProfile(newProfile: newProfileData, oldProfile: profile) { (exception) in
            if exception == nil {
                self.profile = newProfileData
                let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ок", style: .default) { action in
                    if self.profileInEditing {
                        self.profileInEditing = false
                    } else {
                        self.updateView()
                    }
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ок", style: .default, handler: nil)
                let tryAgain = UIAlertAction(title: "Повтор", style: .default) { action in
                    self.saveProfileSettings()
                }
                alert.addAction(ok)
                alert.addAction(tryAgain)
                self.present(alert, animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.gcdButton.isEnabled = true
            self.operationButton.isEnabled = true
            self.savingInProcess = false
        }
    }
    
    // MARK: - save buttons enable/disable
    
    
    @IBAction func nameHasChanged(_ sender: UITextField) {
        prepareSaveButtons()
    }
    
    @IBAction func descriptionHasChanged(_ sender: UITextField) {
        prepareSaveButtons()
    }
    
    private func prepareSaveButtons() {
        gcdButton.isEnabled = checkGcdButton()
        operationButton.isEnabled = checkOperationButton()
    }
    
    private func checkGcdButton() -> Bool {
        return !savingInProcess && (nameTextField.text != "") && ((nameTextField.text != profile.name) || (descriptionTextField.text != profile.description) || (profileImage.image!.pngData() != profile.userImage.pngData()))
    }
    
    private func checkOperationButton() -> Bool {
        return !savingInProcess && (nameTextField.text != "") && ((nameTextField.text != profile.name) || (descriptionTextField.text != profile.description) || (profileImage.image!.pngData() != profile.userImage.pngData()))
    }
    
    // MARK: - keyboard Routine
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
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

