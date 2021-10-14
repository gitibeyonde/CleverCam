//
//  ViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 13/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Showing root View Controller")
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        
        if Users.getLoginStatus() == "true"
        {
            print("User logged in")
        }
        else {
            self.performSegue(withIdentifier: "ShowLogin", sender: nil)
            print("Perform Segue")
        }
    }
    
}

