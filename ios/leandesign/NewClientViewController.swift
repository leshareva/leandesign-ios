import UIKit
import Firebase
import DigitsKit

class NewClientViewController: UIViewController {

    let discriptionLabel: UILabel = {
       let tv = UILabel()
        tv.text = "Расскажите о своей компании"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.whiteColor()
        return tv
    }()
    
    let profilePic: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "userpic")
        iv.translatesAutoresizingMaskIntoConstraints = false
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
    
    let nameTextField: UITextView = {
        let tf = UITextView()
        tf.selectable = true
        tf.text = "Имя"
        return tf
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 48, g: 140, b: 229)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .Plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить", style: .Plain, target: self, action: #selector(handleNewUser));
        
        view.addSubview(discriptionLabel)
        
      
        
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
    
    func handleNewUser() {
        
    }
    
    func setupInputsForLogin() {
        
        discriptionLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 60).active = true
        discriptionLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 8).active = true
        discriptionLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -8).active = true
        discriptionLabel.heightAnchor.constraintEqualToConstant(60).active = true
        
        view.addSubview(profilePic)
        profilePic.topAnchor.constraintEqualToAnchor(discriptionLabel.bottomAnchor, constant: 40).active = true
        profilePic.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profilePic.widthAnchor.constraintEqualToConstant(60).active = true
        profilePic.heightAnchor.constraintEqualToConstant(60).active = true
        
        view.addSubview(inputForName)
        inputForName.topAnchor.constraintEqualToAnchor(profilePic.bottomAnchor, constant: 40).active = true
        inputForName.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 8).active = true
        inputForName.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -8).active = true
        inputForName.heightAnchor.constraintEqualToConstant(40).active = true
        
        inputForName.addSubview(nameTextField)
        nameTextField.centerYAnchor.constraintEqualToAnchor(inputForName.centerYAnchor).active = true
        nameTextField.leftAnchor.constraintEqualToAnchor(inputForName.leftAnchor, constant: 8).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -8).active = true
        nameTextField.heightAnchor.constraintEqualToConstant(40).active = true
        
        
    }

}
