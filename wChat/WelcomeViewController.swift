//
//  WelcomeViewController.swift
//  FlashCard
//
//  Created by Kim Wang on 3/22/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
//        print("login")
        dismissKeyboard()
        if emailTextField.text != "" && passwordTextField.text != "" {
            logingUser()
        } else {
            ProgressHUD.showError("Email or password is missing!")
        }
        
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
//        print("register")
        dismissKeyboard()
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""{
            if passwordTextField.text == repeatPasswordTextField.text {
                registerUser()

            } else {
                ProgressHUD.showError("Passwords don't match!")

            }
            
            
            
        } else {
            ProgressHUD.showError("All fileds are required!")
        }
    }

    @IBAction func backgroundTap(_ sender: Any) {
//        print("dismiss")
        dismissKeyboard()
    }
    
    //MARK: helper functions
    func logingUser() {
//        print("loging in")
        ProgressHUD.show("Login...")
        //unwarpping here is safe becuase we check empty before
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)//unwrap safely and translate to human language
                return
            }
            self.goToApp()//in closure, need a self keyword
        }
    }
   
    func registerUser() {
        cleanTextField()
        dismissKeyboard()
        performSegue(withIdentifier: "welcomeToFinishReg", sender: self)
        //           print("registering")

    }
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    func cleanTextField() {
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    

    
    //MARK: goToApp:
    func goToApp() {//main storyboard has two parts, login part and 
        ProgressHUD.dismiss()
        cleanTextField()
        dismissKeyboard()
        
        print("show the app")
        //present app here:
    }

}
