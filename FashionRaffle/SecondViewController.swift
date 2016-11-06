//
//  SecondViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,FBSDKLoginButtonDelegate {


    @IBOutlet var userImage: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var emailSignOutButton: UIButton!
    @IBAction func emailSignOut(_ sender: AnyObject) {
        //self.logOut()
        //try! FIRAuth.auth()?.signOut()
        
        let refreshAlert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out?", preferredStyle: .alert)
      
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) -> Void in
            try! FIRAuth.auth()?.signOut()
            self.logOut()
            
        }))
        present(refreshAlert, animated: true, completion: nil)
        
}

    @IBOutlet var fbLoginButton : FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        //button.readPermissions = ["email"]
        return button
    }()
    
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    func logOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.present(loginVC, animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        print("Logged Out!")
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        fbLoginButton.delegate = self
        
        if FBSDKAccessToken.current() == nil{
            self.fbLoginButton.isHidden = true
            self.emailSignOutButton.isHidden = false
            if let user = FIRAuth.auth()?.currentUser{
                let email = user.email
                let name = user.displayName
                self.userID.text = email
                self.userName.text = name
                
                
                
                self.userImage.image = UIImage(named:"UserIcon")
                
                self.userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
                self.userImage.isUserInteractionEnabled = true
                
                
                
                
                //var userImage: UIImageView = {
                  //  let userImage = UIImageView()
                    //self.userImage.image = UIImage(named: "UserIcon")
                    //self.userImage.contentMode = .scaleAspectFill
                    
                   // self.userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
                    //self.userImage.isUserInteractionEnabled = true
                    
                   // return userImage
                    
                //}
                
            
            }
            else {
                self.userName.text = "You are not signed in"
                self.userID.text = ""
            }
        }
        else {
            self.fbLoginButton.isHidden = false
            self.emailSignOutButton.isHidden = true
            if let user = FIRAuth.auth()?.currentUser{
                for profile in user.providerData{
                    let name = profile.displayName
                    let email = profile.email
                    let photoURL = profile.photoURL
                    
                    self.userID.text = email
                    self.userName.text = name
                    
                    if let url = photoURL {
                        if let image = SecondViewController.imageCache.object(forKey: url as AnyObject) as? UIImage {
                            userImage.image = image
                        }
                        else {
                            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                                if (error != nil){
                                    print(error)
                                    return
                                }
                                let image = UIImage(data: data!)
                                SecondViewController.imageCache.setObject(image!, forKey: url as AnyObject)
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.userImage.image = image
                                })
                            }).resume()
                        }
                    }
                }
                
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func handleSelectProfileImageView() {
        print(123)
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.userImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()?.signOut()
        self.logOut()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

}

