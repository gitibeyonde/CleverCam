//
//  LiveViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 18/10/21.
//

import UIKit

class LiveViewController: UIViewController {

    @IBOutlet weak var video: UIImageView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    public static var uuid: String = ""
    static var stream: MJPEGStreamLib!
    static var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading live view for ", LiveViewController.uuid)
        
        //heading.text = "    Live " + ApiContext.shared.getDeviceName(uuid: LiveViewController.uuid)
        
        self.progressIndicator.startAnimating()
        HttpRequest.checkLocalURL(self, uuid: LiveViewController.uuid ) { (localUrl) in
            print("Local URL=", localUrl)
            if localUrl == "" {
                HttpRequest.getRemoteURL(self, uuid: LiveViewController.uuid ) { (remoteUrl) in
                    print(remoteUrl)
                    LiveViewController.url=remoteUrl
                    self.streamLive()
                }
            }
            else {
                LiveViewController.url = localUrl
                self.streamLive()
            }
            
        }
    }
    

    @IBAction func reload(_ sender: Any) {
        self.streamLive()
    }
    
    public func streamLive()->Void {
        print("Live view rcvd url ", LiveViewController.url!)
        let urlComponent2 = URLComponents(string: LiveViewController.url!)
        
        // Set the ImageView to the stream object
        LiveViewController.stream = MJPEGStreamLib(imageView: self.video)
        // Start Loading Indicator
        LiveViewController.stream.didStartLoading = { [unowned self] in
            self.progressIndicator.startAnimating()
        }
        // Stop Loading Indicator
        LiveViewController.stream.didFinishLoading = { [unowned self] in
            self.progressIndicator.stopAnimating()
        }
        
        LiveViewController.stream.contentURL = urlComponent2!.url
        LiveViewController.stream.play() // Play the stream
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Live view viewDidDisappear")
        LiveViewController.stream.stop()
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        print("Live myUnwindAction")
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
            let alert = UIAlertController(title: "Ops", message: "Unable to get live feed, retry...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
