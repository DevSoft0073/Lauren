//
//  ProfileViewController.swift
//  GrownStrong
//
//  Created by Aman on 22/07/21.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController,LocationServiceDelegate {
    
    //MARK: outlets
    @IBOutlet weak var purchasedBtn: UIButton!
    //    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var savedWorkBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImgView: ProfileImageView!
    @IBOutlet weak var adressLbl: UILabel!
    @IBOutlet weak var birthdayLbl: UILabel!
    @IBOutlet weak var noItemLbl: UILabel!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    @IBOutlet weak var collectionVieww: UICollectionView!
    @IBOutlet weak var notificationBtn: UIButton!
    
    let FIRHomeHandlerClass  : FIRHomeHandler = FIRHomeHandler()
    let FIRHomeHandlerStatsClass  : FIRStatsHandler = FIRStatsHandler()

    var savedWorkoutData : [HomeTrendingModel] = [HomeTrendingModel]()
    var mainData : [HomeTrendingModel] = [HomeTrendingModel]()

    var fetchingMore = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont(name: AppDefaultNames.SFProRegular, size: 14)!], for: .selected)

        //        self.noItemLbl.text = "No any Workout saved yet"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupInfo()
    }
    
    //register nibs
    
    func registerNibs(){
        collectionVieww.register(UINib(nibName: "WorkoutBottomOptionCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutBottomOptionCell")
    }
    
    
        func setupInfo() {
            self.segmentCtrl.selectedSegmentIndex = 0
            let user = UserManager.shared
            self.nameLbl.text = user.fullName
            self.birthdayLbl.text = "Born \(user.birthday ?? "")"
            if user.location == ""{
                LocationService.sharedInstance.startUpdatingLocation()
                LocationService.sharedInstance.delegate = self
            }else{
                self.adressLbl.text = user.location
            }
            self.profileImgView.contentMode = .scaleAspectFill
            if user.profileImage != nil && user.profileImage != ""{
                let url = URL(string: user.profileImage!)
                self.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "whiteProfileDummy"), options: nil, completionHandler: nil)
            }else{
                self.profileImgView.image = UIImage().imageWith(name: user.fullName)
            }
            self.fetchSavedWorkouts()
        }
    
    
    //MARK: fetch saved workout ids
    func fetchSavedWorkouts(){
        self.FIRHomeHandlerClass.fetchSavedWorkoutsForProfile { (data) in
            DispatchQueue.main.async {
                self.savedWorkoutData.removeAll()
                self.savedWorkoutData = data
                self.mainData = data
                self.collectionVieww.reloadData()
                self.setupVIew(segmentIndex: 0)
            }
        }
    }
    
    
    func fetchCompletedWorkouts(){
        self.FIRHomeHandlerStatsClass.fetchStatsData { (data, str) in
            self.FIRHomeHandlerClass.fetchCompletedWorkouts(workoutStatsData: data) { (data) in
                DispatchQueue.main.async {
                    self.mainData = data
                    self.collectionVieww.reloadData()
                    self.setupVIew(segmentIndex: 2)
                }
            }
        }
    }
    
    func setupVIew(segmentIndex : Int){
        if segmentIndex == 0 || segmentIndex == 2{
            if mainData.count > 0{
                self.collectionVieww.isHidden = false
            }else{
                self.collectionVieww.isHidden = true
            }
        }else{
            self.collectionVieww.isHidden = true
        }
    }

    
    
    func getAddressForLocation(locationAddress: String, currentAddress: [String : Any]) {
        print(locationAddress)
        print(currentAddress)
        if let street = currentAddress["street"] {
            print(street as Any)
            self.adressLbl.text = "\(currentAddress["street"] as? String ?? ""), \(currentAddress["region"] as? String ?? "")"
        }else{
            self.adressLbl.text = "\(currentAddress["region"] as? String ?? ""), \(currentAddress["country"] as? String ?? "")"
        }
        UserManager.shared.location = self.adressLbl.text ?? ""
    }
    
    //navigation
    // MARK: navigation
    func pushToEditProfileVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
        vc?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func pushToNotificationVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController
        vc?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   
    
    
    // MARK: navigation
//    func pushToWorkoutDetailVC(model : HomeTrendingModel){
//        let vc = storyboard?.instantiateViewController(withIdentifier: "WorkoutDetailNewViewController") as? WorkoutDetailNewViewController
//        vc?.workoutModel = model
//        vc?.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc!, animated: true)
//    }
    
    //MARK: button action
    @IBAction func messageBoardBtn(_ sender: UIButton) {
    }
    
    @IBAction func menuBtn(_ sender: UIButton) {
        //        if let tabController = self.tabBarController as? CustomTabViewController{
        //            tabController.openSideMenu()
        //        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmenClick(_ sender: UISegmentedControl) {
        self.mainData.removeAll()
        self.collectionVieww.reloadData()
        if sender.selectedSegmentIndex == 0{
            self.fetchSavedWorkouts()
        }else if sender.selectedSegmentIndex == 2{
            self.fetchCompletedWorkouts()
        }else{
            self.setupVIew(segmentIndex: sender.selectedSegmentIndex)
        }
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        self.pushToEditProfileVC()
    }
    
    @IBAction func notificationBtn(_ sender: UIButton) {
        self.pushToNotificationVC()
    }
    //scroll delegate
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    ////        if scrollView == trendingCollectionView{
    //            let offsetY = tblView.contentOffset.y
    //            let contentHeight = tblView.contentSize.height
    //            if offsetY > contentHeight - tblView.frame.height - 50 {
    //                if !fetchingMore {
    ////                    fetchingMore = true
    ////                    self.fetchSavedWorkouts()
    //                }
    //            }
    ////        }
    //    }
    
    
}

extension ProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //MARK: save button action
    @objc func saveButton(_ sender : UIButton){
        
//        FIRHomeHandlerClass.saveWorkoutsOrChallenge(isChallenge: false, workoutModel: self.mainData[sender.tag]) { (msg) in
//            print(msg)
//            DispatchQueue.main.async {
//                let indexPath = IndexPath(item: sender.tag, section: 0)
//                self.collectionVieww.reloadItems(at: [indexPath])
//            }
//        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if collectionView == trendingCollectionView{
        //            return trendingData.count
        //        }else{
        //            return exploreData.count
        //        }
        return mainData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutBottomOptionCell", for: indexPath) as? WorkoutBottomOptionCell
        let data = mainData[indexPath.item]
        cell?.setupCellData(data: data)
        cell?.saveBtn.tag = indexPath.item
        cell?.saveBtn.addTarget(self, action: #selector(saveButton(_:)), for: .touchUpInside)
        return cell!
        
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let offsetY = trendingCollectionView.contentOffset.y
    //        let contentHeight = trendingCollectionView.contentSize.height
    ////        if offsetY > contentHeight - trendingCollectionView.frame.height - 50 {
    ////            if !fetchingMore {
    ////                fetchingMore = true
    //////                self.fetchtrendingData()
    ////            }
    ////        }
    //    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width  = (view.frame.width-16)/2
        return CGSize(width: width, height: width + 32.0)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
}
