//
//  BellAlertViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 20/10/21.
//

import UIKit

class BellAlertViewController: UIViewController {
    
    @IBOutlet weak var navBack: UINavigationItem!
    
    @IBOutlet var history: UIImageView!
    @IBOutlet var video: UIImageView!
    @IBOutlet var progressHistory: UIActivityIndicatorView!
    @IBOutlet var liveProgress: UIActivityIndicatorView!
    
    @IBOutlet var img0: UIImageView!
    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img3: UIImageView!
    @IBOutlet var img4: UIImageView!
    @IBOutlet var img5: UIImageView!
    @IBOutlet var img6: UIImageView!
    @IBOutlet var img7: UIImageView!
    @IBOutlet var img8: UIImageView!
    @IBOutlet var img9: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    public static var uuid: String = ""
    public static var datetime: String = ""
    public static var images : Array<UIImageView> = []
    
    var stream: MJPEGStreamLib!
    var url: String?
    var counter: Int = 0
    var counterMax: Int = 0
    var videoRefreshCounter: Int = 0
    let videoRefreshMax: Int = 20
    private static var history_timer = Timer()
    var _isDirect:Bool = true
    var _isLocal:Bool = false
    var _isCloud:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading bell alert view controller ")
        NotificationViewController.showBell = false
        DeviceViewController.showBell = false
        BellAlertViewController.images = [ self.img0, self.img1, self.img2, self.img3, self.img4, self.img5, self.img6, self.img7, self.img8, self.img9 ]
        DispatchQueue.main.async() {
            self.liveProgress.startAnimating()
        }
        
        var initFirstImage = false
        HttpRequest.bellAlertDetails(self, uuid: BellAlertViewController.uuid, datetime: BellAlertViewController.datetime) { (notificationList) in
            print(notificationList.count)
            if (notificationList.count > 0 ) {
                self.counterMax = notificationList.count - 1
                for i in 0...self.counterMax {
                    let url_str = notificationList[i].url
                    let Url = URL(string: url_str)!
                    getData(from: Url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            print(response?.suggestedFilename ?? Url.lastPathComponent)
                            ApiContext.shared.addImage(url: url_str, data: data)
                            // always update the UI from the main thread
                            DispatchQueue.main.async() {
                                BellAlertViewController.images[i].image = UIImage(data: data)
                                let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.historyTap))
                                BellAlertViewController.images[i].addGestureRecognizer(gestureRecognizer)
                                BellAlertViewController.images[i].tag = i
                                if !initFirstImage {
                                    self.history.image = BellAlertViewController.images[i].image
                                    initFirstImage = true
                                    self.progressHistory.stopAnimating()
                                }
                            }
                       }
                }
            }
        }
        
        liveDirect(video: video)
        
        HttpRequest.checkLocalURL(self, uuid: BellAlertViewController.uuid ) { (localUrl) in
            print("Local URL=", localUrl)
            if localUrl == "" {
                HttpRequest.getRemoteURL(self, uuid: BellAlertViewController.uuid ) { (remoteUrl) in
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
        
        self.navBack.title = "at " + BellAlertViewController.datetime
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
                    let pa = broker.getPeerAddress(device_uuid: BellAlertViewController.uuid)
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
                    let image:Data = peer.requestDHINJPeer(device_uuid: BellAlertViewController.uuid)
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
                    //self.setStreamIndicator()
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
                //self.setStreamIndicator()
                NSLog("Live view rcvd url \( self.url!)")
                let urlComponent2 = URLComponents(string: self.url!)
                
                self.stream.contentURL = urlComponent2!.url
                self.stream.play() // Play the stream
            }
        }
    }
    
    public func stopMjpeg(){
        BellAlertViewController.history_timer.invalidate()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        NSLog("Live view viewDidDisappear")
        stopMjpeg()
        stopDirect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NSLog("Live view viewDidAppear")
        restartMjpeg()
        startDirect()
        BellAlertViewController.history_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func historyTap(_ sender: UITapGestureRecognizer) {
        print("Image taped", sender.view!.tag)
        BellAlertViewController.history_timer .invalidate()
        counter = sender.view!.tag
        self.history.image = BellAlertViewController.images[counter].image
    }
    
    
    @objc func fireTimer() {
        counter+=1
        videoRefreshCounter+=1
        if counter >= counterMax {
            counter=0;
        }
        if (videoRefreshCounter >= videoRefreshMax ) {
            restartMjpeg()
            videoRefreshCounter=0
        }
        DispatchQueue.main.async {
            self.history.image = BellAlertViewController.images[self.counter].image
        }
    }
    
    func isMjpeg() -> Bool {
        return (_isCloud == true || _isLocal == true) && self.stream != nil
    }
}


extension BellAlertViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "Unable to get live feed...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
