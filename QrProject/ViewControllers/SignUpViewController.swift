//
//  SignUpViewController.swift
//  QrProject
//
//  Created by Алексей Германов on 08.04.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFiledButton(signUpButton)
    }

    func validateFields() -> String?{
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        
        let CleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(CleanedPassword) == false{
            return "Please make sure your password is at least 8 characters"
        }
        
        return nil
    }
    
        
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let dateString = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        let currentDateTime = dateFormatter.string(from: dateString)
        
        
        let error = validateFields()
        if error != nil{
            showError(error!)
        }//IF error
        else{
           
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password){ (result,err) in
                if err != nil{
                    self.showError("Error creating user")
                }
                else{
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstname,"lastname":lastname,"uid": result!.user.uid,"datetime":currentDateTime])
                    {(error) in
                        if error != nil {
                            self.showError("Error saving user data")
                      }
                    }
                    self.transitionToLogin()
                    //self.transitionToHome()
                    
               }//End Else Auth
            }//End Auth
            
            
        }//End Else
        
    }//End sign Up tapped
    
    func transitionToLogin(){
        let loginViewControllers = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        view.window?.rootViewController = loginViewControllers
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToHome(){
        let homeViewControllers = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewControllers
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
