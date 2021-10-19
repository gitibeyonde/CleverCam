//
//  LiveViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 18/10/21.
//

import UIKit

class LiveViewController: UIViewController {

    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var video: UIImageView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    public static var uuid: String = ""
    var stream: MJPEGStreamLib!
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading live view for ", LiveViewController.uuid)
        
        let url:String = HttpRequest.getStreamUrl(self, uuid: LiveViewController.uuid)
        print("Live view rcvd url ", url)
        let urlComponent2 = URLComponents(string: url)
        
        // Set the ImageView to the stream object
        stream = MJPEGStreamLib(imageView: video)
        // Start Loading Indicator
        stream.didStartLoading = { [unowned self] in
            self.progressIndicator.startAnimating()
            self.progressIndicator.isHidden = false
        }
        // Stop Loading Indicator
        stream.didFinishLoading = { [unowned self] in
            self.progressIndicator.stopAnimating()
            self.progressIndicator.isHidden = true
        }
        
        stream.contentURL = urlComponent2!.url
        stream.play() // Play the stream
        
        deviceName.text = "Live view \(LiveViewController.uuid)"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Make the Status Bar Light/Dark Content for this View
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }

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
