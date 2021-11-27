//
//  LocationInfoViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

class LocationInfoViewController: UIViewController,LocationServiceDelegate {

    //MARK: outlets
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.sharedInstance.startUpdatingLocation()
        LocationService.sharedInstance.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.currentPage = 3
    }
    
    
    // MARK: navigation
    func pushToNextVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "WorkOutInfoViewController") as? WorkOutInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK: button actions
    @IBAction func skipBtn(_ sender: UIButton) {
        self.pushToNextVC()
    }
    
    @IBAction func nextBtn(_ sender: DefaultSubmitButton) {
        
        self.pushToNextVC()
    }
    
    @IBAction func chooseLocationBtn(_ sender: UIButton) {
        
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAddressForLocation(locationAddress: String, currentAddress: [String : Any]) {
        print(locationAddress)
        print(currentAddress)
        if let street = currentAddress["street"] {
            print(street as Any)
            self.locationLbl.text = "\(currentAddress["street"] as? String ?? ""), \(currentAddress["region"] as? String ?? "")"
        }else{
            self.locationLbl.text = "\(currentAddress["region"] as? String ?? ""), \(currentAddress["country"] as? String ?? "")"
        }
        Singleton.shared.location = self.locationLbl.text ?? ""
        UserManager.shared.location = self.locationLbl.text ?? ""
        UserManager.shared.lattitude = currentAddress["lat"] as? String ?? ""
        UserManager.shared.longtitude = currentAddress["long"] as? String ?? ""
    }
    
    

}
