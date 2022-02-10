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
    @IBOutlet var live: UIImageView!
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
    public static var history_timer = Timer()
    var _runDirect:Bool = true
    var _isDirectRunning:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading bell alert view controller ")
        NotificationViewController.showBell = false
        DeviceViewController.showBell = false
        BellAlertViewController.images = [ self.img0, self.img1, self.img2, self.img3, self.img4, self.img5, self.img6, self.img7, self.img8, self.img9 ]
        DispatchQueue.main.async() {
            self.liveProgress.startAnimating()
        }
        Thread.detachNewThreadSelector(#selector(liveDirect), toTarget: self, with: nil)
        
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
                                let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped))
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
        HttpRequest.checkLocalURL(self, uuid: LiveViewController.uuid ) { (localUrl) in
            print("Local URL=", localUrl)
            if localUrl == "" {
                HttpRequest.getRemoteURL(self, uuid: LiveViewController.uuid ) { (remoteUrl) in
                    print(remoteUrl)
                    if (self._isDirectRunning == false){
                        self.url=remoteUrl
                        self.streamLive()
                    }
                }
            }
            else {
                print(localUrl)
                self.url = localUrl
                self.streamLive()
            }
            DispatchQueue.main.async() {
                self.liveProgress.stopAnimating()
            }
        }
        
        
        self.navBack.title = "at " + BellAlertViewController.datetime
        //animate history
        BellAlertViewController.history_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
    }
    
    
    @objc private func liveDirect(){
        let my_uuid: String = UIDevice.current.identifierForVendor?.uuidString ?? NSUUID().uuidString
        let vuuid: [String] = my_uuid.components(separatedBy: "-")
        print("My uuid=", vuuid[4])
    
        let broker: NetUtils = NetUtils(device_uuid: LiveViewController.uuid)
        
        var result: Bool = false
        while (result == false && self._runDirect == true){
            result = broker.isReady()
            sleep(1)
        }
        
        result = false
        while (result == false && self._runDirect == true){
            result = broker.register(my_uuid: vuuid[4])
            sleep(2)
        }
        
        result = false
        while (result == false && self._runDirect == true){
            result = broker.getPeerAddress()
            sleep(2)
        }
        broker.cancelBroker()
        
        let peer: NetUtils  = NetUtils()
        print("-----------------------------------------------------")
        DispatchQueue.main.async {
            self.liveProgress.stopAnimating()
        }
        while(self._runDirect == true){
            let image:Data = peer.getImageFromPeer()
            if (image.isEmpty){
                continue
            }
            DispatchQueue.main.async {
                self.live.image = UIImage(data: image)
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
        self.stream = MJPEGStreamLib(imageView: self.live)
        
        self.stream.contentURL = urlComponent2!.url
        self.stream.play() // Play the stream
    }

    @IBAction func reload(_ sender: Any) {
        self.streamLive()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Bell ALert view viewDidDisappear")
        self._runDirect = false
        if (self.stream != nil ){
            self.stream.stop()
        }
        BellAlertViewController.history_timer.invalidate()
    }
    
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        print("Image taped", sender.view!.tag)
        BellAlertViewController.history_timer .invalidate()
        counter = sender.view!.tag
        self.history.image = BellAlertViewController.images[counter].image
    }
    
    
    @objc func fireTimer() {
        counter+=1
        if counter > self.counterMax {
            counter=0;
        }
        DispatchQueue.main.async {
            self.history.image = BellAlertViewController.images[self.counter].image
        }
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
