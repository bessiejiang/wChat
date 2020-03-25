//
//  FinishRegistrationViewController.swift
//  wChat
//
//  Created by Kim Wang on 3/23/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit
import ProgressHUD

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
        print(email, password)

        // Do any additional setup after loading the view.
    }
    


    // MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cleanTextField()
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        ProgressHUD.show("Registering")
        
        if nameTextField.text != "" && surnameTextField.text != "" && countryTextField.text != "" && cityTextField.text != "" && phoneTextField.text != "" {
            FUser.registerUserWith(email: email!, password: password!, firstName: nameTextField.text!, lastName: surnameTextField.text!) { (error) in
                if error != nil {
                    ProgressHUD.dismiss()
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                self.registerUser()
            }
                
        } else {
            ProgressHUD.showError("All fields are required")
        }
        
    }
    
    //MARK: helpers
    func registerUser() {
        let fullName = nameTextField.text! + " " + surnameTextField.text!
        
        //have a temp dict to save users, init a hashmap to store. type: string:any
        var tempDictionary : Dictionary = [kFIRSTNAME: nameTextField.text!, kLASTNAME : surnameTextField.text!, kFULLNAME : fullName, kCOUNTRY : countryTextField.text!, kCITY : cityTextField.text!, kPHONE : phoneTextField.text!] as [String : Any]
        if avatarImage == nil {
            imageFromInitials(firstName: nameTextField.text!, lastName: surnameTextField.text!) {
                (avatarInitials) in
                let avatarIMG = avatarInitials.jpegData(compressionQuality: 0.7)//0.1~1.0, convert image to data
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                tempDictionary[kAVATAR] = avatar
                //finishRegistration
                //inside callback closure, therefore we need to use a slef keyword
                self.finishRegistration(withValues: tempDictionary)
            }
        } else {
            let avatarData = avatarImage?.jpegData(compressionQuality: 0.7)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            tempDictionary[kAVATAR] = avatar

            //finishRegistration
            finishRegistration(withValues: tempDictionary)
        }
    }
    
    func finishRegistration(withValues: [String : Any]) {
        updateCurrentUserInFirestore(withValues: withValues) {
            (error) in
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error!.localizedDescription)
                }
                return
            }
            ProgressHUD.dismiss()
            //go to app
        }
    }
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    func cleanTextField() {
        nameTextField.text = ""
        surnameTextField.text = ""
        countryTextField.text = ""
        phoneTextField.text = ""
        cityTextField.text = ""
    }
}
