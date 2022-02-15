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
    @IBOutlet var header: UILabel!
    
    public static var uuid: String = ""
    var stream: MJPEGStreamLib!
    var url: String?
    var _isDirect:Bool = true
    var _isLocal:Bool = false
    var _isCloud:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading live view for ", LiveViewController.uuid)
        
        header.text = "    " + ApiContext.shared.getDeviceName(uuid: LiveViewController.uuid) + " Live"
        DispatchQueue.main.async {
            self.progressIndicator.startAnimating()
        }
        
        liveDirect(video: video)
        
        HttpRequest.checkLocalURL(self, uuid: LiveViewController.uuid ) { (localUrl) in
            print("Local URL=", localUrl)
            if localUrl == "" {
                HttpRequest.getRemoteURL(self, uuid: LiveViewController.uuid ) { (remoteUrl) in
                    print(remoteUrl)
                    self._isLocal = false
                    self._isCloud = true
                    self.url=remoteUrl
                    self.startMjpeg()
                }
            }
            else {
                print(localUrl)
                self._isLocal = true
                self._isDirect = false
                self._isCloud = false
                self.url = localUrl
                self.startMjpeg()
            }
        }
    }
    
    public func setStreamIndicator(){
        DispatchQueue.main.async {
            self.localStream.textColor = UIColor.lightGray
            self.cloudStream.textColor = UIColor.lightGray
            self.directStream.textColor = UIColor.lightGray
            if self._isDirect == true {
                self.directStream.textColor = UIColor.green
            }
            if self._isLocal == true  {
                self.localStream.textColor = UIColor.green
            }
            if self._isCloud == true {
                self.cloudStream.textColor = UIColor.green
            }
            self.progressIndicator.stopAnimating()
        }
    }
    
    func liveDirect(video: UIImageView){
        DispatchQueue.global().async {
            var _peer_host: String = ""
            var _peer_port: UInt16 = 1
            var _my_host: String = ""
            var _my_port: UInt16 = 1
            var _my_uuid: String = ""
            var peer:Peer = Peer()
            var broker:Broker = Broker()
            var initp2p:Bool = false
            var first: Bool = true
            
            let my_uuid: String = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID().uuidString
            let vuuid: [String] = my_uuid.components(separatedBy: "-")
            print("My uuid=", vuuid[4])
            _my_uuid = vuuid[4]
                
            _my_host = IpUtils.getMyIPAddresses()
            _my_port = IpUtils.getMyPort()
            
            while(self._isDirect == true && self._isLocal == false){
                while(initp2p == false){
                    print("My host = \(_my_host), My Port=\(_my_port)")
                    
                    broker = Broker(my_host: _my_host, my_port: _my_port)
                    broker.start()
                    
                    if (!broker.register(my_uuid: _my_uuid, my_host: _my_host, my_port: _my_port)){
                        continue
                    }
                    let pa = broker.getPeerAddress(device_uuid: LiveViewController.uuid)
                    if (pa.1 > 0) {
                        _peer_host = pa.0
                        _peer_port = pa.1
                    }
                    else {
                        continue
                    }
                    initp2p = true
                }
                
                broker.cancel()
                
                print("-----------------------------------------------------")
                
                var errors: Int = 0
                peer  = Peer(peer_host: _peer_host, peer_port: _peer_port, my_host: _my_host, my_port: _my_port)
                peer.start()
                
                    
                while(self._isDirect == true && self._isLocal == false){
                    let image:Data = peer.requestDHINJPeer(device_uuid: LiveViewController.uuid)
                    if (image.isEmpty){
                        errors += 1
                        if first {
                            initp2p = false
                            break
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            UIView.transition(with: self.video,
                                              duration: 0.2,
                                              options: .transitionCrossDissolve,
                                              animations: {
                                                video.image =  UIImage(data: image)
                                   }, completion: nil)
                            //self.video.image =
                            first = false
                            self.stopMjpeg()
                        }
                        errors = 0
                    }
                    if (errors > 100){
                        break
                    }
                    self.setStreamIndicator()
                }
                peer.cancel()
            }//while
            NSLog("Exiting Direct")
        }//async
    }
    
    public func startMjpeg()->Void {
        if (_isCloud == true || _isLocal == true) {
            self.setStreamIndicator()
            NSLog("Live view rcvd url \( self.url!)")
            let urlComponent2 = URLComponents(string: self.url!)
            
            // Set the ImageView to the stream object
            self.stream = MJPEGStreamLib(imageView: self.video)
            
            self.stream.contentURL = urlComponent2!.url
            self.stream.play() // Play the stream
        }
    }
    
    public func stopMjpeg(){
        _isCloud = false
        if (self.stream != nil ){
            self.stream.stop()
        }
    }
    
    @IBAction func imageTap(_ sender: Any) {
        if (_isCloud == true || _isLocal == true) {
            self.stream.stop()
            NSLog("Refreshing stream")
            self.startMjpeg() // Play the stream
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NSLog("Live view viewDidDisappear")
        self._isDirect = false
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
