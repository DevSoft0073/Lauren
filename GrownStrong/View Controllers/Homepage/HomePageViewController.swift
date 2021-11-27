//
//  HomePageViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit
import LGSideMenuController
import Kingfisher




class HomePageViewController: UIViewController {
    
    
    
    //MARK: outlets
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var trendingLbl: UILabel!
    @IBOutlet weak var mainWorkoutImgView: UIImageView!
    @IBOutlet weak var mainWorkoutNameLbl: UILabel!
  
    
    let FIRHomeHandlerClass  : FIRHomeHandler = FIRHomeHandler()
    let FIRAuthHandlerClass  : FIRController = FIRController()

    var workoutData : [HomeTrendingModel] = [HomeTrendingModel]()
    var challengesData : [HomeTrendingModel] = [HomeTrendingModel]()

//    var exploreData : [HomeExploreModel] = [HomeExploreModel]()
    var fetchingMore = false

    var trendingDatID = ""
    var exploreID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLightStatusBar()
        self.registerNibs()
        
        self.fetchWorkouts()
        self.fetchChallenges()
        FIRAuthHandlerClass.checkAndUpdateLastMonthWeight { (msg) in
            print(msg as Any)
        }
    }
    
   
    override func viewDidLayoutSubviews() {
        self.profileBtn.imageView?.contentMode = .scaleAspectFill
        self.profileBtn.layer.cornerRadius = self.profileBtn.frame.size.width/2
        self.profileBtn.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        FIRAuthHandlerClass.fetchUserInfo()
        self.trendingCollectionView.reloadData()
    }
    
    //register nibs
    func registerNibs(){
        titleCollectionView.register(UINib(nibName: "TitleImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TitleImageCollectionCell")
        trendingCollectionView.register(UINib(nibName: "WorkoutTitleCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutTitleCell")
        trendingCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    func fetchWorkouts(){
        FIRHomeHandlerClass.fetchHomeWorkouts { (data) in
            self.workoutData = data
            DispatchQueue.main.async {
                let mainWorkout = data.first
                if mainWorkout?.image != ""{
                    self.mainWorkoutImgView.kf.setImage(with: URL(string: mainWorkout?.image ?? ""))
                }
                self.mainWorkoutNameLbl.text = mainWorkout?.title
                self.trendingCollectionView.reloadData()
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    func fetchChallenges(){
        FIRHomeHandlerClass.fetchHomeCHallenges { (data) in
            self.challengesData = data
            DispatchQueue.main.async {
                self.titleCollectionView.reloadData()
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
//    func fetchworkoutData(){
//        if self.workoutData.count == 0{
//            self.nameLbl.isHidden = true
//            self.trendingLbl.isHidden = true
//        }
//        FIRHomeHandlerClass.fetchHomeworkoutData(trendinGID : self.trendingDatID) { (data) in
//            if self.workoutData.count != 0{
//
//            }else{
//                self.trendingLbl.hideAndShowWithAnim(forHide: false)
//                self.nameLbl.hideAndShowWithAnim(forHide: false)
//            }
//            DispatchQueue.main.async {
//                if data.count > 0{
//                    self.workoutData.insert(contentsOf: data, at: self.workoutData.count)
//                }
//                self.fetchingMore = false
//                self.trendingCollectionView.reloadData()
//            }
//        }
//    }
    
//    func fetchExploreData(){
//        if self.exploreData.count == 0{
//            self.nameLbl.isHidden = true
//            self.trendingLbl.isHidden = true
//        }
//        FIRHomeHandlerClass.fetchHomeExploreData(exploreID : self.exploreID) { (exploreData) in
//            if self.exploreData.count == exploreData.count{
//
//            }else{
//                self.trendingLbl.hideAndShowWithAnim(forHide: false)
//                self.nameLbl.hideAndShowWithAnim(forHide: false)
//            }
//            //            self.workoutData.removeAll()
//            self.exploreData.removeAll()
//            DispatchQueue.main.async {
//                //                self.workoutData = data
//                self.exploreData = exploreData
//                self.titleCollectionView.reloadData()
//                //                self.trendingCollectionView.reloadData()
//            }
//        }
//    }
    
    
  
    
    func setupUser(){
        //  self.nameLbl.text = "Welcome Back, \(UserManager.shared.fullName ?? "")"
        if UserManager.shared.profileImage != nil && UserManager.shared.profileImage != ""{
            let urlImageURL = URL(string: UserManager.shared.profileImage ?? "")
            self.profileBtn.kf.setImage(with: urlImageURL, for: .normal, placeholder: UIImage(named: "whiteProfileDummy"), options: nil, progressBlock: nil, completionHandler: nil)
            // self.profileBtn.kf.setImage(with: urlImageURL, for: .normal)
        }else{
            self.profileBtn.setImage(UIImage(named: "whiteProfileDummy"), for: .normal)
        }
    }
    
  
    
    
    
    @IBAction func sideMenuBtn(_ sender: UIButton) {
        if let tabController = self.tabBarController as? CustomTabViewController{
            tabController.openSideMenu()
        }
        
    }
    @IBAction func learnMoreBtn(_ sender: UIButton) {
        self.pushtoDetailWokroutVC(selectedData: self.workoutData.first!)
    }
    
    // MARK: navigation
//    func pushToWorkoutDetailVC(model : HomeTrendingModel){
//        let vc = storyboard?.instantiateViewController(withIdentifier: "WorkoutDetailNewViewController") as? WorkoutDetailNewViewController
//        vc?.workoutModel = model
//        vc?.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc!, animated: true)
//    }
    
    func pushToChallengeVC(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ChallengeViewController") as? ChallengeViewController else {
            return
        }
        vc.challengesData = self.challengesData
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushtoDetailWokroutVC(selectedData : HomeTrendingModel ){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "WorkoutDetailViewController") as? WorkoutDetailViewController else {
            return
        }
        vc.workoutData = selectedData
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension HomePageViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //MARK: save button action
    @objc func saveButton(_ sender : UIButton){
        
        FIRHomeHandlerClass.saveWorkoutsOrChallenge(isChallenge: false, workoutModel: self.workoutData[sender.tag]) { (msg) in
            print(msg)
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: sender.tag, section: 0)
                self.trendingCollectionView.reloadItems(at: [indexPath])
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                if collectionView == trendingCollectionView{
                    return workoutData.count
                }else{
                    return challengesData.count
                }
//        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trendingCollectionView{
           // self.pushToWorkoutDetailVC(model: self.workoutData[indexPath.item])
            self.pushtoDetailWokroutVC(selectedData: self.workoutData[indexPath.item])
        }else{
            self.pushToChallengeVC()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendingCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutTitleCell", for: indexPath) as? WorkoutTitleCell
            let data = workoutData[indexPath.item]
            cell?.saveBtn.tag = indexPath.item
            cell?.saveBtn.addTarget(self, action: #selector(saveButton(_:)), for: .touchUpInside)
            cell?.setupWorkoutData(data: data)
            return cell!
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleImageCollectionCell", for: indexPath) as? TitleImageCollectionCell
//            let data = challengesData[indexPath.item]
            cell?.imageView.contentMode = .scaleAspectFit
//            if data.image != ""{
//                cell?.imageView.kf.setImage(with: URL(string: data.image))
//            }
            return cell!
        }
        
        
    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = trendingCollectionView.contentOffset.y
//        let contentHeight = trendingCollectionView.contentSize.height
////        if offsetY > contentHeight - trendingCollectionView.frame.height - 50 {
////            if !fetchingMore {
////                fetchingMore = true
//////                self.fetchworkoutData()
////            }
////        }
//    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == trendingCollectionView{
            let width  = (view.frame.width-32)
            return CGSize(width: width, height: 140)
            
        }else{
            let width  = (view.frame.width-10)/2.1
            return CGSize(width: width, height: collectionView.frame.height )
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
}

