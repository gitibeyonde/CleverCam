//
//  HistoryViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 17/10/21.
//

import UIKit

class HistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var heading: UILabel!
    public static var uuid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading HistoryViewController")
        
        let nibCell = UINib(nibName: "HistoryCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "historyCell")
        
        heading.text = "    " + ApiContext.shared.getDeviceName(uuid: HistoryViewController.uuid) + " History"
        
        HttpRequest.history(self, uuid: HistoryViewController.uuid) { (histlist) in
            for h in histlist {
                let url_str =  h.url
                let Url = URL(string: url_str)!

                getData(from: Url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? Url.lastPathComponent)
                    ApiContext.shared.addImage(url: url_str, data: data)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
               }
            }
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
        
        cell.dateTime.text = hl[indexPath[1]].time
        
        let url_str =  hl[indexPath[1]].url
        let data:Data = ApiContext.shared.getImage(url: url_str)
        if !data.isEmpty {
            DispatchQueue.main.async() {
                cell.image.image = UIImage(data: data)
                cell.progress.stopAnimating()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
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
