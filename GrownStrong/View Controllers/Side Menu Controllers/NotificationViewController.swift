//
//  NotificationViewController.swift
//  GrownStrong
//
//  Created by Aman on 27/08/21.
//

import UIKit

class NotificationViewController: UIViewController {
    //MARK: outlets
    @IBOutlet weak var tblView: UITableView!
    
    var notificationData :[NotificationModel] = [NotificationModel]()
    let FIRNotificationHandlerClass : FIRNotificationHandler = FIRNotificationHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNIbs()
        self.fetchNotifications()
    }
    
    
    //MARK: fetch notification data
    func fetchNotifications(){
        FIRNotificationHandlerClass.fetchNotificationsData { (data) in
            DispatchQueue.main.async {
                self.notificationData.removeAll()
                self.notificationData = data
                self.tblView.reloadData(with: .fade)
            }
        }
    }
    
    //MARK: register nibs
    func registerNIbs(){
        tblView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tblView.tableFooterView = UIView()
    }
    
    //MARk: navigation
    
    func navigateToViewWorkoutVC(id: String,ischallenge : Bool){
        FIRNotificationHandlerClass.fetchWokroutData(workoutID: id, isChallenege: ischallenge) { (data) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WorkoutDetailViewController") as? WorkoutDetailViewController{
                vc.workoutData = data
                vc.isFromChallengeVC = ischallenge
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    //MARK: Button actions
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


}

extension NotificationViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.notificationData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell{
            cell.setupDataUI(model: self.notificationData[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.notificationData[indexPath.row]
        if data.type == NotificationTypes.challengeNotification{
            self.navigateToViewWorkoutVC(id: data.id, ischallenge: true)
        }else if data.type == NotificationTypes.workoutNotification{
            self.navigateToViewWorkoutVC(id: data.id, ischallenge: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}
