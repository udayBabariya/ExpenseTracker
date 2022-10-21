//
//  LoginViewController.swift
//  ExpenseTracker
//
//  Created by Uday on 21/10/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let defaultUsername = "user"
    let defaultPassword = "password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userNameTextField.text = "user"
//        passwordTextField.text = "password"
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let userName = userNameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if !isValidParams(userName: userName, password: password) {return}
        if userName == defaultUsername && password == defaultPassword {
            //Login Successfull
            Utility.setUserLoginStatus(true)
            Utility.setRootViewController()
        }else{
            showAlert("Incorrect UserName or Password")
        }
    }
    
    //Error handling
    func isValidParams(userName: String, password: String) -> Bool {
        
        if userName.isEmpty && password.isEmpty {
            showAlert("Please enter username and password")
            return false
        }
        if userName.isEmpty {
            showAlert("Please enter username")
            return false
        }
        
        if password.isEmpty {
            showAlert("Please enter password")
            return false
        }
        return true
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        showAlert("Hint \n username : \(defaultUsername) \n password: \(defaultPassword)")
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
        
    }
}

