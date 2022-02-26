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
    }

    override func viewDidAppear(_ animated: Bool) {
        if Users.getLoginStatus() == "true"
        {
            self.performSegue(withIdentifier: "ShowTab", sender: nil)
            NSLog("Perform Segue ShowDevice")
            
        }
        else {
            self.performSegue(withIdentifier: "ShowLogin", sender: nil)
            NSLog("Perform Segue ShowLogin")
        }
    }
    
    @IBAction func reOpen(_ sender: Any) {
        if Users.getLoginStatus() == "true"
        {
            self.performSegue(withIdentifier: "ShowTab", sender: nil)
            NSLog("Perform Segue ShowDevice")
            
        }
        else {
            self.performSegue(withIdentifier: "ShowLogin", sender: nil)
            NSLog("Perform Segue ShowLogin")
        }
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        NSLog("Main myUnwindAction")
    }
    
    
}

