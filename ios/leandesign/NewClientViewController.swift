import UIKit
import Firebase
import DigitsKit
import Swiftstraints
import DKImagePickerController

class NewClientViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tasksListController: TasksListController?
    
    let discriptionLabel: UILabel = {
       let tv = UILabel()
        tv.text = "Привет! Если вы получили от нас секретное слово, введите его."
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.whiteColor()
        tv.textAlignment = .Center
        tv.numberOfLines = 3
        return tv
    }()
    
    let profilePic: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "no-photo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .ScaleAspectFill
        return iv
    }()
    
    let inputForName: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    let nameTextLabel: UITextView = {
        let tf = UITextView()
        tf.selectable = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "Промо-код"
        tf.font = UIFont.systemFontOfSize(16)
        return tf
    }()
    
    let nameTextField: UITextView = {
        let tf = UITextView()
        tf.selectable = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFontOfSize(16)
        return tf
    }()
    
    let labelComment: UILabel = {
        let tv = UILabel()
        tv.text = "Получить приглашение"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.whiteColor()
        tv.textAlignment = .Center
        tv.numberOfLines = 3
        return tv
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 48, g: 140, b: 229)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .Plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .Plain, target: self, action: #selector(checkPromo));
        

        
        setupInputsForLogin()
    }

    func handleLogout() {
        
        do {
            try Digits.sharedInstance().logOut()
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.newClientViewController = self
        presentViewController(loginController, animated: true, completion: nil)
        
        
    }
    
    func checkPromo() {
        
            guard let promoCode = nameTextField.text where !promoCode.isEmpty else {
                return
            }
        
        let ref = FIRDatabase.database().reference()
        ref.child("promocodes").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.hasChild(promoCode) {
                print("есть код")
                
                let phone = Digits.sharedInstance().session()?.phoneNumber
                let uid = Digits.sharedInstance().session()?.userID
                let values : [String: AnyObject] = ["phone": phone!, "promo": promoCode]
                
                ref.child("requests").child("clients").child(uid!).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error)
                        return
                    }
                })
                
//                ref.child("promocodes").child(promoCode).removeValue()
                self.tasksListController?.fetchUserAndSetupNavBarTitle()
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                print("нет такого кода")
            }
            
            }, withCancelBlock: nil)
    }
    
    
//    var secondLabelHeightAnchor: NSLayoutConstraint?
//    var secondTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsForLogin() {
        
        view.addSubview(discriptionLabel)
        view.addSubview(profilePic)
        view.addSubview(inputForName)
        view.addSubview(labelComment)
    

        view.addConstraints("V:|-80-[\(profilePic)][\(discriptionLabel)]-20-[\(inputForName)]-10-[\(labelComment)]")
        view.addConstraints("H:|-8-[\(inputForName)]-8-|")
        view.addConstraints("H:|-8-[\(labelComment)]-8-|")
        view.addConstraints(discriptionLabel.widthAnchor == view.widthAnchor, discriptionLabel.heightAnchor == 50,
            inputForName.heightAnchor == 40, profilePic.centerXAnchor == view.centerXAnchor, profilePic.heightAnchor == 77, profilePic.widthAnchor == 77, labelComment.heightAnchor == 40)
        
        
        inputForName.addSubview(nameTextLabel)
        inputForName.addSubview(nameTextField)
        
        inputForName.addConstraints("H:|-6-[\(nameTextLabel)]-6-[\(nameTextField)]|")
        inputForName.addConstraints("V:|[\(nameTextLabel)]|","V:|[\(nameTextField)]|")
        inputForName.addConstraints(nameTextLabel.widthAnchor == 100, nameTextLabel.heightAnchor == inputForName.heightAnchor, nameTextField.heightAnchor == inputForName.heightAnchor)
    
        
  
    }

    
}
