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
    
    public static var uuid: String = ""
    var stream: MJPEGStreamLib!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading bell alert view controller ")
        
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

extension BellAlertViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "Unable to get live feed...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
