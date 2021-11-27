//
//  LeadeBoardViewController.swift
//
//
//  Created by Aman on 22/07/21.
//

import UIKit

class LeadeBoardViewController: UIViewController {

    //MARK: outlets
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var segmentCntrl: UISegmentedControl!
    @IBOutlet weak var firstUserProfile: ProfileImageView!
    @IBOutlet weak var secondProfileImg: ProfileImageView!
    @IBOutlet weak var thirdProfileImg: ProfileImageView!
    @IBOutlet weak var firstUserNameLbl: UILabel!
    @IBOutlet weak var secondUsernameLbl: UILabel!
    @IBOutlet weak var thirdUsernameLbl: UILabel!
    @IBOutlet weak var firstUserPointsLbl: UILabel!
    @IBOutlet weak var secondUserPointLbl: UILabel!
    @IBOutlet weak var thirdUserPointLbl: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var rankLbl: UILabel!
    
    let FIRLeaderBoardHandler : FIRLeaderboardHandler = FIRLeaderboardHandler()
    var dailyUserData : [HomeTrendingModel] = [HomeTrendingModel]()
    var AllTimeData : [HomeTrendingModel] = [HomeTrendingModel]()
    var monthlyData : [HomeTrendingModel] = [HomeTrendingModel]()

    var mainData : [HomeTrendingModel] = [HomeTrendingModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.hideEveryThing()
    }

    //MARK: register nib
    func registerNib(){
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "LeaderBoardCell", bundle: nil), forCellReuseIdentifier: "LeaderBoardCell")
        tblView.tableFooterView = UIView()
        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont(name: AppDefaultNames.SFProRegular, size: 14)!], for: .selected)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.segmentCntrl.selectedSegmentIndex = 0
        self.fetchDailyData()
        
    }
    
    //fetch data
    func fetchDailyData(){
        FIRLeaderBoardHandler.fetchDailyData { (data) in
            DispatchQueue.main.async {
                let fltrData = data.sorted(by: { $0.points > $1.points })
                self.dailyUserData = fltrData.limit(10)
                self.mainData = self.dailyUserData
                self.tblView.reloadData(with: .fade)
                self.setupUI()
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    func fetchAllData(){
        self.FIRLeaderBoardHandler.fetchAllTimeData { (usersIds) in
            print(usersIds)
            UIApplication.topViewController()?.hideLoader()
            self.FIRLeaderBoardHandler.fetchAllUsersPoints(usersArray: usersIds) { (allTimeData) in
                let fltrData = allTimeData.sorted(by: { $0.points > $1.points })
                self.AllTimeData = fltrData.limit(10)
                self.mainData = self.AllTimeData
                UIApplication.topViewController()?.hideLoader()
                self.tblView.reloadData(with: .fade)
                self.setupUI()
            }
        }
    }
    
    func fetchMonthlyData(){
        FIRLeaderBoardHandler.fetchMonthlyDataUserIds { (userIds) in
            self.FIRLeaderBoardHandler.fetchAllUsersPoints(usersArray: userIds) { (monthData) in
                let fltrData = monthData.sorted(by: { $0.points > $1.points })
                self.monthlyData = fltrData.limit(10)
                self.mainData = self.monthlyData
                self.tblView.reloadData(with: .fade)
                self.setupUI()

            }
        }
    }
    
   
    
    //MARK: setup UI
    func setupUI(){
        if self.mainData.count > 0{
            self.firstView.isHidden = false
            if mainData.first?.image == ""{
                self.firstUserProfile.image = UIImage().imageWith(name: mainData.first?.title)
            }else{
                self.firstUserProfile.kf.setImage(with: URL(string: mainData.first?.image ?? ""))
            }
            self.firstUserNameLbl.text = mainData.first?.title
            self.firstUserPointsLbl.text = "\(mainData.first?.points ?? 0) PTS"
            
            if mainData.count > 1{
                if mainData[1].image == ""{
                    self.secondProfileImg.image = UIImage().imageWith(name: mainData[1].title)
                }else{
                    self.secondProfileImg.kf.setImage(with: URL(string: mainData[1].image ))
                }
                self.secondUsernameLbl.text = mainData[1].title
                self.secondUserPointLbl.text = "\(mainData[1].points) PTS"
                self.secondView.isHidden = false
            }else{
                self.secondView.isHidden = true
                self.thirdView.isHidden = true
            }
            
            if mainData.count > 2{
                if mainData[2].image == ""{
                    self.thirdProfileImg.image = UIImage().imageWith(name: mainData[2].title)
                }else{
                    self.thirdProfileImg.kf.setImage(with: URL(string: mainData[2].image ))
                }
                self.thirdUsernameLbl.text = mainData[2].title
                self.thirdUserPointLbl.text = "\(mainData[2].points) PTS"
                self.thirdView.isHidden = false
            }else{
                self.thirdView.isHidden = true
            }
        }else{
            self.hideEveryThing()
        }
        if mainData.count > 3{
            self.nameLbl.isHidden = false
            self.rankLbl.isHidden = false
            self.pointsLbl.isHidden = false
        }else{
            self.nameLbl.isHidden = true
            self.rankLbl.isHidden = true
            self.pointsLbl.isHidden = true
        }
        
    }
    
    
    func hideEveryThing(){
        self.firstView.isHidden = true
        self.secondView.isHidden = true
        self.thirdView.isHidden = true
        self.nameLbl.isHidden = true
        self.rankLbl.isHidden = true
        self.pointsLbl.isHidden = true
    }
 
    // MARK: navigation

   //MARK: button actions
    @IBAction func menuBtn(_ sender: UIButton) {
        if let tabController = self.tabBarController as? CustomTabViewController{
            tabController.openSideMenu()
        }
    }
    
    @IBAction func segmntCntrl(_ sender: UISegmentedControl) {
        self.mainData.removeAll()
        self.hideEveryThing()
        self.tblView.reloadData()
        if sender.selectedSegmentIndex == 0{
            self.fetchDailyData()
        }else if sender.selectedSegmentIndex == 1{
            self.fetchAllData()

        }else if sender.selectedSegmentIndex == 2{
            self.fetchMonthlyData()
        }
    }
    
}

extension LeadeBoardViewController : UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.mainData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBoardCell") as? LeaderBoardCell{
            cell.setDataInCell(data: self.mainData[indexPath.row], serial: "\(indexPath.row + 1)")
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
            return 0.0
        }else{
            return 72.0
        }
    }
}


