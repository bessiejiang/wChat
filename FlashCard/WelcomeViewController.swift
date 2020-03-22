//
//  WelcomeViewController.swift
//  FlashCard
//
//  Created by Kim Wang on 3/22/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login")
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        print("register")

    }


    
    @IBAction func backgroundTap(_ sender: Any) {
        print("dismiss")

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
