//
//  LoginViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var addForgetPasswordView: UIView!
    @IBOutlet weak var emailFiled: LoginTextField!
    @IBOutlet weak var passwordField: LoginTextField!
    
    @IBOutlet weak var forgetPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    
    /*func loginInFailed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        print("Login Failed!")
    }*/
    

    func loginSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(tabBarController, animated: true, completion: nil)
        /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController*/
    }
    
    /*@IBAction func fbLoginAction (sender:AnyObject){
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: {(result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if (fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        })
    }*/
    
    //facebook login button
    @IBOutlet var fbLoginButton : FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start{ (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide the keyboard when tapping around
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    
    
        
        // Do any additional setup after loading the view.
        
        fbLoginButton.delegate = self
        applyMotionEffect(toView:logoImageView, magnitude: 5)
    
        applyMotionEffect(toView:backgroundImageView, magnitude: 15)
        //If FB signed in
        if let _ = FBSDKAccessToken.current(){
            getFBUserData()
            
        }

        let attributedString = NSAttributedString(string:"Forget your password?", attributes:[NSForegroundColorAttributeName:UIColor.white, NSUnderlineStyleAttributeName:1])
        passwordButton.setAttributedTitle(attributedString, for: .normal)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //add forgot Password Pop Up
    @IBAction func addForgetPasswordPopUp(_ sender: Any) {
        self.view.addSubview(addForgetPasswordView)
        addForgetPasswordView.center = self.view.center
        addForgetPasswordView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
        addForgetPasswordView.alpha = 0
        
        UIView.animate(withDuration:0.4){
            self.addForgetPasswordView.alpha = 1
            self.addForgetPasswordView.transform = CGAffineTransform.identity
        }
    }
    
    
    //do the forget password work and if successfully sent then dismiss the view
    @IBAction func dismissForgetPasswordPopUp(_ sender: Any) {
        if self.forgetPasswordTextField.text == "" {
            self.showAlerts(title: "Oops!", message: "Please enter your email!", handler: nil)
        }
        else{
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.forgetPasswordTextField.text!, completion: {(error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Oops!"
                    message = (error?.localizedDescription)!
                    self.showAlerts(title: title, message: message, handler: nil)
                    
                }
                else {
                    title = "Success!"
                    message = "The password reset email was sent!"
                    self.forgetPasswordTextField.text = ""
                    self.showAlerts(title: title, message: message, handler: {
                        UIAlertAction in
                        UIView.animate(withDuration:0.3, animations:{
                            self.addForgetPasswordView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
                            self.addForgetPasswordView.alpha = 0
                        }) {(success:Bool) in
                            self.addForgetPasswordView.removeFromSuperview()
                        }
                        
                    })
                }
            })
        }
        
    }
    //Directly dismiss the password reset view
    @IBAction func dismissPasswordReset(_ sender: AnyObject) {
        UIView.animate(withDuration:0.3, animations:{
            self.addForgetPasswordView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
            self.addForgetPasswordView.alpha = 0
        }) {(success:Bool) in
            self.addForgetPasswordView.removeFromSuperview()
        }
    }

    
    
    
    //Determine the login Access
    @IBAction func emailLoginAction(_ sender: AnyObject) {
        if self.emailFiled.text == "" || self.passwordField.text == ""
        {
            self.showAlerts(title: "Oops!", message: "Please enter your email address and password!", handler: nil)
        }
        else{
            
            FIRAuth.auth()?.signIn(withEmail: self.emailFiled.text!, password: self.passwordField.text!, completion: {(user, error) in
                if error == nil{
                    self.showAlerts(title: "Success!", message: "Welcome Back!", handler: {
                        UIAlertAction in
                        self.loginSuccess()
                    })
                    //self.showAlerts(title: "Success", message: "Welcome Back!")
                    //self.loginSuccess()
                }
                else {
                    self.showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil)
                }
            })
        }
    }
    
    
    @IBAction func emailregisterAction(_ sender: AnyObject) {
        
        //If nothing is typed
        if self.emailFiled.text == "" || self.passwordField.text == ""
        {
            self.showAlerts(title: "Oops!", message: "Please enter your email address and password!", handler: nil)

        }
        //Create an account
        else{
            FIRAuth.auth()?.createUser(withEmail: self.emailFiled.text!, password: self.passwordField.text!, completion: {(user, error) in
                if error == nil{
                    
                    self.showAlerts(title: "Success!", message: "Your ccount is successfully created! You can sign in now!", handler: nil)
                }
                else {
                    self.showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil)
                }
            })
        }
    }
    
    //TextFields Edit
    
    func showAlerts(title: String, message: String, handler: ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .cancel, handler: handler)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func applyMotionEffect (toView view:UIView, magnitude:Float){
        let xMotion = UIInterpolatingMotionEffect(keyPath:"center.x", type:.tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath:"center.y", type:.tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion,yMotion]
        
        
        view.addMotionEffect(group)
        
        
    }
    


    //Facebook Login Button Delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {

        /*if error == nil{
            print(error!.localizedDescription)
            return
        }*/
        // link with Firebase!
        if let _ = FBSDKAccessToken.current(){
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            if error == nil{
                //self.showAlerts(title: "Success", message: "Welcome Back!")
                self.loginSuccess()
                
            }
            else {
                self.showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil)
            }
        })
        print("successfully logged in with Facebook")
        }
        
        
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    


    
}
// Hide the keyboard when tapping around
/*extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}*/
