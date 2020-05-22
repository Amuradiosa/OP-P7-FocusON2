//
//  BaseTabBarControllerViewController.swift
//  FocusOn
//
//  Created by Ahmad Murad on 22/05/2020.
//  Copyright © 2020 Ahmad Murad. All rights reserved.
//

import UIKit

class BaseTabBarControllerViewController: UITabBarController {
  
  @IBInspectable var defaultIndex: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    selectedIndex = defaultIndex
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
