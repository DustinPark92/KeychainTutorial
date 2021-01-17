//
//  ViewController.swift
//  KeychainTutorial
//
//  Created by Dustin on 2021/01/17.
//

import UIKit
import SwiftKeychainWrapper
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLocalBioAuthenciation()
        // Do any additional setup after loading the view.
    }

    @IBAction func savePasswordTapped(_ sender: UIButton) {
        
        if let password = passwordTextField.text {
            let saveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: "userPassword")
            print("Save was successful: \(saveSuccessful)")
            self.view.endEditing(true)
        }
    }
    
    @IBAction func retrievePasswordButtonTapped(_ sender: UIButton) {
        let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "userPassword")
        
        if passwordTextField.text == retrievedPassword {
            let controller = LoginCompleteViewController()
            self.present(controller, animated: true, completion: nil)
        }
        print("Retrieved passwork is: \(retrievedPassword!)")
        
    }
    @IBAction func handleLogin(_ sender: Any) {

        
    }
    
    func handleLocalBioAuthenciation() {
        
        let authContext = LAContext()
        
        var error: NSError?
        
        var description: String!
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            switch authContext.biometryType {
            case .faceID:
                description = "계정 정보를 열람하기 위해서 Face ID로 인증 합니다."
                break
            case .touchID:
                description = "계정 정보를 열람하기 위해서 Touch ID로 인증 사용합니다."
                break
            case .none:
                description = "계정 정보를 열람하기 위해서는 로그인하십시오."
                break
            }
            
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { (success, error) in
                
                if success {
                    print("인증 성공")
                    DispatchQueue.main.async {
                        let controller = LoginCompleteViewController()
                        self.present(controller, animated: true, completion: nil)
                    }

                } else {
                    print("인증 실패")
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }
            
        }  else {
            // Touch ID・Face ID를 사용할 수없는 경우
            let errorDescription = error?.userInfo["NSLocalizedDescription"] ?? ""
            print(errorDescription)
            description = "계정 정보를 열람하기 위해서는 로그인하십시오."
            
            let alertController = UIAlertController(title: "Authentication Required", message: description, preferredStyle: .alert)
            weak var usernameTextField: UITextField!
            alertController.addTextField(configurationHandler: { textField in
                textField.placeholder = "User ID"
                usernameTextField = textField
            })
            weak var passwordTextField: UITextField!
            alertController.addTextField(configurationHandler: { textField in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
                passwordTextField = textField
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Log In", style: .destructive, handler: { action in
                // 를
                print(usernameTextField.text! + "\n" + passwordTextField.text!)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
}

