//
//  ChallengeViewController.swift
//  Lauren
//
//  Created by Aman on 27/09/21.
//

import UIKit

class ChallengeViewController: UIViewController,UISearchBarDelegate {

    //MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var optionCollectionView: UICollectionView!
    @IBOutlet weak var challengeCollectionView: UICollectionView!
    @IBOutlet weak var singleChallenfImg: UIImageView!
    @IBOutlet weak var singleChallengeNameLbl: UILabel!
    @IBOutlet weak var singleChlngDaysLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    let FIRHomeHandlerClass  : FIRHomeHandler = FIRHomeHandler()
    var challengesData : [HomeTrendingModel] = [HomeTrendingModel]()
    var challengesCategories : [ChallengeCategoriesModel] = [ChallengeCategoriesModel]()
    var challengesDataBackup : [HomeTrendingModel] = [HomeTrendingModel]()
    var selectedFilterData : [HomeTrendingModel] = [HomeTrendingModel]()

//    var optionArray : [NSMutableDictionary] = [["title":"All","isSelected":true],["title":"Weights","isSelected":false],["title":"Cardio","isSelected":false],["title":"No Equipment","isSelected":false]]
    var selectedIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        self.setupSearchBar()
        self.setupChallenege()
        self.fetchChallenges()
        self.selectedFilterData = self.challengesData
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.challengeCollectionView.reloadData()
    }
    
    //register nibs
    func registerNibs(){
        optionCollectionView.register(UINib(nibName: "LibrarySelectionCell", bundle: nil), forCellWithReuseIdentifier: "LibrarySelectionCell")
        challengeCollectionView.register(UINib(nibName: "WorkoutTitleCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutTitleCell")

        optionCollectionView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: setup UI
    func setupSearchBar(){
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = UIColor.colorFromHex("DEDEDE").withAlphaComponent(0.5)
        searchBar.searchTextField.tintColor = AppTheme.defaultGreenColor
        searchBar.searchTextField.returnKeyType = .done
        searchBar.delegate = self
    }

    //MARK: setup challenge
    func setupChallenege(){
        self.singleChallenfImg.kf.setImage(with: URL(string: challengesData.first?.image ?? ""))
        self.singleChallengeNameLbl.text = challengesData.first?.title
        self.challengeCollectionView.reloadData()
        self.challengesDataBackup = self.challengesData
        if UserManager.shared.savedChallengeIDs?.contains(self.challengesData.first!.id) ?? false{
            self.saveBtn.setImage(UIImage(named: "savedFullPink"), for: .normal)
        }else{
            self.saveBtn.setImage(UIImage(named: "whiteSaved"), for: .normal)
        }
    }
    
    
    
    
    
    //MARK: fetch all challenges
    func fetchChallenges(){
        FIRHomeHandlerClass.fetchChallnegsCategoris { (data) in
            DispatchQueue.main.async {
                
                self.challengesCategories.insert(contentsOf: data, at: 0)
                let allOption = ChallengeCategoriesModel(["categoryName":"All"], "")
                allOption.isSelected = true
                
                self.challengesCategories.insert(allOption, at: 0)
                self.optionCollectionView.reloadData()
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    func pushToDailyWorkoutVC(data:HomeTrendingModel){
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "WorkoutDetailViewController") as? WorkoutDetailViewController else {
            return
        }
        vc.workoutData = data
        vc.isFromChallengeVC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: button Actions
    
    @IBAction func joinNowBtn(_ sender: UIButton) {
        self.pushToDailyWorkoutVC(data: challengesDataBackup.first!)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        self.challengesData = challengesDataBackup
        if self.challengesData.count == 0{
            return
        }
        FIRHomeHandlerClass.saveWorkoutsOrChallenge(isChallenge: true, workoutModel: self.challengesData.first!) { (msg) in
            print(msg)
            if UserManager.shared.savedChallengeIDs?.contains(self.challengesData.first!.id) ?? false{
                self.saveBtn.setImage(UIImage(named: "savedFullPink"), for: .normal)
            }else{
                self.saveBtn.setImage(UIImage(named: "whiteSaved"), for: .normal)
            }
            self.challengeCollectionView.reloadData()
        }
    }
    
    @IBAction func savedListBtnClick(_ sender: UIButton) {
        if saveButton.currentImage == UIImage(named: "savedFullPink"){
            self.saveButton.setImage(UIImage(named: "savedPink"), for: .normal)
            self.challengesData = challengesDataBackup
            self.challengeCollectionView.reloadData()
        }else{
            //savedPink
            self.saveButton.setImage(UIImage(named: "savedFullPink"), for: .normal)
            let fltrData = self.selectedFilterData.filter({(UserManager.shared.savedChallengeIDs?.contains($0.id))!})
            self.challengesData = fltrData
            self.challengeCollectionView.reloadData()
        }
    }
    
}


extension ChallengeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //MARK: save unsaved
    @objc func saveBtnClick(_ sender : UIButton){
        
        let data = self.challengesData[sender.tag]
        FIRHomeHandlerClass.saveWorkoutsOrChallenge(isChallenge: true, workoutModel: data) { (msg) in
            print(msg)
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: sender.tag, section: 0)
                self.challengeCollectionView.reloadItems(at: [indexPath])
                if sender.tag == 0{
                    if UserManager.shared.savedChallengeIDs?.contains(data.id) ?? false{
                        self.saveBtn.setImage(UIImage(named: "savedFullPink"), for: .normal)
                    }else{
                        self.saveBtn.setImage(UIImage(named: "whiteSaved"), for: .normal)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == optionCollectionView{
            return self.challengesCategories.count
        }else{
            return self.challengesData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == challengeCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutTitleCell", for: indexPath) as? WorkoutTitleCell
            cell?.saveBtn.tag = indexPath.item
            cell?.saveBtn.addTarget(self, action: #selector(saveBtnClick(_:)), for: .touchUpInside)
            let data = challengesData[indexPath.item]
            cell?.setupChallengeData(data: data)
            return cell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibrarySelectionCell", for: indexPath) as? LibrarySelectionCell
            let data = challengesCategories[indexPath.item]
            cell?.setTitleBG(isSelected: data.isSelected, title: data.name)
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == optionCollectionView{
            self.setSelectedINdex(index: indexPath.item)
            self.selectedIndex = indexPath.item + 1
        }else{
            self.pushToDailyWorkoutVC(data: challengesData[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == optionCollectionView{
            let text = challengesCategories[indexPath.item].name
            let isSelected = challengesCategories[indexPath.item].isSelected
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
            let width  = (view.frame.width-32)
            return CGSize(width: width, height: 140)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == challengeCollectionView{
            return 8.0

        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == challengeCollectionView{
            return 8.0

        }else{
            return 0
        }
    }
    
    func setSelectedINdex(index:Int){
        var indexx = 0
        for data in self.challengesCategories{
            if indexx == index{
                data.isSelected = true
            }else{
                data.isSelected = false
            }
            indexx += 1
        }
        
        self.optionCollectionView.reloadData()
        
        self.challengesData = challengesDataBackup
        self.selectedFilterData = challengesDataBackup
        if index == 0{
            
        }else{
            let catData = challengesCategories[index]
            let fltrData = challengesData.filter({$0.type == catData.id})
            self.challengesData = fltrData
            self.selectedFilterData = fltrData
        }
        challengeCollectionView.reloadData()
        
    }
    
}
