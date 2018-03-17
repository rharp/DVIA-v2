//
//  BrokenCryptographyDetailsViewController.swift
//  DVIA
//
//  Created by Prateek Gianchandani on 02/12/17.
//  Copyright © 2017 HighAltitudeHacks. All rights reserved.
//

import UIKit

class BrokenCryptographyDetailsViewController: UIViewController {

    @IBOutlet var firstTimeUserView: UIView!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var returningUserView: UIView!
    @IBOutlet var welcomeReturningUserLabel: UILabel!
    @IBOutlet var returningUserPasswordTextField: UITextField!
    @IBOutlet var loggedInLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension BrokenCryptographyDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let dataPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent("/secret-data").absoluteURL
        if textField == passwordTextField {
            textField.resignFirstResponder()
            if textField.text == nil {
                DVIAUtilities.showAlert(title: "Oops", message: "Please enter a password", viewController: self)
            } else {
                let data = passwordTextField.text?.data(using: String.Encoding.utf8)
                let encryptedData = try? RNEncryptor.encryptData(data, with: kRNCryptorAES256Settings, password: "Secret-Key")
                try? encryptedData?.write(to: dataPath, options: .atomic)
                UserDefaults.standard.set(true, forKey: "loggedIn")
                UserDefaults.standard.synchronize()
                firstTimeUserView.isHidden = true
            }
        } else if textField == returningUserPasswordTextField {
            let data = returningUserPasswordTextField.text?.data(using: String.Encoding.utf8)
            let encryptedData = try? Data(contentsOf: dataPath)
            let decryptedData = try? RNDecryptor.decryptData(encryptedData, withPassword: "Secret-Key")
            if data == decryptedData {
                loggedInLabel.isHidden = false
                returningUserPasswordTextField.isHidden = true
                welcomeReturningUserLabel.isHidden = true
            } else {
                DVIAUtilities.showAlert(title: "Oops", message: "Password is incorrect", viewController: self)
                return false
            }
        }
        return false
    }
}