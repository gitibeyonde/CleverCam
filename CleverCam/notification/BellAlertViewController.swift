//
//  BellAlertViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 20/10/21.
//

import UIKit

class BellAlertViewController: UIViewController {
    
    @IBOutlet var name: UILabel!
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
    
    public static var uuid: String = ""
    public static var datetime: String = ""
    
    
    var stream: MJPEGStreamLib!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images = [ self.img0, self.img1, self.img2, self.img3, self.img4, self.img5, self.img6, self.img7, self.img8, self.img9 ]
        
        print("loading bell alert view controller ")
        var initFirstImage = false
        HttpRequest.bellAlertDetails(self, uuid: BellAlertViewController.uuid, datetime: BellAlertViewController.datetime) { (notificationList) in
            DispatchQueue.main.async {
                for i in 0...9 {
                    
                    let url_str = notificationList[i].url
                    let Url = URL(string: url_str)!
                    getData(from: Url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            print(response?.suggestedFilename ?? Url.lastPathComponent)
                            ApiContext.shared.addImage(url: url_str, data: data)
                            // always update the UI from the main thread
                            DispatchQueue.main.async() {
                                images[i]?.image = UIImage(data: data)
                                if !initFirstImage {
                                    self.history.image = UIImage(data: data)
                                    initFirstImage = true
                                }
                                self.progressHistory.stopAnimating()
                            }
                       }
                }
            }
        }
        
        //load live
        name.text = BellAlertViewController.uuid
        
        let url:String = HttpRequest.getStreamUrl(self, uuid: BellAlertViewController.uuid)
        print("Live view rcvd url ", url)
        let urlComponent = URLComponents(string: url)
        
        // Set the ImageView to the stream object
        stream = MJPEGStreamLib(imageView: live)
        // Start Loading Indicator
        stream.didStartLoading = { [unowned self] in
            self.liveProgress.startAnimating()
        }
        // Stop Loading Indicator
        stream.didFinishLoading = { [unowned self] in
            self.liveProgress.stopAnimating()
        }
        
        stream.contentURL = urlComponent!.url
        stream.play() // Play the stream
        
        //load history
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
