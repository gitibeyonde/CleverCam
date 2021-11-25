//
//  DeviceViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 14/10/21.
//

import UIKit

class DeviceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet var collectionView: UICollectionView!
    var counter: Int = 0
    public static var device_timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading device view controller ")
        
        let nibCell = UINib(nibName: "DeviceCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "deviceCell")
        
        
        HttpRequest.deviceList(self) { (deviceList) in
            DispatchQueue.main.async {
                for device in deviceList {
                    print("DeviceViewController ", device.uuid)
                    HttpRequest.lastAlerts(self, uuid: device.uuid) { (alerts) in
                        for a in alerts {
                            let url_str = a.url
                            let Url = URL(string: url_str)!
                            getData(from: Url) { data, response, error in
                                    guard let data = data, error == nil else { return }
                                    ApiContext.shared.addImage(url: url_str, data: data)
                                
                                    if ApiContext.shared.allDeviceAlertsAvailable() {
                                        DispatchQueue.main.async {
                                            self.collectionView.reloadData()
                                        }
                                    }
                               }
                        }
                    }
                }
                DeviceViewController.device_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func fireTimer() {
        counter+=1
        if counter>=10 {
            counter=0;
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ApiContext.shared.deviceList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath as IndexPath) as! DeviceCell
        cell.delegate = self
    
        let index :Int = indexPath[1]
        cell.progress.startAnimating()
        if index < ApiContext.shared.deviceAlertList.count {
            
            let da: Device = ApiContext.shared.getDevice(index: index)
            cell.deviceName.text = da.device_name
            cell.configure(uuid: da.uuid)
            
            let al: Array<Alert> = ApiContext.shared.getDeviceAlerts(uuid: da.uuid)
            if al.count > 0 {
                let url_str = al[counter].url
                let data:Data = ApiContext.shared.getImage(url: url_str)
                if !data.isEmpty {
                    cell.image.image = UIImage(data: data)
                    cell.progress.stopAnimating()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        DeviceViewController.device_timer.invalidate()
    }
    
    
}

extension DeviceViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            Users.setLoginStatus(object: "false")
            let alert = UIAlertController(title: "Ops", message: "Error getting device list...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}

extension DeviceViewController: DeviceCellDelegate {
    func historyClicked(with uuid: String) {
        DeviceViewController.device_timer.invalidate()
        print("uuid clicked = \(uuid)")
        HistoryViewController.uuid = uuid
        self.performSegue(withIdentifier: "ShowHistory", sender: uuid)
    }
    
    func liveClicked(with uuid: String) {
        DeviceViewController.device_timer.invalidate()
        print("uuid clicked = \(uuid)")
        LiveViewController.uuid = uuid
        self.performSegue(withIdentifier: "ShowLive", sender: uuid)
    }
    
    func settingsClicked(with uuid: String) {
        DeviceViewController.device_timer.invalidate()
        print("uuid clicked = \(uuid)")
        SettingsViewController.uuid = uuid
        self.performSegue(withIdentifier: "ShowSettings", sender: uuid)
    }
}
