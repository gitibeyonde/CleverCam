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
                    HttpRequest.lastAlerts(self, uuid: device.uuid) { (output) in
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
                print("done model")
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
        print("Count is ", ApiContext.shared.deviceAlertList.count)
        return ApiContext.shared.deviceList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath as IndexPath) as! DeviceCell
        cell.delegate = self
        
        let index :Int = indexPath[1]
        if ApiContext.shared.deviceAlertList.count > index {
            let da: Device = ApiContext.shared.getDevice(index: index)
            cell.deviceName.text = da.device_name
            cell.configure(uuid: da.uuid)
            let al: Array<Alert> = ApiContext.shared.getDeviceAlerts(index: index)
            
            if al.count > 0 {
                print("-----------------------------------------------", da.device_name)
                
                let url = URL(string: al[counter].url)!
                let data:Data = ApiContext.shared.getImage(url: url)
                if data.isEmpty {
                    getData(from: url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            print(response?.suggestedFilename ?? url.lastPathComponent)
                            ApiContext.shared.addImage(url: url, data: data)
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
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        DeviceViewController.device_timer.invalidate()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.size.width - 40
        let height = (width * 0.95)
        return CGSize (width: width, height: height)
    }
    
}

extension DeviceViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
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
