//
//  LoginViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 13/10/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("LoginViewController loaded")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

            print("https://ping.ibeyonde.com/api/iot.php?view=login")
            print(base64LoginString);
            HttpRequest.login(self, url: "https://ping.ibeyonde.com/api/iot.php?view=login", base64LoginString: base64LoginString) { (output) in
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
    
    @IBAction func registerButtonPress(_ sender: Any) {
        print("Register button press loaded")
        self.performSegue(withIdentifier: "ShowRegister", sender: nil)
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
