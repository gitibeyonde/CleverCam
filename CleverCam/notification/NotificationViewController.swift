//
//  NotificationViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 18/10/21.
//

import UIKit

class NotificationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet var collectionView: UICollectionView!
    
    public static var showBell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading notification view controller ")
        
        
        let nibCell = UINib(nibName: "NotificationCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "NotificationCell")
        
        HttpRequest.notifications(self) { (notificationList) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        if (NotificationViewController.showBell) {
            self.performSegue(withIdentifier: "ShowBell", sender: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Notification view viewDidDisappear")
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        print("Notification myUnwindAction")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ApiContext.shared.notificationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCell", for: indexPath as IndexPath) as! NotificationCell
        
        let nl: Array<CCNotification> = ApiContext.shared.notificationList
        
        cell.deviceName.text = ApiContext.shared.getDeviceName(uuid:nl[indexPath[1]].uuid)
        cell.id.text = nl[indexPath[1]].id
        cell.dateTime.text = nl[indexPath[1]].created
        
        let url_str = nl[indexPath[1]].image
        let Url = URL(string: url_str)!
        let data:Data = ApiContext.shared.getImage(url: url_str)
        if data.isEmpty {
            getData(from: Url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? Url.lastPathComponent)
                    ApiContext.shared.addImage(url: url_str, data: data)
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.image.image = UIImage(data: data)
                        cell.progress.stopAnimating()
                    }
               }
        }
        else {
            DispatchQueue.main.async() {
                print("Cache hit")
                cell.image.image = UIImage(data: data)
                cell.progress.stopAnimating()
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        DeviceViewController.device_timer.invalidate()
        let nl: Array<CCNotification> = ApiContext.shared.notificationList
        BellAlertViewController.uuid = nl[indexPath[1]].uuid
        BellAlertViewController.datetime = nl[indexPath[1]].created
        print("Date time", BellAlertViewController.datetime)
        self.performSegue(withIdentifier: "ShowBell", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.size.width - 40
        let height = (width * 0.50)
        return CGSize (width: width, height: height)
    }
    

}

extension NotificationViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "Error getting notifications...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
