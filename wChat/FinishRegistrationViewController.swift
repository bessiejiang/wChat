//
//  FinishRegistrationViewController.swift
//  wChat
//
//  Created by Kim Wang on 3/23/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit

class FinishRegistrationViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var email: String! //not optional
    var password: String!
    var avatarImage: UIImage?// is optional, users may or may not put image
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    // MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
    }
}
