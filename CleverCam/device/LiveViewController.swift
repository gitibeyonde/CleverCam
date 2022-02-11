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
    @IBOutlet weak var localStream: UILabel!
    @IBOutlet weak var cloudStream: UILabel!
    @IBOutlet weak var directStream: UILabel!
    
    public static var uuid: String = ""
    var stream: MJPEGStreamLib!
    var url: String?
    var _runDirect:Bool = true
    var _isDirectRunning:Bool = false
    public static var refresh = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading live view for ", LiveViewController.uuid)
        
        self.progressIndicator.startAnimating()
        Thread.detachNewThreadSelector(#selector(liveDirect), toTarget: self, with: nil)
        
        HttpRequest.checkLocalURL(self, uuid: LiveViewController.uuid ) { (localUrl) in
            print("Local URL=", localUrl)
            if localUrl == "" {
                HttpRequest.getRemoteURL(self, uuid: LiveViewController.uuid ) { (remoteUrl) in
                    print(remoteUrl)
                    if (self._isDirectRunning == false){
                        self.url=remoteUrl
                        self.streamLive()
                        DispatchQueue.main.async {
                            self.progressIndicator.stopAnimating()
                            self.cloudStream.textColor = UIColor.green
                            self.directStream.textColor = UIColor.lightGray
                        }
                    }
                }
            }
            else {
                print(localUrl)
                self.url = localUrl
                self.streamLive()
                DispatchQueue.main.async {
                    self.progressIndicator.stopAnimating()
                    self.localStream.textColor = UIColor.green
                    self.directStream.textColor = UIColor.lightGray
                }
                LiveViewController.refresh = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc private func liveDirect(){
        let my_uuid: String = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID().uuidString
        let vuuid: [String] = my_uuid.components(separatedBy: "-")
        print("My uuid=", vuuid[4])
    
        let broker: NetUtils = NetUtils(device_uuid: LiveViewController.uuid)
        
        var result: Bool = false
        while (result == false && self._runDirect == true){
            sleep(1)
            result = broker.isReady()
        }
        
        result = false
        while (result == false && self._runDirect == true){
            sleep(1)
            result = broker.register(my_uuid: vuuid[4])
        }
        
        result = false
        while (result == false && self._runDirect == true){
            result = broker.getPeerAddress()
            sleep(1)
        }
        result = broker.getPeerAddress()
        
        broker.cancelBroker()
        
        DispatchQueue.main.async {
            if (self._runDirect == false){
                self.directStream.textColor = UIColor.lightGray
            }
            else {
                self.progressIndicator.stopAnimating()
                self.directStream.textColor = UIColor.green
            }
        }
        
        let peer: NetUtils  = NetUtils()
        print("-----------------------------------------------------")
        while(self._runDirect == true){
            let image:Data = peer.getImageFromPeer()
            if (image.isEmpty){
                continue
            }
            DispatchQueue.main.async {
                self.video.image = UIImage(data: image)
                self._isDirectRunning = true
            }
        }
        peer.cancelPeer()
    }
    
    public func streamLive()->Void {
        self._runDirect = false
        print("Live view rcvd url ", self.url!)
        let urlComponent2 = URLComponents(string: self.url!)
        
        // Set the ImageView to the stream object
        self.stream = MJPEGStreamLib(imageView: self.video)
        
        self.stream.contentURL = urlComponent2!.url
        self.stream.play() // Play the stream
    }
    

    @IBAction func reload(_ sender: Any) {
        self.streamLive()
    }
    
    @objc func fireTimer() {
        self.streamLive()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Live view viewDidDisappear")
        self._runDirect = false
        if (self.stream != nil ){
            self.stream.stop()
        }
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
