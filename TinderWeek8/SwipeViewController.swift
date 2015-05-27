//
//  SwipeViewController.swift
//  TinderWeek8
//
//  Created by Kunwardeep Gill on 2015-05-27.
//  Copyright (c) 2015 ProjectDGW. All rights reserved.
//

import Foundation
import UIKit

class SwipeViewController : UIViewController {
  
  override func viewDidLoad() {

    let data:NSData
    let imgURL = NSURL(string: "")
  

  
  }
  
  
  @IBOutlet var profileImageView: UIImageView!
  
  override func viewWillAppear(animated: Bool) {
    var query = PFUser.query()!
    query.selectKeys(["photoURL"])
    println(query)
    query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
//      println("objects: \(objects)")
      if let result = objects {
        for object in result {
          if let user = object as? PFUser,
            let url = user["photoURL"] as? String{
              println("[DEBUG] url is \(url)")
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                if let data = NSData(contentsOfURL: NSURL(string: url)!){
                  dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    let image = UIImage(data: data)
                    self.profileImageView.image = image
                  })
                }
              })
          }
        }
      }
    }
  }
}
