//
//  LiveViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 18/10/21.
//

import UIKit

class LiveViewController: UIViewController {

    @IBOutlet var deviceName: UILabel!
    @IBOutlet var video: UIImageView!
    
    public static var uuid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading live view for ", LiveViewController.uuid)
        
        let url:String = HttpRequest.getStreamUrl(self, uuid: LiveViewController.uuid)
        
        print("Live view rcvd url ", url)
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


extension LiveViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "Unable to get live feed...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
