//
//  LoginViewController.swift
//  QrProject
//
//  Created by Алексей Германов on 08.04.2022.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFiledButton(loginButton)
    }
    
    @IBAction func loginChanged(_ sender: UITextField) {
        let CleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(CleanedEmail) == false{ return }
        if sender.text!.count >= 6{
            Utilities.styleColorTextField(emailTextField)
        }
        if sender.text!.count < 6{
            Utilities.styleColorTextFieldRed(emailTextField)
        }
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
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
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == "admin" && password == "admin"{ self.adminToHome() }
        else{
        Auth.auth().signIn(withEmail: email, password: password){(result,error) in
            if error != nil{
                //self.errorLabel.text = error!.localizedDescription self.errorLabel.alpha = 1
                self.alert("Ошибка подключения/ Логин или пароль неверен")
            }
            else{
                let Res = result?.user.uid
                self.uidLog = Res!
                self.transitionToHome()
            }
        }
        }
    }
    
    func adminToHome(){
        let adminViewControllers = storyboard?.instantiateViewController(identifier: Constants.Storyboard.adminViewController) as? AdminViewController
        view.window?.rootViewController = adminViewControllers
        view.window?.makeKeyAndVisible()
    }
    
    
    var uidLog=""

    func transitionToHome(){
        let homeViewControllers = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        homeViewControllers?.uidLL = self.uidLog
        view.window?.rootViewController = homeViewControllers
        view.window?.makeKeyAndVisible()
    }
    
}
