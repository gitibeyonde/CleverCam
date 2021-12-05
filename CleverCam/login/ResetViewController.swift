//
//  ResetViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 23/10/21.
//

import UIKit

class ResetViewController: UIViewController {

    @IBOutlet var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetAction(_ sender: Any) {
        if !email.text!.isValidEmail
        {
            let alert = UIAlertController(title: "Alert!", message: "Invalid email.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            HttpRequest.reset(self, user_email: email.text!) { (output) in
                print(output)
                DispatchQueue.main.async() {
                    let alert = UIAlertController(title: "Ops", message:output, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
}




extension ResetViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
