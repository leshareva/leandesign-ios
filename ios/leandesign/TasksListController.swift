//
//  tasksListView.swift
//  leandesign
//
//  Created by Sladkikh Alexey on 8/9/16.
//  Copyright © 2016 LeshaReva. All rights reserved.
//

import UIKit
import DigitsKit
import Firebase
import PullToRefresh



class TasksListController: UITableViewController {
    
    let cellId = "cellId"
    var tasks = [Task]()
    var taskDictionary = [String: Task]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(openNewTaskView))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "more")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(handleMore))
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
        navigationController?.navigationBar.translucent = false
        
        let titleLabel = UITextView()
        navigationItem.titleView = titleLabel
        titleLabel.text = "Лин"
        titleLabel.textColor = UIColor.whiteColor()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
       
            self.tableView.reloadData()
        
        checkIfUserIsLoggedIn()
        setupPullToRefresh()
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.bottomPullToRefresh!)
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    private func startRefreshing() {
        tableView.startRefreshing(at: .Top)
    }
    
    func setupPullToRefresh () {
        tableView.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self!.fetchUserAndSetupNavBarTitle()
                self?.tableView.endRefreshing(at: .Top)
            }
        }
        
        tableView.addPullToRefresh(PullToRefresh(position: .Bottom)) { [weak self] in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self?.tableView.reloadData()
                self?.tableView.endRefreshing(at: .Bottom)
            }
        }
    }
    
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.tasksListController = self
        return launcher
    }()
    
    func handleMore() {
        settingsLauncher.showSettings()
      
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    
    func showControllerForSetting(setting: Setting) {
        
        if setting.name == .Exit {
            handleLogout()
        } else if setting.name == .Settings {
            let profileViewController = ProfileViewController()
            profileViewController.view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            profileViewController.navigationItem.title = setting.name.rawValue
            presentViewController(profileViewController, animated: true, completion: nil)
        } else {
            let dummySettingsViewController = UIViewController()
            dummySettingsViewController.view.backgroundColor = UIColor.whiteColor()
            dummySettingsViewController.navigationItem.title = setting.name.rawValue
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            navigationController?.pushViewController(dummySettingsViewController, animated: true)
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    private func attemptReloadTable() {
        self.timer?.invalidate()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: NSTimer?

    func handleReloadTable() {
        self.tasks = Array(self.taskDictionary.values)
        self.tasks.sortInPlace({ (task1, task2) -> Bool in
            return task1.timestamp?.intValue > task2.timestamp?.intValue
        })
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
        
    }
    
    

    
    func checkIfUserIsLoggedIn() {
        let digits = Digits.sharedInstance()
        let digitsUID = digits.session()?.userID
        
        if digitsUID == nil {
            performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
        } else {
           checkUserInBase()
          
        }
    }
    

    func fetchUserAndSetupNavBarTitle() {
        tasks.removeAll()
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
        observeUserMessages()
        
    }
    
    
    func observeUserMessages() {
        guard let uid = Digits.sharedInstance().session()!.userID else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-tasks").child(uid)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let taskId = snapshot.key
           
            let taskReference = FIRDatabase.database().reference().child("tasks").child(taskId)
            
            taskReference.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    
                    
                    let task = Task()
                    task.setValuesForKeysWithDictionary(dictionary)
                    
                    let status = snapshot.value!["status"] as? String
                    if status == "Сдано" {
                        print("Задача сдана")
                    } else {
                         self.tasks.append(task)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    }
                   
                   
                    
                    
                   
                }
                
                }, withCancelBlock: nil)
            
            
            }, withCancelBlock: nil)
        
        
        
    }
    
 
    func observeTasks() {
        let digits = Digits.sharedInstance()
        guard let digitsUid = digits.session()!.userID else {
            //for some reason userID is nill
            return
        }
        
        let ref = FIRDatabase.database().reference().child("tasks")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let task = Task()
                task.setValuesForKeysWithDictionary(dictionary)

                if let toId = task.toId {
                    self.taskDictionary[toId] = task
                    self.tasks = Array(self.taskDictionary.values)
                    self.tasks.sortInPlace({ (task1, task2) -> Bool in
                        return task1.timestamp?.intValue > task2.timestamp?.intValue
                
                    })
                    
                }
                
                    dispatch_async(dispatch_get_main_queue(), {
                     self.tableView.reloadData()
                    })
                }
           
            }, withCancelBlock: nil)
        
    }
    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
        
       let task = tasks[indexPath.row]
        cell.textLabel?.text = task.text
        cell.detailTextLabel?.text = task.status
        cell.timeLabel.text = String(task.price!)
        cell.notificationsLabel.hidden = true
        
        let ref = FIRDatabase.database().reference().child("tasks").child(task.taskId!).child("messages")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let status = snapshot.value!["status"] as? String
            if status == "toClient" {
                cell.notificationsLabel.hidden = false
                print("Есть новые сообщения")
            }
            }, withCancelBlock: nil)
        
       if let taskImageUrl = task.imageUrl {
         cell.taskImageView.loadImageUsingCashWithUrlString(taskImageUrl)
        
//        let url = NSURL(string: taskImageUrl)
//          NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
//            if error != nil {
//                print(error)
//                return
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                = UIImage(data: data!)
////                cell.imageView?.image = UIImage(data: data!)
//            })
//            
//            
//          }).resume()
        }
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let task = tasks[indexPath.row]
      
//        guard let fromId = task.fromId else {
//            return
//        }
//        
//        let ref = FIRDatabase.database().reference().child("tasks").child(fromId)
//        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//            
//            
//            guard let dictionary = snapshot.value as? [String: AnyObject] else {
//                return
//            }
//            
//            let user = User()
//            user.id = fromId
//            user.setValuesForKeysWithDictionary(dictionary)
//            self.showChatControllerForUser(task)
//            
//            
//            }, withCancelBlock: nil)
        
        showChatControllerForUser(task)
        
    }
    
    func handleLogout() {
        
        do {
            try Digits.sharedInstance().logOut()
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.tasksListController = self
        presentViewController(loginController, animated: true, completion: nil)
        
        
    }
    
    func showChatControllerForUser(task: Task) {
        let chatLogController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.task = task
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
    
    func openNewTaskView() {
        let newTaskController = NewTaskController()
        let navController = UINavigationController(rootViewController: newTaskController)
        presentViewController(navController, animated: true, completion: nil)

    }
    
    func checkUserInBase() {
        guard let userId = Digits.sharedInstance().session()?.userID else {
            return
        }
        
        let phone = Digits.sharedInstance().session()?.phoneNumber
        let email = Digits.sharedInstance().session()?.emailAddress
        
        let ref = FIRDatabase.database().reference()
        let clientsReference = ref.child("clients")
        
        clientsReference.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if snapshot.hasChild(userId) {
                print("Есть такой юзер")
                self.fetchUserAndSetupNavBarTitle()
            } else {
                print("Таких не знаем")
                
                let usersReference = ref.child("requests").child("clients").child(userId)
                let values: [String : String] = ["id": userId, "email": email!, "phone": phone!]
                
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                    
                })
                
                let newClientViewController = NewClientViewController()
                let navController = UINavigationController(rootViewController: newClientViewController)
                self.presentViewController(navController, animated: true, completion: nil)
                
            }
            
            }, withCancelBlock: nil)
    }
   
  
    
}

