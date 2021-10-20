//
//  HistoryViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 17/10/21.
//

import UIKit

class HistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    public static var uuid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading HistoryViewController")
        
        let nibCell = UINib(nibName: "HistoryCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "historyCell")
        
        HttpRequest.history(self, uuid: HistoryViewController.uuid) { (output) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let hl: Array<History> = ApiContext.shared.getDeviceHistory(uuid: HistoryViewController.uuid)
        return hl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath as IndexPath) as! HistoryCell
        
        let hl: Array<History> = ApiContext.shared.getDeviceHistory(uuid: HistoryViewController.uuid)
        
        let url = URL(string: hl[indexPath[1]].url)!
        
        cell.dateTime.text = hl[indexPath[1]].time
        let data:Data = ApiContext.shared.getImage(url: url)
        if data.isEmpty {
            getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    ApiContext.shared.addImage(url: url, data: data)
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.image.image = UIImage(data: data)
                        cell.image.frame = CGRect(x: 0, y: 0, width: 320, height: 240)
                    }
               }
        }
        else {
            DispatchQueue.main.async() {
                print("Cache hit")
                cell.image.image = UIImage(data: data)
                cell.image.frame = CGRect(x: 0, y: 0, width: 320, height: 240)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.size.width - 40
        let height = (width * 0.85)
        return CGSize (width: width, height: height)
    }
    
}


extension HistoryViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
