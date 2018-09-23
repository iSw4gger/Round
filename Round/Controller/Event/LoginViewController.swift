

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoView.layer.cornerRadius = logoView.frame.size.width / 2
        logoView.clipsToBounds = true
        checkUserDefaults()
        emailAddressTextField.layer.cornerRadius = 10
        emailAddressTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
        rememberMeSwitch.addTarget(self, action: #selector(self.stateChanged), for: .valueChanged)


    }
    
    @objc func viewTapped(){
        emailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
    }
    
    @objc func stateChanged(_ switchState: UISwitch){
        
        let defaults = UserDefaults.standard
        if switchState.isOn{
            defaults.set(true, forKey: "ISRemember")
            defaults.set(emailAddressTextField.text, forKey: "SavedUserName")
            defaults.set(passwordTextField.text, forKey: "SavedPassword")
        }else{
            defaults.set(false, forKey: "ISRemember")
            defaults.removeObject(forKey: "SavedUserName")
            defaults.removeObject(forKey: "SavedPassword")
        }
    }
    
    func checkUserDefaults(){
        
        let defaults = UserDefaults.standard
        
        if let user = defaults.string(forKey: "SavedUserName"){
            emailAddressTextField.text = user
        }
        
        if let password = defaults.string(forKey: "SavedPassword"){
            passwordTextField.text = password
        }
        
        if defaults.bool(forKey: "ISRemember") == true{
            rememberMeSwitch.isOn = true
        }
        
        if defaults.bool(forKey: "ISRemember") == false{
            rememberMeSwitch.isOn = false
        }
    }

    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Logging in...")
        Auth.auth().signIn(withEmail: emailAddressTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print(error!)
                self.passwordTextField.text = ""
                SVProgressHUD.showError(withStatus: "Incorrect Username or Password. Also, check your internet status.")
                _ = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { (timer) in
                    SVProgressHUD.dismiss()
                }
            }else{
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "segueToMainEvent", sender: self)
            }
        }
    }
    
}
