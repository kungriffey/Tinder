//
//  SwipeViewController.swift
//  TinderWeek8
//
//  Created by Kunwardeep Gill on 2015-05-27.
//  Copyright (c) 2015 ProjectDGW. All rights reserved.
//

import Foundation
import UIKit

class SwipeViewController : UIViewController, FBSDKLoginButtonDelegate{
  
  override func viewDidLoad() {

  
    let fbLoginButton : FBSDKLoginButton = FBSDKLoginButton()
    self.view.addSubview(fbLoginButton)
    self.view.bringSubviewToFront(fbLoginButton)
    fbLoginButton.center = CGPoint(x: view.center.x, y: view.frame.size.height - view.frame.size.height / 8)
    fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
    fbLoginButton.delegate = self
  
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
              //println("[DEBUG] url is \(url)")
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
  
  
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {}
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    PFUser.logOut()
    presentViewController(ViewController(), animated: true, completion: nil)
  }
  
  
  
  
}



