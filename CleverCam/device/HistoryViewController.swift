//
//  HistoryViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 17/10/21.
//

import UIKit

class HistoryViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var heading: UILabel!
    public static var uuid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading HistoryViewController")
        
        let nibCell = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "historyCell")
        
        //heading.text = "    " + ApiContext.shared.getDeviceName(uuid: HistoryViewController.uuid) + " History"
        
        HttpRequest.history(self, uuid: HistoryViewController.uuid) { (histlist) in
            for h in histlist {
                let url_str =  h.url
                let Url = URL(string: url_str)!

                getData(from: Url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? Url.lastPathComponent)
                    ApiContext.shared.addImage(url: url_str, data: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
               }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hl: Array<History> = ApiContext.shared.getDeviceHistory(uuid: HistoryViewController.uuid)
        return hl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath as IndexPath) as! HistoryCell
        
        let hl: Array<History> = ApiContext.shared.getDeviceHistory(uuid: HistoryViewController.uuid)
        
        cell.dateTime.text = hl[indexPath[1]].time
        
        let url_str =  hl[indexPath[1]].url
        let data:Data = ApiContext.shared.getImage(url: url_str)
        if !data.isEmpty {
            DispatchQueue.main.async() {
                cell.historyImage.image = UIImage(data: data)
                cell.progress.stopAnimating()
            }
        }
        
        return cell
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
