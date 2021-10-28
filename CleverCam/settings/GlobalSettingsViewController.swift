//
//  GlobalSettingsViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 18/10/21.
//

import UIKit

class GlobalSettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginReset(_ sender: Any) {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Logged Out", message: "You are being logged out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        Users.setLoginStatus(object: "false")
        
        self.performSegue(withIdentifier: "ShowLogin", sender: nil)
    }
}
