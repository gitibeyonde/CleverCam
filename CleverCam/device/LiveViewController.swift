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
    @IBOutlet weak var header: UILabel!
    
    public static var uuid: String = ""
    var stream: MJPEGStreamLib!
    var url: String?
    var _isDirect:Bool = true
    var _isLocal:Bool = false
    var _isCloud:Bool = false
    private static var video_timer = Timer()

    
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
                            self._isCloud = false
                            self._isLocal = false
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
    
    public func stopDirect()->Void {
        self._isDirect = false
    }
    
    public func startDirect()->Void {
        if (self._isLocal == false){
            self._isDirect = true
            liveDirect(video: self.video)
        }
    }
    
    public func startMjpeg()->Void {
        DispatchQueue.main.async {
            self.stream = MJPEGStreamLib(imageView: self.video)
            if self.isMjpeg() {
                self.setStreamIndicator()
                NSLog("Live view rcvd url \( self.url!)")
                let urlComponent2 = URLComponents(string: self.url!)
                
                self.stream.contentURL = urlComponent2!.url
                self.stream.play() // Play the stream
            }
        }
    }
    
    public func stopMjpeg(){
        LiveViewController.video_timer.invalidate()
        if self.stream != nil {
            self.stream.stop()
        }
    }
    
    public func restartMjpeg(){
        if isMjpeg() {
            self.stream.stop()
            NSLog("Refreshing stream")
            self.startMjpeg() // Play the stream
        }
    }
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        restartMjpeg()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NSLog("Live view viewDidDisappear")
        stopMjpeg()
        stopDirect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NSLog("Live view viewDidAppear")
        restartMjpeg()
        startDirect()
        LiveViewController.video_timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func fireTimer() {
        NSLog("fireTimer")
        restartMjpeg()
    }
    
    func isMjpeg() -> Bool {
        return (_isCloud == true || _isLocal == true) && self.stream != nil
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
