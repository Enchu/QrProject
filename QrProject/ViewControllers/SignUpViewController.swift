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

        setUpElements()
    }

    @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func setUpElements(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFiledButton(signUpButton)
        Utilities.styleLabel(errorLabel)
    }
    
    @IBAction func firstNameChanged(_ sender: UITextField) {
        //if Utilities.isCurrentSize(sender.text!) == false{ return}
        if sender.text!.count >= 2{
            Utilities.styleColorTextField(firstNameTextField)
        }
        if sender.text!.count<2{
            Utilities.styleColorTextFieldRed(firstNameTextField)
            //Utilities.styleTextField(firstNameTextField)
        }
    }
    @IBAction func lastNameChanged(_ sender: UITextField) {
        if sender.text!.count >= 2{
            Utilities.styleColorTextField(lastNameTextField)
        }
        if sender.text!.count < 2{
            Utilities.styleColorTextFieldRed(lastNameTextField)
        }
    }
    @IBAction func loginChanged(_ sender: UITextField) {
        let CleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(CleanedEmail) == false{ return Utilities.styleTextField(emailTextField)}
        if sender.text!.count > 6{
            Utilities.styleColorTextField(emailTextField)
        }
        if sender.text!.count < 6{
            Utilities.styleColorTextFieldRed(emailTextField)
        }
    }
    @IBAction func passwordChanged(_ sender: UITextField) {
        /*let CleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(CleanedPassword) == false{
            return Utilities.styleTextField(passwordTextField)
        }*/
        if sender.text!.count >= 6{
            Utilities.styleColorTextField(passwordTextField)
        }
        if sender.text!.count < 6{
            Utilities.styleColorTextFieldRed(passwordTextField)
        }
    }
    
    func alert (_ message:String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateFields() -> String?{
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Заполните все поля"
        }
        
        let CleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let CleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(CleanedEmail) == false{
            return "Пожалуйста, убежитесь, в правильности написания email"
        }
        if Utilities.isPasswordValid(CleanedPassword) == false{
            return "Пожалуйста, убедитесь, что ваш пароль состоит не менее чем из 6 символов"
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
            alert(error!)
            //showError(error!)
        }
        else{
           
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password){ (result,err) in
                if err != nil{
                    self.showError("Ошибка создания пользователя")
                }
                else{
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstname,"lastname":lastname,"uid": result!.user.uid,"datetime":currentDateTime])
                    {(error) in
                        if error != nil {
                            self.showError("Ошибка сохранения в базе данных")
                      }
                    }
                    self.transitionToLogin()
                    
                    /*let Res = result?.user.uid
                    self.uidLog = Res!
                    self.transitionToHome()*/
               }//End Else Auth
            }//End Auth
        }//End Else
        
    }//End sign Up tapped
    
    
    func transitionToLogin(){
        let loginViewControllers = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        view.window?.rootViewController = loginViewControllers
        view.window?.makeKeyAndVisible()
    }
    
    var uidLog=""
    func transitionToHome(){
        let homeViewControllers = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        homeViewControllers?.uidLL = self.uidLog
        view.window?.rootViewController = homeViewControllers
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}//End Class ViewController


