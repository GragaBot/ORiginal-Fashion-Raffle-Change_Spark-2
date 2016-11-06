//
//  FirstViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    var demoFeatures :[DemoFeature] = []
    //var willEnterForegroundObserver: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        //willEnterForegroundObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.current) { _ in}
        
        
        var demoFeature = DemoFeature.init(
            name: "Yeezy Boost 350",
            detail: "Yeezy Boost 350 with USB chargable LED lignts",
            image: "Yeezy_Boost_Nize", storyboard: "FirstDemo", identifier: "YeezyView")
        
        demoFeatures.append(demoFeature)
        
        demoFeature = DemoFeature.init(
            name: "Anti Social Social Club",
                                    
            detail: "",
                                      
            image: "Anti_Social", storyboard: "FirstDemo", identifier: "AntiSocialView")
        
        demoFeatures.append(demoFeature)
 
    }
    
    //deinit {
       // NotificationCenter.default.removeObserver(willEnterForegroundObserver)
   // }



    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainView")!
        let demoFeature = demoFeatures[indexPath.row]
        cell.imageView!.image = UIImage(named: demoFeature.image)
        cell.textLabel!.text = demoFeature.displayName
        cell.detailTextLabel!.text = demoFeature.detailText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoFeatures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let demoFeature = demoFeatures[ indexPath.row]
        let storyboard = UIStoryboard(name: demoFeature.storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: demoFeature.identifier)
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
