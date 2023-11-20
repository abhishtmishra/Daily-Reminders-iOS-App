//
//  reminderViewController.swift
//  abhisht_reminderApp
//
//  Created by manjit on 07/11/23.
//

import UIKit

class reminderViewController: UIViewController {

    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var bodyTextField : UITextView!
    @IBOutlet var date: UILabel!
    @IBOutlet weak var imageO: UIImageView!
    
    public var reminderTitle: String = ""
    public var reminderBody: String = ""
    public var reminderDate: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = reminderTitle
        bodyTextField.text = reminderBody
        date.text = reminderDate
        
        var imageArray: [UIImage] = [
        UIImage(named: "thumbs.jpg")!,
        UIImage(named: "chad.jpg")!
        ]
        imageO.animationImages = imageArray
        imageO.animationDuration = 2
        imageO.animationRepeatCount = 0
        
        imageO.startAnimating()
        

    }
    
    

}
