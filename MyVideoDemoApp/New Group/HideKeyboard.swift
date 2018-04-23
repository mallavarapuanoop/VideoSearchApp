//
//  HideKeyboard.swift
//  MyVideoDemoApp
//
//  Created by Anoop Mallavarapu on 4/21/18.
//  Copyright © 2018 AnoopMallavarapu. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


