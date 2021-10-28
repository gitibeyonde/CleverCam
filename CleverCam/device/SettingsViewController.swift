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
    var config:CameraConfig = CameraConfig()
    
    @IBOutlet var label: UILabel!
    @IBOutlet var name: UITextField!
    @IBOutlet var version: UITextField!
    @IBOutlet var timezone: UIPickerView!
    @IBOutlet var camFramesize: UIPickerView!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var message: UILabel!
    @IBOutlet var cloudStreamSwitch: UISwitch!
    @IBOutlet var storeHistorySwitch: UISwitch!
    @IBOutlet var vertFlipSwitch: UISwitch!
    @IBOutlet var horFlipSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tzs = _timezones()
        for to in tzs.getTimeZones() {
            tzValues.append(to.timezone)
        }
        
        HttpRequest.settings(self, uuid: SettingsViewController.uuid) { (config) in
            self.config = config
            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.message.text = "\(config.name) settings"
                self.name.text = config.name
                self.version.text = config.version
                self.cloudStreamSwitch.setOn(config.cloud == "true", animated: false)
                self.storeHistorySwitch.setOn(config.history == "true", animated: false)
                self.vertFlipSwitch.setOn(config.vflip == 1, animated: false)
                self.horFlipSwitch.setOn(config.hmirror == 1, animated: false)
                self.camFramesize.selectRow(self.framesizeIndex(framesize: config.framesize), inComponent: 0, animated: false)
                self.timezone.selectRow(tzValues.firstIndex(of: config.timezone) ?? 0, inComponent: 0, animated: false)
            }
        }
        
        // Do any additional setup after loading the view.
        timezone.tag = 1
        camFramesize.tag = 2
    }
    
    private func framesizeIndex(framesize: Int)->Int {
        if framesize == 8 {
            return 2
        }
        else if framesize == 5 {
            return 1
        }
        else {
            return 0
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
            let alert = UIAlertController(title: "Ops", message: "Error getting camera config...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

}
