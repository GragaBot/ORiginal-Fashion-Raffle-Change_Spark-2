//
//  ProfileStackElementViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class ProfileStackElementViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var addressManagementHeader: UILabel!
    
    //purchase
    @IBOutlet weak var purchaseButton: UIButton!
    
    let transition = CircularTransition()
    
    
    var headerString:String?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        addressManagementHeader.text = headerString

    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        purchaseButton.layer.cornerRadius = purchaseButton.frame.size.width / 2
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! PurchaseViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = purchaseButton.center
        transition.circleColor = purchaseButton.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = purchaseButton.center
        transition.circleColor = purchaseButton.backgroundColor!
        
        return transition
    }

    

}
