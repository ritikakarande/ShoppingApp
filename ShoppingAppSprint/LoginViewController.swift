//
//  ViewController.swift
//  ShoppingAppSprint
//
//  Created by Capgemini-DA087 on 9/26/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginScreenImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 5
        loginScreenImg.layer.cornerRadius = 40
        loginScreenImg.clipsToBounds = true
    }
    // Checking firbase for user credentials and storing in keychain access
    func userLogin(emailId: String, password: String){
        Auth.auth().signIn(withEmail: emailId, password: password, completion: {
            (result, error) in
            if error != nil{
                let alert = UIAlertController(title: "Not Found", message: "User does not exist. Please SignUp", preferredStyle: .alert)
                
                // add an action button
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in}
                alert.addAction(okAction)
                // showing the alert
                self.present(alert, animated: true, completion: nil)
            }
            else{
                _ = KeyChainManager.save(account: emailId, password: password)
                //print(keyChainStatus)
                let tabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                self.navigationController?.pushViewController(tabBarViewController, animated: true)
            }
        })
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email: String = emailIdTextField.text!
        let password: String = passwordTextField.text!
        userLogin(emailId: email, password: password)
    }
    
    // Function for used in implementing test cases
    static func getVC() -> LoginViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return VC
    }

    
}

class KeyChainManager {
    class func save(account: String, password: String) -> OSStatus {
        let saveQuery = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecValueData as String : password
        ] as [String : Any]
        SecItemDelete(saveQuery as CFDictionary)
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        return status
    }
}
// Class for local authorization
class LocalAuthorization: UIViewController {
    
    // Authorization using faceID
    func authenticateUserByFaceId(){
        let context = LAContext()
        var autherror: NSError?
        let msgStr = "Authentication required"
        
        // Calling lacontext functionality for getting authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &autherror){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: msgStr) {
                [weak self] success, error in
                DispatchQueue.main.async {
                    if success{
                        self?.presentAlert(messageStr: "Authentication Successful", title: "Success")
                    }
                    else {
                        
                    }
                }
            }
        }
        else{
            presentAlert(messageStr: "Biometric authentication not available", title: "Failed")
        }
    }
    
    func presentAlert (messageStr: String, title: String){
        let alert = UIAlertController(title: title, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true)
    }
    func authenticateUserBySecurityPin(){
        let context: LAContext = LAContext()
        let msgStr = "Authentication is needed to access your App"
        var authError: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError){
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: msgStr, reply: {success, error in
                if success {
                    print("Authentication successful")
                }
                
                else {
                    if let error = error{
                        //let message = self.showMessageWithErrorCode(errorcode: -2)
                        //print(message)
                       print(error.localizedDescription)
                    }
                }
                
            })
        }
    }
}

