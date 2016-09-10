import UIKit
import Firebase
import DigitsKit
import Swiftstraints
import DKImagePickerController

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let discriptionLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Лучший клиент"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.whiteColor()
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
    
    let profilePic: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "no-photo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .ScaleAspectFill
        //        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        iv.userInteractionEnabled = true
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
        tf.text = "Имя"
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
    
    let firstSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let secondLabel: UITextView = {
        let tf = UITextView()
        tf.selectable = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "Компания"
        tf.font = UIFont.systemFontOfSize(16)
        return tf
    }()
    
    let secondTextField: UITextView = {
        let tf = UITextView()
        tf.selectable = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFontOfSize(16)
        return tf
    }()
    
    let secondSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let thirdLabel: UITextView = {
        let tf = UITextView()
        tf.selectable = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "Город"
        tf.font = UIFont.systemFontOfSize(16)
        return tf
    }()
    
    let thirdTextField: UITextView = {
        let tf = UITextView()
        tf.selectable = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFontOfSize(16)
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .Plain, target: self, action: #selector(handelCancel))
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Редактировать", style: .Plain, target: self, action: #selector(editInfo));
        setupInputsForLogin()
    }
    
    func editInfo() {
        
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
                            inputForName.heightAnchor == 140, profilePic.centerXAnchor == view.centerXAnchor, profilePic.heightAnchor == 77, profilePic.widthAnchor == 77, closeButton.widthAnchor == 30, closeButton.heightAnchor == 30)
        
        inputForName.addSubview(nameTextLabel)
        inputForName.addSubview(nameTextField)
        inputForName.addSubview(firstSeparator)
        
        
        inputForName.addConstraints("H:|-6-[\(nameTextLabel)]-6-[\(nameTextField)]|")
        inputForName.addConstraints("V:|[\(nameTextLabel)]|","V:|[\(nameTextField)]|")
        inputForName.addConstraints(nameTextLabel.widthAnchor == 100, nameTextLabel.heightAnchor == inputForName.heightAnchor / 3, nameTextField.heightAnchor == inputForName.heightAnchor / 3)
        
        firstSeparator.topAnchor.constraintEqualToAnchor(nameTextLabel.bottomAnchor).active = true
        firstSeparator.leftAnchor.constraintEqualToAnchor(inputForName.leftAnchor).active = true
        firstSeparator.rightAnchor.constraintEqualToAnchor(inputForName.rightAnchor).active = true
        firstSeparator.heightAnchor.constraintEqualToConstant(1).active = true
        
        
        inputForName.addSubview(secondLabel)
        inputForName.addSubview(secondTextField)
        inputForName.addSubview(secondSeparator)
        
        
        inputForName.addConstraints("H:|-6-[\(secondLabel)]-6-[\(secondTextField)]|")
        secondLabel.topAnchor.constraintEqualToAnchor(firstSeparator.bottomAnchor).active = true
        secondTextField.topAnchor.constraintEqualToAnchor(firstSeparator.bottomAnchor).active = true
        inputForName.addConstraints(secondLabel.heightAnchor == inputForName.heightAnchor / 3, secondLabel.widthAnchor == 100, secondTextField.heightAnchor == inputForName.heightAnchor / 3)
        
        secondSeparator.topAnchor.constraintEqualToAnchor(secondLabel.bottomAnchor).active = true
        secondSeparator.leftAnchor.constraintEqualToAnchor(inputForName.leftAnchor).active = true
        secondSeparator.rightAnchor.constraintEqualToAnchor(inputForName.rightAnchor).active = true
        secondSeparator.heightAnchor.constraintEqualToConstant(1).active = true
        
        inputForName.addSubview(thirdLabel)
        inputForName.addSubview(thirdTextField)
        
        inputForName.addConstraints("H:|-6-[\(thirdLabel)]-6-[\(thirdTextField)]|")
        thirdLabel.topAnchor.constraintEqualToAnchor(secondSeparator.bottomAnchor).active = true
        thirdTextField.topAnchor.constraintEqualToAnchor(secondSeparator.bottomAnchor).active = true
        inputForName.addConstraints(thirdLabel.heightAnchor == inputForName.heightAnchor / 3, thirdLabel.widthAnchor == 100, thirdTextField.heightAnchor == inputForName.heightAnchor / 3)
        

        
        
    }
    
    //    var assets: [DKAsset]?
    //
    //    public func handleSelectProfileImageView() {
    //        let pickerController = DKImagePickerController()
    //
    //
    //        pickerController.didSelectAssets = { (assets: [DKAsset]) in
    //            print("didSelectAssets")
    //            print(assets)
    //
    //            for each in assets {
    //                each.fetchOriginalImage(false) {
    //                    (image: UIImage?, info: [NSObject : AnyObject]?) in
    //                    let imageData: NSData = UIImagePNGRepresentation(image!)!
    //                    self.uploadToFirebaseStorageUsingImage(image!)
    //                }
    //            }
    //
    //        }
    //
    //        self.presentViewController(pickerController, animated: true, completion: nil)
    //    }
    
}