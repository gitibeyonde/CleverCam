//
//  RegisterViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 13/10/21.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var repeatpass: UITextField!
    @IBOutlet var registerButton: UIButton!
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.delegate = self
        username.tag = 1
        email.delegate = self
        email.tag = 2
        phone.delegate = self
        phone.tag = 3
        password.delegate = self
        password.tag = 4
        repeatpass.delegate = self
        repeatpass.tag = 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            username.resignFirstResponder()
            email.becomeFirstResponder()
        }
        else if textField.tag == 2  {
            email.resignFirstResponder()
            phone.becomeFirstResponder()
        }
        else if textField.tag == 3  {
            phone.resignFirstResponder()
            password.becomeFirstResponder()
        }
        else if textField.tag == 4  {
            password.resignFirstResponder()
            repeatpass.becomeFirstResponder()
        }
        else  {
            repeatpass.resignFirstResponder()
            registerButton.becomeFirstResponder()
        }
      return false
   }

    @IBAction func registerButtonPress(_ sender: UIButton) {
        print(username.text!)
        print(password.text!)
        if username.text!.count < 5
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid username with at least 5 characters.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if !username.text!.isAlphanumeric
        {
            let alert = UIAlertController(title: "Alert!", message: "Username should only contain alphabets and numbers.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !email.text!.isValidEmail
        {
            let alert = UIAlertController(title: "Alert!", message: "Invalid email.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if phone.text!.count < 9 || !phone.text!.isValidPhone
        {
            let alert = UIAlertController(title: "Alert!", message: "Invalid phone number.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if password.text!.count < 6 || password.text!.count > 20
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter Password with 6-20 characters.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !password.text!.isValidPassword
        {
            let alert = UIAlertController(title: "Alert!", message: "Please enter alphabets, digits and any of -_;.:#+*?=!$%/()@.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if password.text! !=  repeatpass.text!
        {
            let alert = UIAlertController(title: "Alert!", message: "Password and Repeat password do not match.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            HttpRequest.register(self, username: username.text!, email: email.text!, phone: phone.text!, password: password.text!) { (output) in
                DispatchQueue.main.async {
                    if output.contains("Success"){
                        print("Login Successful")
                        Users.setUserName(object: self.username.text!)
                        Users.setPassword(object: self.password.text!)
                        Users.setLoginStatus(object: "true")
                        
                        if Users.getFCMtoken() != ""
                        {
                            HttpRequest.sendFCMToken(self, strToken: Users.getFCMtoken()) { (output) in
                                print("FCM token sent successfully to server.")
                            }
                        }
                        let alert = UIAlertController(title: "Registration Successful", message: "Validate your email id !", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        self.performSegue(withIdentifier: "ShowLogin", sender: nil)
                    }
                    else {
                        let alert = UIAlertController(title: "Registration Failed", message: output, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    

}


extension RegisterViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$").evaluate(with: self)
    }
    var isValidPhone: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[0-9+ ]{10,}").evaluate(with: self)
    }
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var isValidPassword: Bool {
            do {
                let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
                if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){

                    if(self.count>=6 && self.count<=20){
                        return true
                    }else{
                        return false
                    }
                }else{
                    return false
                }
            } catch {
                return false
            }
        }
}
