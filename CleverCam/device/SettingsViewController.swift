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
    
    @IBOutlet var name: UITextField!
    @IBOutlet var version: UILabel!
    @IBOutlet var timezone: UIPickerView!
    @IBOutlet var camFramesize: UIPickerView!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var message: UILabel!
    
    @IBOutlet var cloudStreamSwitch: UISwitch!
    @IBOutlet var storeHistorySwitch: UISwitch!
    @IBOutlet var vertFlipSwitch: UISwitch!
    @IBOutlet var horFlipSwitch: UISwitch!
    
    @IBOutlet var upgradeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tzs = _timezones()
        for to in tzs.getTimeZones() {
            tzValues.append(to.timezone)
        }
        timezone.tag = 1
        camFramesize.tag = 2
        
        print(ApiContext.shared.deviceList)
        
        self.upgradeButton.isEnabled = false;
        HttpRequest.veil(self, uuid: SettingsViewController.uuid) { (veil) in
            print("Veil ", veil)
            
            if (!veil.isEmpty){
                HttpRequest.settings(self, uuid: SettingsViewController.uuid) { (config) in
                    self.config = config
                    DispatchQueue.main.async {
                        self.activity.stopAnimating()
                        self.message.text = "       \(config.name) settings"
                        self.name.text = config.name
                        self.version.text = config.version
                        self.cloudStreamSwitch.setOn(config.cloud == "true", animated: false)
                        self.storeHistorySwitch.setOn(config.history == "true", animated: false)
                        self.vertFlipSwitch.setOn(config.vflip == 1, animated: false)
                        self.horFlipSwitch.setOn(config.hmirror == 1, animated: false)
                        self.camFramesize.selectRow(self.framesizeIndex(framesize: config.framesize), inComponent: 0, animated: false)
                        self.timezone.selectRow(tzValues.firstIndex(of: config.timezone) ?? 0, inComponent: 0, animated: false)
                    }
                    
                    HttpRequest.latestVersion(self, uuid: SettingsViewController.uuid) { (version) in
                        let x: Array = version.components(separatedBy: "-")
                        let upver: Int = Int(x[0]) ?? 0;
                        let curver: Int = Int(self.config.version) ?? 0;
                        let veil: String = x[1];
                        print("up version =", upver)
                        print("veil =", veil)
                        print("curr version =", self.config.version)
                        print(veil, ApiContext.shared.veil)
                        if (upver > curver && veil == ApiContext.shared.veil){
                            DispatchQueue.main.async {
                                print("Enabling upgrade button")
                                self.upgradeButton.isEnabled = true;
                                self.upgradeButton.setTitle("Upgrade to version \(upver)", for: UIControl.State.normal)
                            }
                        }
                    }
                }
            }
            else {
                self.message.text = "       FAILED: Please, reload settings"
            }
        }
    }
    
    @IBAction func deviceNameClick(_ sender: UIButton) {
        print(self.name.text!)
        HttpRequest.applyDeviceConfig(self, uuid: SettingsViewController.uuid, name: "cn", value: self.name.text!) { (reponse) in
            print(reponse)
        }
    }
    
    @IBAction func cloudStreaming(_ sender: UISwitch) {
        HttpRequest.applyDeviceConfig(self, uuid: SettingsViewController.uuid, name: "cloud", value: sender.isOn == true ? "true" : "false" ) { (reponse) in
            print(reponse)
        }
    }
    
    @IBAction func storeMotion(_ sender: UISwitch) {
        HttpRequest.applyDeviceConfig(self, uuid: SettingsViewController.uuid, name: "history", value: sender.isOn == true ? "true" : "false" ) { (reponse) in
            print(reponse)
        }
    }
    
    @IBAction func deleteHistory(_ sender: UIButton) {
        HttpRequest.deleteHistory(self, uuid: SettingsViewController.uuid ) { (reponse) in
            print(reponse)
        }
    }
    
    @IBAction func verticalFlip(_ sender: UISwitch) {
        HttpRequest.applyCamConfig(self, uuid: SettingsViewController.uuid, name: "vflip", value: sender.isOn == true ? "1" : "0" ) { (reponse) in
                print(reponse)
            }
    }
    @IBAction func horizontalFlip(_ sender: UISwitch) {
        HttpRequest.applyCamConfig(self, uuid: SettingsViewController.uuid, name: "hmirror", value: sender.isOn == true ? "1" : "0" ) { (reponse) in
                print(reponse)
            }
    }
    
    @IBAction func restart(_ sender: UIButton) {
        HttpRequest.deviceCommand(self, uuid: SettingsViewController.uuid, name: "restart" ) { (reponse) in
            print(reponse)
        }
    }
    @IBAction func reset(_ sender: UIButton) {
        HttpRequest.deviceCommand(self, uuid: SettingsViewController.uuid, name: "reset" ) { (reponse) in
            print(reponse)
        }
    }
    @IBAction func upgrade(_ sender: UIButton) {
        HttpRequest.deviceCommand(self, uuid: SettingsViewController.uuid, name: "upgrade" ) { (reponse) in
            print(reponse)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
    
    private func indexToFramesize(index: Int)->Int {
        if index == 0 {
            return 8
        }
        else if index == 1 {
            return 5
        }
        else {
            return 0
        }
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
        switch pickerView.tag {
            case 1:
                print(tzValues[row])
                HttpRequest.applyDeviceConfig(self, uuid: SettingsViewController.uuid, name: "timezone", value: tzValues[row] ) { (reponse) in
                        print(reponse)
                    }
                break
            case 2:
                print(fsValues[row])
                HttpRequest.applyCamConfig(self, uuid: SettingsViewController.uuid, name: "framesize", value: String(indexToFramesize(index: row)) ) { (reponse) in
                        print(reponse)
                    }
                break
            default:
                break
        }
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
