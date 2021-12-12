//
//  LoginViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 13/10/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
   
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("LoginViewController loaded")
        username.delegate = self
        username.tag = 1
        password.delegate = self
        password.tag = 2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            username.resignFirstResponder()
            password.becomeFirstResponder()
        }
        else {
            password.resignFirstResponder()
            loginButton.becomeFirstResponder()
        }
      return false
   }
    
   @IBAction func passwordEyeEnabled(_ sender: UIButton) {
        password.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }

    @IBAction func loginButtonPress(_ sender: UIButton) {
        print(username.text ?? "noname")
        print(password.text ?? "nopass")
        if username.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid username.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if password.text == ""
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let loginString = String(format: "%@:%@", username.text!, password.text!)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()

            HttpRequest.login(self, base64LoginString: base64LoginString) { (output) in
                DispatchQueue.main.async {
                    if output.contains("Success"){
                        print("Login Successful")
                        Users.setUserName(object: self.username.text!)
                        Users.setPassword(object: self.password.text!)
                        Users.setLoginStatus(object: "true")
                        
                        if Users.getFCMtoken() != ""
                        {
                            HttpRequest.sendFCMToken(self, strToken: Users.getFCMtoken()) { (output) in
                                print("FCM token sent successfully to server.", output)
                            }
                        }
                        
                        self.performSegue(withIdentifier: "ShowDevice", sender: nil)
                    }
                    else {
                        let alert = UIAlertController(title: "Login Failed", message: "Please, try again !", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
}


extension LoginViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
