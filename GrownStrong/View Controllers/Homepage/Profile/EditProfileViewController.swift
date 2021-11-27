//
//  EditProfileViewController.swift
//  GrownStrong
//
//  Created by Aman on 29/07/21.
//

import UIKit
import Photos
import Kingfisher
import GooglePlaces

class EditProfileViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: outlets
    @IBOutlet weak var profileImgView: ProfileImageView!
    @IBOutlet weak var nameFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var locationFld: UITextField!
    @IBOutlet weak var birthdayFld: UITextField!
    @IBOutlet weak var genderFld: UITextField!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var changeHdrBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    
    var picker:UIDatePicker?
    let firebaseControllerHandle  : FIRController = FIRController()
    var newImgSelected = false
    var selectedImg = UIImage()
    var isHeaderImgForChange = false
    var selectedHeaderImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImgView.isUserInteractionEnabled = true
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(openPhotos))
        self.profileImgView.addGestureRecognizer(tapGest)
        self.setupUserInfo()
        self.birthdayFld.delegate = self
        self.locationFld.delegate = self
        self.genderFld.delegate = self
        self.emailFld.isUserInteractionEnabled = false
        self.emailFld.textColor = .lightGray
        self.passwordFld.text = "**********"
        self.passwordFld.isSecureTextEntry = true
        self.passwordFld.isUserInteractionEnabled = false
        self.locationFld.isUserInteractionEnabled = false
        // self.backBtn.defaultBtnBlackShadow()
        //        self.menuBtn.defaultBtnBlackShadow()
        //        self.changeHdrBtn.defaultBtnBlackShadow()
        
    }
    
    //    override func viewDidLayoutSubviews() {
    //        if UIDevice.current.hasNotch{
    //            let newMultiplier:CGFloat = 0.80
    //            backViewHeight = backViewHeight.setMultiplier(multiplier: newMultiplier)
    //
    //        }else{
    //
    //            let newMultiplier:CGFloat = 0.9
    //            backViewHeight = backViewHeight.setMultiplier(multiplier: newMultiplier)
    //
    //        }
    //        print("has notch",UIDevice.current.hasNotch)
    //        self.mainBackView.layoutIfNeeded()
    //        self.profileImgView.contentMode = .scaleAspectFill
    //
    //    }
    
    //MARK: setup info
    func setupUserInfo(){
        let user = UserManager.shared
        nameFld.text = user.fullName
        emailFld.text = user.userEmailAddress
        birthdayFld.text = user.birthday
        genderFld.text = user.gender
        locationFld.text = user.location
        if user.profileImage != "" && user.profileImage != nil{
            let url = URL(string: user.profileImage!)
            self.profileImgView.kf.setImage(with: url, placeholder: nil, options: .none, completionHandler: nil)
        }else{
            profileImgView.image = UIImage().imageWith(name: user.fullName)
        }
    }
    
    //MARK: select image
    @objc func openPhotos(){
        self.checkCameraPermission()
    }
    
    func checkCameraPermission(){
        let photos = PHPhotoLibrary.authorizationStatus()
        switch photos{
        case .notDetermined , .denied, .restricted:
            print("not determined")
            self.requestCameraAuthorization()
        case .authorized:
            self.showAlertForImageSelection()
        case .limited:
            print("limited")
            
        @unknown default:
            print("default")
        }
    }
    
    func requestCameraAuthorization(){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status{
            
            case .notDetermined,.restricted,.denied:
                self.openCameraPermissionSetting()
            case .authorized:
                self.showAlertForImageSelection()
            case .limited:
                print("limited")
                
            @unknown default:
                self.openCameraPermissionSetting()
            }
        }
    }
    
    func openCameraPermissionSetting(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            displayALertWithTitles(title: AppDefaultNames.name, message: "You need to change permisson status for use this feature", ["Open Settings","Cancel"]) { (index) in
                if index == 0{
                    if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    //MARK: button actions
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtn(_ sender: UIButton) {
        if let tabController = self.tabBarController as? CustomTabViewController{
            tabController.openSideMenu()
        }
        
    }
    @IBAction func changeHeaderBtn(_ sender: UIButton) {
        self.isHeaderImgForChange = true
        self.openPhotos()
    }
    
    @IBAction func editProfileBtn(_ sender: UIButton) {
        self.isHeaderImgForChange = false
        self.openPhotos()
    }
    
    @IBAction func submitBtn(_ sender: DefaultSubmitButton) {
        
        
        firebaseControllerHandle.updateUserInfo(isprofileImgSeletced: self.newImgSelected, profileImg: self.selectedImg, name: nameFld.text ?? "", DOB: birthdayFld.text ?? "", gender: genderFld.text ?? "", location: locationFld.text ?? "") { (msg) in
            let user = UserManager.shared
            user.fullName = self.nameFld.text ?? ""
            user.birthday = self.birthdayFld.text ?? ""
            user.location = self.locationFld.text ?? ""
            user.gender = self.genderFld.text ?? ""
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


//MARK:- Image Picker
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    //Show alert to selected the media source type.
    private func showAlertForImageSelection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .camera)
            }))
            alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                self.getImage(fromSourceType: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
            self?.profileImgView.image = image
            self?.selectedImg = image
            self?.newImgSelected = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileViewController :SearchLocationControllerDelegate{
    func placeSelected(_ place: GMSPlace) {
        print(place.formattedAddress as Any)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == self.birthdayFld{
            //            textField.resignFirstResponder()
            
            self.openDatePicker()
        }else if textField == self.locationFld{
            //  textField.resignFirstResponder()
            // self.pushToSearchLocation()
        }
        else if textField == self.genderFld{
            textField.resignFirstResponder()
            self.openGenderSelection()
        }
    }
    
    
    func openGenderSelection(){
        let arr = ["Male","Female","Other"]
        displayActionSheetWithTitles(title: AppDefaultNames.name, message: "Choose gender", arr) { (index) in
            self.genderFld.text = arr[index]
        }
    }
    
    
    func openDatePicker(){
        
        //Create this variable
        
        //Write Date picker code
        picker = UIDatePicker()
        birthdayFld.inputView = picker//Change your textfield name
        picker?.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        picker?.datePickerMode = .date
        picker?.maximumDate = Date()
        if #available(iOS 13.4, *) {
            picker?.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //Write toolbar code for done button
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        doneButton.tintColor = AppTheme.defaultGreenColor
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        birthdayFld.inputAccessoryView = toolBar
    }
    
    //Date picker function
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" //Change your date formate
        let strDate = dateFormatter.string(from: picker!.date)
        birthdayFld.text = strDate
    }
    
    //Toolbar done button function
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
    }
}
