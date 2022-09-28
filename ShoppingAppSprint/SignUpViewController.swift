//
//  SignUpViewController.swift
//  ShoppingAppSprint
//
//  Created by Capgemini-DA087 on 9/26/22.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        
    }
    // Function to store user credentials in firebase
    func registerUser(emailId: String, password: String){
        Auth.auth().createUser(withEmail: emailId, password: password, completion: {
            (result, error) -> Void in
            if let error = error{
                print(error.localizedDescription)
            }
            else{
                print("Updated in firebase")
            }
        })
        
    }
    static func getSignVC() -> SignUpViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        return signupVC
    }

    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Checking validations
        if (usernameTextField.text?.isNameValid)! {
            if (emailIdTextField.text?.isEmailValid)! {
                if (mobileTextField.text?.isPhoneNumberValid)! {
                    if ((passwordTextField.text?.isPasswordValid)! && (passwordTextField.text == confirmPasswordTextField.text)) {
                        // Instanciating coredata
                        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
                        let context = appDelegate.persistentContainer.viewContext
                        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context) as! UserData
                        // checking if same email exists
                        var flag = 0
                        do {
                            let userData = try context.fetch(UserData.fetchRequest())
                            
                            for data in userData{
                                let emailExist = data.userEmailId
                                
                                if(emailExist == emailIdTextField.text) {
                                    flag = 1
                                    
                                    break
                                }
                            }
                            // Same email does not exist
                            if (flag == 0) {
                                user.userEmailId = emailIdTextField.text
                                user.userName = usernameTextField.text
                                user.userMobile = mobileTextField.text
                                user.userPassword = passwordTextField.text
                                do {
                                    try context.save()
                                    print("Data Stored")
                                } catch {
                                    print("Can't Load")
                                }
                                let email: String = emailIdTextField.text!
                                let password: String = passwordTextField.text!
                                
                                // Storing data in firebase
                                registerUser(emailId: email, password: password)
                                let tabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
                                self.navigationController?.pushViewController(tabBarViewController, animated: true)
                            }
                            else {
                                let alert = UIAlertController(title: "Not Valid", message: "Email already exists", preferredStyle: .alert)
                                
                                // add an action button
                                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in}
                                alert.addAction(okAction)
                                // showing the alert
                                self.present(alert, animated: true, completion: nil)
                            }

                                

                        } catch {
                            print("error occured")

                        }
                        
                    } else {
                        let alert = UIAlertController(title: "Not Valid", message: "Enter valid password and confirm password", preferredStyle: .alert)
                        
                        // add an action button
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in}
                        alert.addAction(okAction)
                        // showing the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    let alert = UIAlertController(title: "Not Valid", message: "Enter 10-Digits Phone Number", preferredStyle: .alert)
                    
                    // add an action button
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in}
                    alert.addAction(okAction)
                    // showing the alert
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Not Valid", message: "Enter Valid EmailId", preferredStyle: .alert)
                
                // add an action button
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in}
                alert.addAction(okAction)
                // showing the alert
                self.present(alert, animated: true, completion: nil)
            }
        
        } else {
            // create an alert
            let alert = UIAlertController(title: "Not Valid", message: "Enter Valid Username", preferredStyle: .alert)
            
            // add an action button
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in}
            alert.addAction(okAction)
            
            // showing the alert
            self.present(alert, animated: true, completion: nil)
        }
        
       
        
                
    }
                        
}
    




// creating extension and setting parameters for checking validation
extension String {
    var isPhoneNumberValid: Bool {
        do{
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            
            } else {
                return false
            }
            
        } catch {
            return false
        }
    }
    
    var isNameValid: Bool {
        let nameTest = NSPredicate(format: "SELF MATCHES %@", "(?=.+[a-zA-Z]).{5,}$")
        return nameTest.evaluate(with: self)
    }
    
    var isEmailValid: Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z.-]+@[a-zA-Z.-]+\\.[A-Za-z]{2,3}")
        return emailTest.evaluate(with: self)
    }
    
    var isPasswordValid: Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.+[a-zA-Z0-9_]).{6}$")
        return passwordTest.evaluate(with: self)
    }
}

