//
//  ThirdViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController,UICollisionBehaviorDelegate {
    
    let data = ["Raffle Item 1", "Raffle Item 2", "Raffle Item 3", "Raffle Item 4"]
    
    
    var views = [UIView]()
    var animator:UIDynamicAnimator!
    var gravity:UIGravityBehavior!
    var snap:UISnapBehavior!
    var previousTouchPoint:CGPoint!
    var viewDragging = false
    var viewPinned = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //
        animator = UIDynamicAnimator(referenceView:self.view)
        gravity = UIGravityBehavior()
        
        animator.addBehavior(gravity)
        gravity.magnitude = 4
        
        var offset:CGFloat = 250
        
        for i in 0 ... data.count - 1 {
            if let view = addViewController(atOffset: offset, dataForVC: data[i] as AnyObject?){
                views.append(view)
                offset -= 50
            }
        }
        //
        
        
    }
    
    func addViewController(atOffset offset:CGFloat, dataForVC:AnyObject?)->UIView?{
        let frameForView = self.view.bounds.offsetBy(dx:0, dy:self.view.bounds.size.height - offset)
        
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let stackElementVC = sb.instantiateViewController(withIdentifier: "ProfileStackElement") as! ProfileStackElementViewController
        
        
        
        if let view = stackElementVC.view{
            view.frame = frameForView
            view.layer.cornerRadius = 5
            view.layer.shadowOffset = CGSize(width:2, height:2)
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.5
            
            
            if let headerStr = dataForVC as? String{
                stackElementVC.headerString = headerStr
            }
            
            self.addChildViewController(stackElementVC)
            self.view.addSubview(view)
            stackElementVC.didMove(toParentViewController: self)
            
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ThirdViewController.handlePan(gestureRecognizer:)))
            view.addGestureRecognizer(panGestureRecognizer)
            
            
            let collision = UICollisionBehavior(items:[view])
            collision.collisionDelegate = self
            animator.addBehavior(collision)
            
            let boundary = view.frame.origin.y + view.frame.size.height
            
            
            //lower boundary
            var boundaryStart = CGPoint(x:0, y:boundary)
            var boundaryEnd = CGPoint(x:self.view.bounds.size.width, y: boundary)
            collision.addBoundary(withIdentifier: 1 as NSCopying, from:boundaryStart, to:boundaryEnd)
            
            //upper boundary
            boundaryStart = CGPoint(x:0, y:0)
            boundaryEnd = CGPoint(x:self.view.bounds.size.width, y:0)
            collision.addBoundary(withIdentifier:2 as NSCopying, from:boundaryStart, to:boundaryEnd)
            
            
            gravity.addItem(view)
            
            let itemBehavior = UIDynamicItemBehavior(items:[view])
            animator.addBehavior(itemBehavior)
            
            return view
            
        }
        return nil
    }
    
    
    
    
    func handlePan(gestureRecognizer:UIPanGestureRecognizer){
        
        let touchPoint = gestureRecognizer.location(in: self.view)
        let draggedView = gestureRecognizer.view!
        
        if gestureRecognizer.state == .began {
            let dragStartPoint = gestureRecognizer.location(in: draggedView)
            
            if dragStartPoint.y < 200 {
                viewDragging = true
                previousTouchPoint = touchPoint
            }
            
        } else if gestureRecognizer.state == .changed && viewDragging {
            let yOffset = previousTouchPoint.y - touchPoint.y
            
            draggedView.center = CGPoint(x: draggedView.center.x, y: draggedView.center.y - yOffset)
            previousTouchPoint = touchPoint
        }else if gestureRecognizer.state == .ended && viewDragging {
            
            pin(view: draggedView)
            addVelocity(toView: draggedView, fromGestureRecognizer: gestureRecognizer)
            
            animator.updateItem(usingCurrentState: draggedView)
            viewDragging = false
            
        }
        
    }
    
    func pin (view:UIView) {
        
        let viewHasReachedPinLocation = view.frame.origin.y < 100
        
        if viewHasReachedPinLocation {
            if !viewPinned {
                var snapPosition = self.view.center
                snapPosition.y += 30
                
                snap = UISnapBehavior(item: view, snapTo: snapPosition)
                animator.addBehavior(snap)
                
                setVisibility(view: view, alpha: 0)
                
                viewPinned = true
                
                
            }
        }else{
            if viewPinned {
                animator.removeBehavior(snap)
                setVisibility(view: view, alpha: 1)
                viewPinned = false
            }
        }
        
        
    }
    
    func setVisibility (view:UIView, alpha:CGFloat) {
        for aView in views {
            if aView != view {
                aView.alpha = alpha
            }
        }
    }
    
    
    
    func addVelocity (toView view:UIView, fromGestureRecognizer panGesture:UIPanGestureRecognizer) {
        var velocity = panGesture.velocity(in: self.view)
        velocity.x = 0
        
        if let behavior = itemBehavior(forView: view) {
            behavior.addLinearVelocity(velocity, for: view)
        }
        
        
    }
    
    
    func itemBehavior (forView view:UIView) -> UIDynamicItemBehavior? {
        for behavior in animator.behaviors {
            if let itemBehavior = behavior as? UIDynamicItemBehavior {
                if let possibleView = itemBehavior.items.first as? UIView, possibleView == view {
                    return itemBehavior
                }
            }
        }
        
        return nil
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        if NSNumber(integerLiteral: 2).isEqual(identifier) {
            let view = item as! UIView
            pin(view: view)
        }
        
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
