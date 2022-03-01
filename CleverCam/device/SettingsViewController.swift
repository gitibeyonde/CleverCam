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
    
    @IBOutlet weak var message_top: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var timezone: UIPickerView!
    @IBOutlet weak var camFramesize: UIPickerView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var nameChangeButton: UIButton!
    @IBOutlet weak var deleteHistoryButton: UIButton!
    @IBOutlet weak var storeHistorySwitch: UISwitch!
    @IBOutlet weak var vertFlipSwitch: UISwitch!
    @IBOutlet weak var horFlipSwitch: UISwitch!
    
    @IBOutlet weak var upgradeButton: UIButton!
    
    
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
                        print(config)
                        self.activity.stopAnimating()
                        self.message_top.text = ""
                        self.message.text = "    \(config.name) settings"
                        self.name.text = config.name
                        self.version.text = config.version
                        
                        self.nameChangeButton.isEnabled = true
                        self.storeHistorySwitch.isEnabled = true
                        self.deleteHistoryButton.isEnabled = true
                        self.vertFlipSwitch.isEnabled = true
                        self.horFlipSwitch.isEnabled = true
                        self.camFramesize.isUserInteractionEnabled = true
                        self.timezone.isUserInteractionEnabled = true
                        
                        self.storeHistorySwitch.setOn(config.history == "true", animated: true)
                        self.vertFlipSwitch.setOn(config.vflip == 1, animated: true)
                        self.horFlipSwitch.setOn(config.hmirror == 1, animated: true)
                        self.camFramesize.selectRow(self.framesizeIndex(framesize: config.framesize), inComponent: 0, animated: true)
                        self.timezone.selectRow(tzValues.firstIndex(of: config.timezone) ?? 0, inComponent: 0, animated: true)
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
                                self.upgradeButton.setTitle("Upgrade to version - \(upver)", for: UIControl.State.normal)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                print("Enabling upgrade button")
                                self.upgradeButton.isEnabled = false;
                                self.upgradeButton.setTitle("Running latest version - \(curver)", for: UIControl.State.normal)
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
        
        let nameChangeAlert = UIAlertController(title: "Warning", message: "Are you sure you want to update the name of the devic ?", preferredStyle: UIAlertController.Style.alert)

        nameChangeAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            HttpRequest.applyDeviceConfig(self, uuid: SettingsViewController.uuid, name: "name", value: self.name.text!) { (reponse) in
                print(reponse)
            }
        }))

        nameChangeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Name Change cancelled")
        }))

        present(nameChangeAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func storeMotion(_ sender: UISwitch) {
        HttpRequest.applyDeviceConfig(self, uuid: SettingsViewController.uuid, name: "history", value: sender.isOn == true ? "true" : "false" ) { (reponse) in
            print(reponse)
        }
    }
    
    @IBAction func deleteHistory(_ sender: UIButton) {
        print("Delete history pressed")
        
        let delHistAlert = UIAlertController(title: "Warning", message: "All your motion/alert history will be erased.", preferredStyle: UIAlertController.Style.alert)

        delHistAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            HttpRequest.deleteHistory(self, uuid: SettingsViewController.uuid ) { (reponse) in
                print(reponse)
            }
        }))

        delHistAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Delete hostory cancelled")
        }))
        
        present(delHistAlert, animated: true, completion: nil)
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
        let restartAlert = UIAlertController(title: "Warning", message: "The device will be restarted. It will be offline for few minutes.", preferredStyle: UIAlertController.Style.alert)

        restartAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            HttpRequest.deviceCommand(self, uuid: SettingsViewController.uuid, name: "restart" ) { (reponse) in
                print(reponse)
            }
        }))

        restartAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Restart cancelled")
        }))

        present(restartAlert, animated: true, completion: nil)
    }
    @IBAction func reset(_ sender: UIButton) {
        let resetAlert = UIAlertController(title: "Warning", message: "The device will be reset and loose wifi connection and fallback to bluetooth. Use android bluetooth setup to re-configure.", preferredStyle: UIAlertController.Style.alert)

        resetAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            HttpRequest.deviceCommand(self, uuid: SettingsViewController.uuid, name: "reset" ) { (reponse) in
                print(reponse)
            }
        }))

        resetAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Reset cancelled")
        }))

        present(resetAlert, animated: true, completion: nil)
    }
    @IBAction func upgrade(_ sender: UIButton) {
            let upgradeAlert = UIAlertController(title: "Warning", message: "Upgrading will take few minutes depending on network. The device will be offline for few minutes.", preferredStyle: UIAlertController.Style.alert)

            upgradeAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                HttpRequest.deviceCommand(self, uuid: SettingsViewController.uuid, name: "upgrade" ) { (reponse) in
                    print(reponse)
                }
            }))

            upgradeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Upgrade cancelled")
            }))

            present(upgradeAlert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    private func framesizeIndex(framesize: Int)->Int {
        if framesize == 8 {
            return 0
        }
        else if framesize == 5 {
            return 1
        }
        else {
            return 2
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
            
                let timeZoneAlert = UIAlertController(title: "Warning", message: "Do you really want to change the timezone ?", preferredStyle: UIAlertController.Style.alert)

                timeZoneAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        HttpRequest.applyDeviceConfig(self, uuid: SettingsViewController.uuid, name: "timezone", value: tzValues[row] ) { (reponse) in
                                print(reponse)
                            }
                }))

                timeZoneAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                      print("Timezone change cancelled")
                    self.timezone.selectRow(tzValues.firstIndex(of: self.config.timezone) ?? 0, inComponent: 0, animated: true)
                }))

                present(timeZoneAlert, animated: true, completion: nil)
            
                break
            case 2:
                print(fsValues[row])
            
                let framesizeAlert = UIAlertController(title: "Warning", message: "Framesize change will restart the device. The devce will be offline for a minutes.", preferredStyle: UIAlertController.Style.alert)

                framesizeAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    HttpRequest.applyCamConfig(self, uuid: SettingsViewController.uuid, name: "framesize", value: String(self.indexToFramesize(index: row)) ) { (reponse) in
                            print(reponse)
                        }
                }))

                framesizeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                      print("Fraemsize change cancelled")
                    self.camFramesize.selectRow(self.framesizeIndex(framesize: self.config.framesize), inComponent: 0, animated: true)
                }))

                present(framesizeAlert, animated: true, completion: nil)
            
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
