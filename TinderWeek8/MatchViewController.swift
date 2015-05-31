//
//  MatchViewController.swift
//  TinderWeek8
//
//  Created by Kunwardeep Gill on 2015-05-29.
//  Copyright (c) 2015 ProjectDGW. All rights reserved.
//

import Foundation
import UIKit

class MatchViewController:UIViewController {
  


  
  @IBOutlet weak var imageView: UIImageView!
  override func viewDidLoad() {
    view.backgroundColor = UIColor.yellowColor()
    self.imageView.layer.cornerRadius = 5
    self.imageView.image = UIImage(named:"match")
  }
  
  override func viewWillAppear(animated: Bool) {
  }
  
  
  @IBAction func awesomeSauceButtonPressed(sender: UIButton) {
    if((self.presentingViewController) != nil){
      self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //self.performSegueWithIdentifier("returnToMain", sender: nil)

    
  }
  
  
}