//
//  SettingsViewController.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 18/10/21.
//

import UIKit

var tzValues = [String]()
let fsValues = [ "Large", "Medium", "Small" ]

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    public static var uuid: String = ""
    
    @IBOutlet var label: UILabel!
    @IBOutlet var name: UITextField!
    @IBOutlet var version: UITextField!
    @IBOutlet var timezone: UIPickerView!
    @IBOutlet var framesize: UIPickerView!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var message: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HttpRequest.settings(self, uuid: SettingsViewController.uuid) { (config) in
            for nv in config {
                print(nv)
            }
        }
        
        // Do any additional setup after loading the view.
        timezone.tag = 1
        framesize.tag = 2
        
        let tzs = _timezones()
        
        for to in tzs.getTimeZones() {
            tzValues.append(to.timezone)
        }
        
        
    }
    
    @IBAction func deviceNameClick(_ sender: UIButton) {
    }
    
    @IBAction func cloudStreaming(_ sender: UISwitch) {
        if (sender.isOn == true){
           print("on")
        }
        else{
           print("off")
        }
    }
    
    @IBAction func storeMotion(_ sender: UISwitch) {
        if (sender.isOn == true){
           print("on")
        }
        else{
           print("off")
        }
    }
    
    @IBAction func deleteHistory(_ sender: UIButton) {
    }
    @IBAction func verticalFlip(_ sender: UISwitch) {
        if (sender.isOn == true){
           print("on")
        }
        else{
           print("off")
        }
    }
    @IBAction func horizontalFlip(_ sender: UISwitch) {
        if (sender.isOn == true){
           print("on")
        }
        else{
           print("off")
        }
    }
    
    @IBAction func restart(_ sender: UIButton) {
    }
    
    @IBAction func reset(_ sender: UIButton) {
    }
    @IBAction func upgrade(_ sender: UIButton) {
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
            case 1:
                return tzValues.count
            case 2:
                return fsValues.count
            default:
                return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
            case 1:
                return tzValues[row]
            case 2:
                return fsValues[row]
            default:
                return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}


extension SettingsViewController: HttpRequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ops", message: "Error getting device list...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
