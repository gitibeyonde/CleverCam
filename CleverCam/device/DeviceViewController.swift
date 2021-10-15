//
//  DeviceViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 14/10/21.
//

import UIKit

class DeviceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet var collectionView: UICollectionView!
    var deviceList:Array<Device> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading device view controller")
        
        let nibCell = UINib(nibName: "DeviceCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "deviceCell")
        
        
        HttpRequest.deviceList(self) { (output) in
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    self.deviceList = try decoder.decode([Device].self, from: output)
                    for device in self.deviceList {
                        print(device.uuid)
                        HttpRequest.lastAlerts(self, uuid: device.uuid) { (output) in
                            DispatchQueue.main.async {
                                print(output)
                            }
                        }
                    }
                    print("done model")
                    self.collectionView.reloadData()
               } catch let error {
                    print("ERROR")
                    print(error)
               }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.deviceList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath as IndexPath) as! DeviceCell
        
        print("Index Path=")
        print(indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
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
            let alert = UIAlertController(title: "Ops", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
