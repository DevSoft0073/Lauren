//
//  DailyWorkoutViewController.swift
//  Lauren
//
//  Created by Aman on 27/09/21.
//

import UIKit

class DailyWorkoutViewController: UIViewController {
//MARK: outlets
    @IBOutlet weak var workoutCollectionView: UICollectionView!
    @IBOutlet weak var optionCollectionView: UICollectionView!
    @IBOutlet weak var singleWorkoutImageView: UIImageView!
    @IBOutlet weak var wokroutNameLbl: UILabel!
    
    let FIRHomeHandlerClass  : FIRHomeHandler = FIRHomeHandler()
    var workoutData : [HomeTrendingModel] = [HomeTrendingModel]()
    var workoutDataBackup : [HomeTrendingModel] = [HomeTrendingModel]()

    var categoriesData : [ChallengeCategoriesModel] = [ChallengeCategoriesModel]()
    var interactiveTransition: BubbleInteractiveTransition?

    
    var optionArray : [NSMutableDictionary] = [["title":"All","isSelected":true],["title":"Weights","isSelected":false],["title":"Cardio","isSelected":false],["title":"No Equipment","isSelected":false]]
    var selectedIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        self.fetchWorkoutData()
        self.fetchWorkoutCategories()
    }
    
    //register nibs
    func registerNibs(){
        optionCollectionView.register(UINib(nibName: "LibrarySelectionCell", bundle: nil), forCellWithReuseIdentifier: "LibrarySelectionCell")
        workoutCollectionView.register(UINib(nibName: "WorkoutBottomOptionCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutBottomOptionCell")
        
        optionCollectionView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: fetch workout dta
    func fetchWorkoutData(){
        FIRHomeHandlerClass.fetchHomeWorkouts { (data) in
            DispatchQueue.main.async {
                self.workoutData = data
                self.workoutDataBackup = data
                self.singleWorkoutImageView.kf.setImage(with: URL(string: self.workoutData.first?.image ?? ""))
                self.wokroutNameLbl.text = self.workoutData.first?.title
                self.workoutCollectionView.reloadData()
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    //MARK: fetch workout categories
    func fetchWorkoutCategories(){
        FIRHomeHandlerClass.fetchWorkoutsCategories { (data) in
            DispatchQueue.main.async {
                self.categoriesData = data
                let allOption = ChallengeCategoriesModel(["categoryName":"All"], "")
                allOption.isSelected = true
                self.categoriesData.insert(allOption, at: 0)
                self.optionCollectionView.reloadData()
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    
 
    func pushToWorkoutDetailVC(workout :HomeTrendingModel){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "WorkoutDetailViewController") as? WorkoutDetailViewController else {
            return
        }
        vc.hidesBottomBarWhenPushed = true
        vc.workoutData = workout
        self.navigationController?.pushViewController(vc, animated: true)
    }


    
    @IBAction func backbtn(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            UIApplication.topViewController()?.hideLoader()
        }
        if self.interactiveTransition == nil{
            self.interactiveTransition = BubbleInteractiveTransition()
        }
        self.interactiveTransition?.finish()
    }
    
    @IBAction func viewWorkoutBtn(_ sender: UIButton) {
        self.pushToWorkoutDetailVC(workout: self.workoutData.first!)
    }
}


extension DailyWorkoutViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    
    //MARK: save button action
    @objc func saveButton(_ sender : UIButton){
        
        FIRHomeHandlerClass.saveWorkoutsOrChallenge(isChallenge: false, workoutModel: self.workoutData[sender.tag]) { (msg) in
            print(msg)
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: sender.tag, section: 0)
                self.workoutCollectionView.reloadItems(at: [indexPath])
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == optionCollectionView{
            return categoriesData.count
        }else{
            return self.workoutData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == workoutCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutBottomOptionCell", for: indexPath) as? WorkoutBottomOptionCell
            let data = workoutData[indexPath.item]
            cell?.setupCellData(data: data)
            cell?.saveBtn.tag = indexPath.item
            cell?.saveBtn.addTarget(self, action: #selector(saveButton(_:)), for: .touchUpInside)

            return cell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibrarySelectionCell", for: indexPath) as? LibrarySelectionCell
            cell?.setTitleBG(isSelected: categoriesData[indexPath.item].isSelected, title: categoriesData[indexPath.item].name)
//            cell?.setTitleBG(isSelected: optionArray[indexPath.item]["isSelected"] as? Bool ?? false, title: optionArray[indexPath.item]["title"] as? String ?? "")
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == optionCollectionView{
            self.setSelectedINdex(index: indexPath.item)
            self.selectedIndex = indexPath.item + 1
        }else{
            let data = workoutData[indexPath.item]
            self.pushToWorkoutDetailVC(workout: data)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == optionCollectionView{
            let text = categoriesData[indexPath.item].name
            let isSelected = categoriesData[indexPath.item].isSelected
            let lbl = UILabel()
            lbl.text = text
            var height :CGFloat = 0
            if isSelected{
                height = 58
            }else{
                height = 54
            }
            return CGSize(width: lbl.intrinsicContentSize.width + 48, height: height )
        }else{
            let width  = (view.frame.width-16)/2
            return CGSize(width: width, height: width + 32.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == workoutCollectionView{
            return 8.0

        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == workoutCollectionView{
            return 8.0

        }else{
            return 0
        }
    }
    
    func setSelectedINdex(index:Int){
        var indexx = 0
        for data in self.categoriesData{
            if indexx == index{
                data.isSelected = true
            }else{
                data.isSelected = false
            }
            indexx += 1
        }
        
        self.optionCollectionView.reloadData()
        
        
        self.workoutData = workoutDataBackup
        if index == 0{
            
        }else{
            let fltrData = self.workoutData.filter({$0.type == categoriesData[index].id})
            self.workoutData = fltrData
        }
        self.workoutCollectionView.reloadData()
        
    }
    
}
