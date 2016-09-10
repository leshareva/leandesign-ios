import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    
    var task: Task? {
        didSet {
            
            setupNameAndProfileImage()
            
            if let seconds = task?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.stringFromDate(timestampDate)
            }
        }
    }
  
    private func setupNameAndProfileImage() {
        if let Id = task?.taskId {
            let ref = FIRDatabase.database().reference().child("tasks").child(Id)
            ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["text"] as? String
                    
                    if let taskImageUrl = dictionary["taskImageUrl"] as? String {
                        self.taskImageView.loadImageUsingCashWithUrlString(taskImageUrl)
                        
                    }
                }
            }, withCancelBlock: nil)
        }
    }

    let taskImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "userpic")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .ScaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = .Right
        return label
    }()
    
    let notificationsLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 48, g: 140, b: 229)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let taskTextView: UITextView = {
       let tv = UITextView()
        tv.text = "Очень много текста должно быть в одном поле. И желательно бы все это видеть"
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
//        addSubview(taskImageView)
       
        
//        taskImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
//        taskImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
//        taskImageView.widthAnchor.constraintEqualToConstant(40).active = true
//        taskImageView.heightAnchor.constraintEqualToConstant(40).active = true
        
        
        addSubview(timeLabel)
        timeLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8).active = true
        timeLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 12).active = true
        timeLabel.widthAnchor.constraintEqualToConstant(60).active = true
        timeLabel.heightAnchor.constraintEqualToConstant(20).active = true
        
        addSubview(notificationsLabel)
        notificationsLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -16).active = true
        notificationsLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8).active = true
        notificationsLabel.widthAnchor.constraintEqualToConstant(10).active = true
        notificationsLabel.heightAnchor.constraintEqualToConstant(10).active = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 16, y: textLabel!.frame.origin.y - 2, width: self.frame.width - 44, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 16, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        textLabel?.numberOfLines = 2
        textLabel?.font = UIFont.systemFontOfSize(16)
        detailTextLabel?.textColor = UIColor(r: 230, g: 230, b: 230)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}