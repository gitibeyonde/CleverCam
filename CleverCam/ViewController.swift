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
            print("Remember me true")
            self.performSegue(withIdentifier: "ShowTab", sender: nil)
            print("Perform Segue ShowDevice")
            
        }
        else {
            print("User logged in")
            self.performSegue(withIdentifier: "ShowLogin", sender: nil)
            print("Perform Segue ShowLogin")
        }
    }
    
    @IBAction func reOpen(_ sender: Any) {
        if Users.getLoginStatus() == "true"
        {
            print("Remember me true")
            self.performSegue(withIdentifier: "ShowTab", sender: nil)
            print("Perform Segue ShowDevice")
            
        }
        else {
            print("User logged in")
            self.performSegue(withIdentifier: "ShowLogin", sender: nil)
            print("Perform Segue ShowLogin")
        }
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        print("Main myUnwindAction")
    }
    
    
}

