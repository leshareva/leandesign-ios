import UIKit
import Firebase
import DigitsKit
import Swiftstraints
import DKImagePickerController

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let discriptionLabel: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.blackColor()
        tv.textAlignment = .Center
        return tv
    }()
    
    lazy var closeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "close")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelCancel)))
        imageView.userInteractionEnabled = true
        return imageView
    }()
    
    lazy var profilePic: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no-photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.userInteractionEnabled = true
        imageView.layer.cornerRadius = 38
        imageView.layer.masksToBounds = true
        return imageView
    }()
  
    
    let inputForName: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    let firstLabel: UITextView = {
        let tf = UITextView()
        tf.selectable = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "Компания"
        tf.font = UIFont.systemFontOfSize(16)
        return tf
    }()
    
    let firstField: UITextView = {
        let tf = UITextView()
        tf.selectable = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFontOfSize(16)
        return tf
    }()
    
    let firstSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        setupInputsForLogin()
        loadUserInfo()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }
    
    func loadUserInfo() {
        let userId = Digits.sharedInstance().session()?.userID
        let ref = FIRDatabase.database().reference().child("clients").child(userId!)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            self.discriptionLabel.text = snapshot.value!["name"] as? String
            self.firstField.text = snapshot.value!["company"] as? String
            let profileImageUrl = snapshot.value!["imageUrl"] as? String
               self.profilePic.loadImageUsingCashWithUrlString(profileImageUrl!)
       
            }, withCancelBlock: nil)
    }
    
    
    
    func handelCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func setupInputsForLogin() {
        
        view.addSubview(discriptionLabel)
        view.addSubview(profilePic)
        view.addSubview(inputForName)
        view.addSubview(closeButton)
        
        view.addConstraints("V:|-20-[\(closeButton)]")
        view.addConstraints("H:|-8-[\(closeButton)]")
        
        view.addConstraints("V:|-60-[\(profilePic)][\(discriptionLabel)]-20-[\(inputForName)]")
        view.addConstraints("H:|-8-[\(inputForName)]-8-|")
        view.addConstraints(discriptionLabel.widthAnchor == view.widthAnchor, discriptionLabel.heightAnchor == 40,
                            inputForName.heightAnchor == 40, profilePic.centerXAnchor == view.centerXAnchor, profilePic.heightAnchor == 76, profilePic.widthAnchor == 76, closeButton.widthAnchor == 30, closeButton.heightAnchor == 30)
        
        inputForName.addSubview(firstLabel)
        inputForName.addSubview(firstField)
        
        inputForName.addConstraints("H:|-8-[\(firstLabel)][\(firstField)]|")
        inputForName.addConstraints(firstLabel.centerYAnchor == inputForName.centerYAnchor, firstLabel.heightAnchor == inputForName.heightAnchor, firstField.heightAnchor == inputForName.heightAnchor, firstField.centerYAnchor == inputForName.centerYAnchor, firstField.widthAnchor == 200 )
        

        
        
    }
    
        var assets: [DKAsset]?
    
    
        public func handleSelectProfileImageView() {
            let pickerController = DKImagePickerController()
    
    
            pickerController.didSelectAssets = { (assets: [DKAsset]) in

                for each in assets {
                    each.fetchOriginalImage(false) {
                        (image: UIImage?, info: [NSObject : AnyObject]?) in
                        let imageData: NSData = UIImagePNGRepresentation(image!)!
                        self.uploadToFirebaseStorageUsingImage(image!)
                    }
                }
    
            }
    
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageName = NSUUID().UUIDString
        print(imageName)
        let ref = FIRStorage.storage().reference().child("user-image").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Faild upload image:", error)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.sendMessageWithImageUrl(imageUrl, image: image)
                }
                
                
            })
        }
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        let userId = Digits.sharedInstance().session()?.userID
        let ref = FIRDatabase.database().reference().child("clients").child(userId!)
        var values: [String: AnyObject] = ["imageUrl": imageUrl]

        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }

        }
    
    }
    
    
}