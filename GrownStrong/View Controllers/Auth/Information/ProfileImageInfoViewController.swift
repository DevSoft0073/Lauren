//
//  ProfileImageInfoViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit
import Photos

class ProfileImageInfoViewController: UIViewController {

    //MARK: outlets
    @IBOutlet weak var profileImgView: ProfileImageView!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImgView.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
        self.profileImgView.isUserInteractionEnabled = true
        self.profileImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileBtnClick)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.currentPage = 1
    }
    
    
    func checkCameraPermission(){
        let photos = PHPhotoLibrary.authorizationStatus()
        switch photos{
        
        case .notDetermined:
            print("not determined")
            self.requestCameraAuthorization()
        case .restricted:
            //
            self.requestCameraAuthorization()
            print("restricted")

        case .denied:
            //
            print("denied")
            self.requestCameraAuthorization()
        case .authorized:
            self.showAlertForImageSelection()
        case .limited:
            //
            print("limited")

        @unknown default:
            print("default")

            //
        }
        
    }
    
    func requestCameraAuthorization(){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status{
            
            case .notDetermined:
                self.openCameraPermissionSetting()
            case .restricted:
                self.openCameraPermissionSetting()

            case .denied:
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
    
    // MARK: navigation
    func pushToNextVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "GenderInfoViewController") as? GenderInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    //profile image clicked
    @objc func profileBtnClick(){
        self.checkCameraPermission()
    }
    
    //MARK: buttona ctions
    @IBAction func choosePicBtn(_ sender: DefaultSubmitButton) {
        self.checkCameraPermission()
        //self.showAlert()
    }
    
    @IBAction func skipBtn(_ sender: UIButton) {
        self.pushToNextVC()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        Singleton.shared.isProfileImageSelected = false
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- Image Picker
extension ProfileImageInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {



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
            Singleton.shared.profileImage = image
            Singleton.shared.isProfileImageSelected = true
            self?.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.view.isUserInteractionEnabled = true
                self?.pushToNextVC()
            }
            
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
