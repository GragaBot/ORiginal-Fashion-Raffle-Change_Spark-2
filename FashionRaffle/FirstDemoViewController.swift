//
//  FirstDemoViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/1/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation

class YeezyViewController: UIViewController{
    
    
    //@IBOutlet weak var yeezyTextField: UITextView!
    
    @IBAction func notificationAction(_ sender: AnyObject) {
        showAlerts(title: "Cool", message: "Your Notification has been set!", handler: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        //navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BackButton"), style: .plain, target: nil, action: nil)
        
        //yeezyTextField.contentInset = UIEdgeInsetsMake(-4, -4, -4, -4)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //yeezyTextField.flashScrollIndicators()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func showAlerts(title: String, message: String, handler: ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .cancel, handler: handler)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}





class AntiSocialViewController: UIViewController{
    
    //@IBOutlet weak var antiSocialTextField: UITextView!
    

    @IBAction func notificate(_ sender: AnyObject) {
        showAlerts(title: "Cool", message: "Your Notification has been set!", handler: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        //antiSocialTextField.contentInset = UIEdgeInsetsMake(-4, -4, -4, -4)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //antiSocialTextField.flashScrollIndicators()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func showAlerts(title: String, message: String, handler: ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .cancel, handler: handler)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
