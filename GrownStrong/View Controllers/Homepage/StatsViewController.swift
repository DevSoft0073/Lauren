//
//  StatsViewController.swift
//  Lauren
//
//  Created by Aman on 25/09/21.
//

import UIKit

class StatsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var segmntCntrl: UISegmentedControl!
    @IBOutlet weak var collectionVieww: UICollectionView!
    @IBOutlet weak var totalWorkoutsLbl: UILabel!
    @IBOutlet weak var lastMonthWorkoutLbl: UILabel!
    @IBOutlet weak var totalCaloriesLbl: UILabel!
    @IBOutlet weak var lastMonthCalLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var lastMonthWeightLbl: UILabel!
    @IBOutlet weak var streakLbl: UILabel!
    @IBOutlet weak var lastMonthStreakLbl: UILabel!
    
    let titlesArry = ["Start weight","Current Weight","Goal Weight"]
    let FIRHandlerclass : FIRStatsHandler = FIRStatsHandler()
    var allStatsData : [StatsModel] = [StatsModel]()
    var backUpStatsData : [StatsModel] = [StatsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        self.resetAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.segmntCntrl.selectedSegmentIndex = 1
        self.fetchStatsData()
    }
    //register nibs
    
    func registerNibs(){
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont(name: AppDefaultNames.SFProRegular, size: 14)!], for: .selected)
        collectionVieww.register(UINib(nibName: "StatsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StatsCollectionViewCell")
        collectionVieww.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
      
    }
    
    //MARK: Fetch data
    func fetchStatsData(){
        self.FIRHandlerclass.fetchStatsData { (data,lastWeight) in
            self.lastMonthWeightLbl.text = "Last month: \(lastWeight) Lbs"
            self.weightLbl.text = "\(UserManager.shared.currentWeight ?? "") Lbs"
            if data.count == 0{
                self.resetAllData()
            }else{
                self.allStatsData = data
                self.backUpStatsData = data
                DispatchQueue.main.async {
                    self.filterLastMonthData(month: 0,isToday: true)
                }
            }
        }
    }
    
    func filterLastMonthData(month : Int,isToday :Bool){
        self.allStatsData = backUpStatsData
        let lastMonthDate = Calendar.current.date(byAdding: .month, value: month, to: Date())
        let currentYear = Date().getCurrentYear()
        
        let lastMonthIndex = Date().getCurrentMonthForSpecificDate(date: lastMonthDate!)
        var fltrData = allStatsData.filter({$0.month == lastMonthIndex && $0.year == currentYear})
        
        let beforeLastMonthDate = Calendar.current.date(byAdding: .month, value: month - 1, to: Date())
        let beforelastMonthIndex = Date().getCurrentMonthForSpecificDate(date: beforeLastMonthDate!)
        
        self.allStatsData = backUpStatsData
        var lastBeforeFltrData = allStatsData.filter({$0.month == beforelastMonthIndex && $0.year == currentYear})
        
        if isToday{
            self.allStatsData = backUpStatsData
            let currentDay = Date().getCurrentDay()
            fltrData = allStatsData.filter({$0.month == lastMonthIndex && $0.year == currentYear && $0.day == currentDay})
            lastBeforeFltrData = allStatsData.filter({$0.month == beforelastMonthIndex && $0.year == currentYear && $0.day == currentDay})
        }
        self.totalWorkoutsLbl.text = "\(fltrData.count)"
        self.lastMonthWorkoutLbl.text = "Last month: \(lastBeforeFltrData.count)"

        
        var cal = 0
        var streak = [Int]()
        for data in fltrData{
            cal += Int(data.calories) ?? 0
            if streak.contains(data.day) == false{
                streak.append(data.day)
            }
        }
        
        self.totalCaloriesLbl.text = "\(cal) cals"
        self.streakLbl.text = "\(streak.count) days"
        
        var lastCalories = 0
        var lastStreaks = [Int]()
        for data in lastBeforeFltrData{
            lastCalories += Int(data.calories) ?? 0
            if lastStreaks.contains(data.day) == false{
                lastStreaks.append(data.day)
            }
        }
        
        self.lastMonthCalLbl.text = "Last month: \(lastCalories) cals"
        self.lastMonthStreakLbl.text = "Last month: \(lastStreaks.count)"
//        self.FIRHandlerclass.fetchCaleroiesNData(data: fltrData) { (calories, streak) in
//            self.totalCaloriesLbl.text = "\(calories) cals"
//            self.FIRHandlerclass.fetchCaleroiesNData(data: lastBeforeFltrData) { (calories, streak) in
//                self.lastMonthCalLbl.text = "Last month: \(calories) cals"
//            }
//        }
    }
    
    
    func resetAllData(){
        self.totalWorkoutsLbl.text = "0"
        self.lastMonthWorkoutLbl.text = "Last month: 0"
        self.totalCaloriesLbl.text = "0 cals"
        self.lastMonthCalLbl.text = "Last month: 0 cals"
        self.streakLbl.text = "0 day"
        self.lastMonthStreakLbl.text = "Last month: 0 day"
    }
    
    //MARK: Button actions
    @IBAction func menuBtn(_ sender: UIButton) {
        if let tabController = self.tabBarController as? CustomTabViewController{
            tabController.openSideMenu()
        }
    }
    
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            self.filterLastMonthData(month: -1,isToday: false)
        }else if sender.selectedSegmentIndex == 1{
            self.filterLastMonthData(month: 0,isToday: true)
        }else{
            self.filterLastMonthData(month: 0,isToday: false)
        }
    }
}


extension StatsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titlesArry.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsCollectionViewCell", for: indexPath) as? StatsCollectionViewCell
        cell?.titleLbl.text = self.titlesArry[indexPath.item]
        if indexPath.item == 0{
            cell?.weightLbl.text = "\(UserManager.shared.startWeight ?? "") Lbs"
        }else if indexPath.item == 1{
            cell?.weightLbl.text = "\(UserManager.shared.currentWeight ?? "") Lbs"
        }else{
            cell?.weightLbl.text = "\(UserManager.shared.goalWeight ?? "") Lbs"

        }
        return cell!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width  = (view.frame.width-16)/3.5
        return CGSize(width: 102, height: 102)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
}
