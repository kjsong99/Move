import UIKit
import SwiftKeychainWrapper

class SignInViewController: UIViewController {
    
    // MARK - PROPERTY
    
    var isVisible : Bool = false
    
    // MARK - OUTLET
    
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailErrorText: UILabel!
    @IBOutlet var passwordErrorText: UILabel!
    @IBOutlet var signInBtn: UIButton!
    
    @IBAction func IspwdFieldVisible(_ sender: Any) {
        if isVisible{
            passwordText.isSecureTextEntry = true
            isVisible = false
        }else{
            passwordText.isSecureTextEntry = false
            isVisible = true
        }
        
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        guard let  email  = emailText.text else{
            return
        }
        guard let password = passwordText.text else{
            return
        }
        
        Task{
            if try await API.isEmailExist(email: email){
                do{
                    try await API.signIn(email: email, password: password)
                    let main = UIStoryboard.init(name: "Main", bundle: nil)
                    guard let vc = main.instantiateInitialViewController() else{
                        return
                    }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }catch{
                    //비밀번호 불일치
                    passwordErrorText.isHidden = false
                }
                
                
            }else{
                emailErrorText.isHidden = false
                
            }
        }
        
    }
    
    // MARK - OVERRIDE
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        emailText.addTarget(self, action: #selector(self.emailTextChanged(_:)), for: .editingChanged)
        
        passwordText.addTarget(self, action: #selector(self.passwordTextChanged(_:)), for: .editingChanged)
    }
    
    // MARK - METHOD
    
    @objc func emailTextChanged(_ sender: Any){
        guard let email = emailText.text else {
            return
        }
        
        if email == "" || !email.contains("@") {
            //버튼 비활성화
            signInBtn.isEnabled = false
            
        }else{
            //버튼 활성화
            if !emailErrorText.isHidden{
                emailErrorText.isHidden = true
            }
            if passwordText.text != "" {
                signInBtn.isEnabled = true
            }
        }
    }
    
    @objc func passwordTextChanged(_ sender: Any){
        guard let password = passwordText.text else {
            return
        }
        
        if password == "" {
            //버튼 비활성화
            signInBtn.isEnabled = false
        }else{
            //버튼 활성화
            if !passwordErrorText.isHidden{
                passwordErrorText.isHidden = true
            }
            if emailText.text != "" {
                signInBtn.isEnabled = true
            }
        }
    }
    
}
