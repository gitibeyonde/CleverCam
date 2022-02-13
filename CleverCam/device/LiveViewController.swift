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
    var _runDirect:Bool = true
    var _isDirectRunning:Bool = false
    public static var refresh = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading live view for ", LiveViewController.uuid)
        
        header.text = "    " + ApiContext.shared.getDeviceName(uuid: LiveViewController.uuid) + " Live"
        DispatchQueue.main.async {
            self.progressIndicator.startAnimating()
        }
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
        var _peer_host: String = ""
        var _peer_port: UInt16 = 1
        var _my_host: String = ""
        var _my_port: UInt16 = 1
        var _my_uuid: String = ""
        
        let my_uuid: String = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID().uuidString
        let vuuid: [String] = my_uuid.components(separatedBy: "-")
        print("My uuid=", vuuid[4])
        _my_uuid = vuuid[4]
    
        var errors: Int = 0
        print("-----------------------------------------------------")
        while(self._runDirect == true){
            _my_host = IpUtils.getMyIPAddresses()
            _my_port = IpUtils.getMyPort()
            print("My host = \(_my_host), My Port=\(_my_port)")
            
            let broker = Broker(my_host: _my_host, my_port: _my_port)
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
            
            errors = 0
            broker.cancel()
            
            let peer: Peer  = Peer(peer_host: _peer_host, peer_port: _peer_port, my_host: _my_host, my_port: _my_port, device_uuid: LiveViewController.uuid)
            peer.start()
            while(self._runDirect == true){
                let image:Data = peer.requestDHINJPeer()
                if (image.isEmpty){
                    errors += 1
                }
                else {
                    DispatchQueue.main.async {
                        self.progressIndicator.stopAnimating()
                        self.video.image = UIImage(data: image)
                        self._isDirectRunning = true
                    }
                    errors = 0
                }
                if (errors > 20){
                    break
                }
            }
            peer.cancel()
        }
       
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
