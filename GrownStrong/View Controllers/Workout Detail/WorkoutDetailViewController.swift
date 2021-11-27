//
//  WorkoutDetailViewController.swift
//  Lauren
//
//  Created by Aman on 27/09/21.
//

import UIKit

class WorkoutDetailViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var workoutNameLbl: UILabel!
    @IBOutlet weak var equipmentLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var txtViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var lowHeight : CGFloat = 0
    var workoutData : HomeTrendingModel?
    let FIRHomeHandlerClass  : FIRHomeHandler = FIRHomeHandler()
    var movementData : [WorkoutDetailMovementsModel] = [WorkoutDetailMovementsModel]()
    var isFromChallengeVC = false
    let FIRNotificationClassRef : FIRNotificationHandler = FIRNotificationHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        self.infoViewHeight.constant = lowHeight
        self.tblView.isHidden = true
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        infoView.roundCorners(corners: [.topLeft,.topRight], radius: 25)
//        self.tblView.isHidden = true
    }
    //register nibs
    
    func registerNibs(){
        tblView.register(UINib(nibName: "WorkoutOptionsCell", bundle: nil), forCellReuseIdentifier: "WorkoutOptionsCell")
        tblView.tableFooterView = UIView()
    }
    
    //MARK: setupUI
    func setupUI(){
        if self.workoutData != nil{
            self.workoutNameLbl.text = workoutData?.title
            self.equipmentLbl.text = workoutData?.equipment
            self.descriptionTextView.text = workoutData?.descriptionText
            self.checkIfWorkoutSaved()
            self.fetchMOvements()
            self.setOverAllViewHieght()
        }
        
        if isFromChallengeVC{
            tblView.separatorStyle = .none
            startBtn.setTitle("Start Challenge", for: .normal)
            
        }else{
            startBtn.setTitle("Start Workout", for: .normal)
            tblView.separatorStyle = .singleLine
        }
        self.checkIfWorkoutCompleted()
    }
    
    func setOverAllViewHieght(){
        if self.descriptionTextView.contentSize.height <= 300{
            self.txtViewHeight.constant = self.descriptionTextView.contentSize.height + 12
        }else{
            self.txtViewHeight.constant = 300
        }
        self.tblHeight.constant = 0
        self.infoViewHeight.constant = self.txtViewHeight.constant + 270
        self.lowHeight = self.infoViewHeight.constant
    }
    
    func checkIfWorkoutSaved(){
        var arr = [String]()
        if isFromChallengeVC{
            arr =  UserManager.shared.savedChallengeIDs ?? []
        }else{
            arr =  UserManager.shared.savedWorkoutsIDs ?? []
        }
        if arr.contains(self.workoutData!.id){
            saveBtn.setImage(UIImage(named: "savedFullPink"), for: .normal)
        }else{
            saveBtn.setImage(UIImage(named: "savedPink"), for: .normal)
        }
    }
    
    func checkIfWorkoutCompleted(){
        if UserManager.shared.completedWorkouts != nil{
            let fltrData = UserManager.shared.completedWorkouts!.filter({$0["idds"] as? String == self.workoutData?.id})
            if fltrData.count > 0{
                self.startBtn.setTitle("Completed", for: .normal)
                self.startBtn.isUserInteractionEnabled = false
            }
        }
        
    }
    //MARK: fetch movements
    func fetchMOvements(){
        if workoutData?.id == ""{
            return
        }
        if isFromChallengeVC{
            self.titleLbl.text = ""
            FIRHomeHandlerClass.fetchChallenegWeeks(WorkoutID: self.workoutData!.id) { (data) in
                self.movementData = data
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }else{
            FIRHomeHandlerClass.fetchWorkoutDetailMovements(WorkoutID: self.workoutData!.id) { (data) in
                self.movementData = data
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }

        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
            print("Video Finished")
        
        VideoPlayer.shared.vc.dismiss(animated: true, completion: nil)
//        VideoPlayer.shared.vc = nil
        let checkData = self.movementData.filter({$0.isPlayed == true})
        if checkData.count == self.movementData.count{
            print("all videos watched")
            self.setCompletedStatus()
           
        }else{
            var pendingURL = ""
            for data in self.movementData{
                if pendingURL != ""{
                   
                }else{
                    if data.isPlayed{
                        pendingURL = ""
                    }else{
                        data.isPlayed = true
                        pendingURL = data.videoURL
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("next video url",pendingURL)
                VideoPlayer.shared.playVimeoVideo(videoUrl: pendingURL)
            }

        }
        
    }
    
    
    
    //MARK: set completed status
    func setCompletedStatus(){
        FIRHomeHandlerClass.saveCompletedWokrout(workout: self.workoutData!, isChallenge: isFromChallengeVC) { (msg) in
            print(msg)
            self.checkIfWorkoutCompleted()
            self.uploadNotification()
        }
    }
    
    func uploadNotification(){
        FIRNotificationClassRef.uploadCompletedWONotification(isFromChallenge: isFromChallengeVC, workout: self.workoutData!) { (msg) in
            print(msg)
        }
    }
    
    //MARK: set bottom view height
    func animateViewHeight(_ animateView: UIView?, withAnimationType animType: String?) {
        if self.infoViewHeight.constant == lowHeight{
            UIView.animate(withDuration: 0.2,
            delay: 0.2,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                    
                    
                let tblContentHeight = self.tblView.contentSize.height + 48
                if tblContentHeight <= 300{
                    self.tblHeight.constant = tblContentHeight
                }else{
                    self.tblHeight.constant = 300
                }
                let overallHeight = self.lowHeight + self.tblHeight.constant
                if overallHeight > self.view.frame.height - 100{
                    self.infoViewHeight.constant = self.view.frame.height - 100

                }else{
                    self.infoViewHeight.constant = overallHeight
                }
//                self.tblHeight.constant = 200
                self.tblView.isHidden = false
                self.tblView.reloadData()
                self.tblView.layoutIfNeeded()
            self.view.layoutIfNeeded()
            },completion: nil)
            
            
        }else{
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.infoViewHeight.constant = self.lowHeight
                self.tblView.isHidden = true
                self.tblHeight.constant = 0
//                self.tblHeight.constant = 0
            self.view.layoutIfNeeded()
            }) { (flag) in
//                self.tblHeight.constant = 0
            }

        }
        
    }
    
    func setBUttonTitle(isTop : Bool){
        UIView.animate(withDuration: 0.2) {
            if isTop{
                self.moreButton.setTitle("HIDE MENU", for: .normal)
                self.moreButton.setImage(nil, for: .normal)
            }else{
                self.moreButton.setTitle("  LEARN MORE", for: .normal)
                self.moreButton.setImage(UIImage(named: "ArrowDownRed"), for: .normal)
            }
        }
    }
    
    
   //MARK: Buttona Action
    @IBAction func saveBtnClick(_ sender: UIButton) {
        if workoutData == nil{
            return
        }
        FIRHomeHandlerClass.saveWorkoutsOrChallenge(isChallenge: isFromChallengeVC, workoutModel: self.workoutData!) { (msg) in
            print(msg)
            self.checkIfWorkoutSaved()
        }
    }
    @IBAction func moreBtn(_ sender: UIButton) {
        if self.infoViewHeight.constant == lowHeight{
            self.setBUttonTitle(isTop: true)
            self.tblView.isHidden = false
            self.animateViewHeight(self.infoView, withAnimationType: CATransitionSubtype.fromTop.rawValue)
        }else{
            self.tblView.isHidden = true
            self.setBUttonTitle(isTop: false)
            self.animateViewHeight(self.infoView, withAnimationType: CATransitionSubtype.fromBottom.rawValue)
        }
        self.infoView.layoutIfNeeded()
        self.infoView.layoutSubviews()
    }
    
    @IBAction func startWokroutBTn(_ sender: Any) {
     
        if self.movementData.count == 0{
            return
        }
        
        let data = self.movementData.first
        data?.isPlayed = true
        VideoPlayer.shared.playVimeoVideo(videoUrl: data?.videoURL ?? "")
     }
    
    @IBAction func playBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension WorkoutDetailViewController : UITableViewDelegate,UITableViewDataSource{
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movementData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutOptionsCell") as? WorkoutOptionsCell
        let data = self.movementData[indexPath.row]
        cell?.titleLbl.textColor = .black
//        cell?.titleLbl.text = "Workout #\(indexPath.row + 1)"
        cell?.titleLbl.text = data.title
        cell?.timeLbl.text = data.time
        cell?.imgView.kf.setImage(with: URL(string: data.image))
        cell?.backgroundColor = .white
        if isFromChallengeVC{
            cell?.optionBtn.isHidden = true
            cell?.titleTopConstraint.constant = 4
            cell?.imageWidthConst.constant = 0
        }else{
            cell?.titleTopConstraint.constant = -6
            cell?.imageWidthConst.constant = 38
            cell?.optionBtn.isHidden = false
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data = self.movementData[indexPath.row]
//        print("voideo id is ",data.videoURL)
//        VideoPlayer.shared.playVimeoVideo(videoUrl: data.videoURL)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFromChallengeVC{
            return 30
        }else{
            return 60
        }
    }
}
