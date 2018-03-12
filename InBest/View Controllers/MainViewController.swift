//
//  MainViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/12/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: -  Properties
    @IBOutlet weak var moneyImageView: UIImageView!
    @IBOutlet weak var moneyImageHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var moneyImageWidthConstraint: NSLayoutConstraint!
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
       animateMoneyImageView()
        
    }

    func animateMoneyImageView() {
        UIView.animate(withDuration: 4.0, animations: {
            let originPoint = self.moneyImageView.center
            self.moneyImageView.frame.size.height *= 5
            self.moneyImageView.frame.size.width *= 5
            self.moneyImageView.center = originPoint
        }) { (_) in
            
            UIView.animate(withDuration: 4.0, animations: {
                let originPoint = self.moneyImageView.center
                self.moneyImageView.frame.size.height /= 5
                self.moneyImageView.frame.size.width /= 5
                self.moneyImageView.center = originPoint
            }) { (_) in
                self.animateMoneyImageView()
                
            }
    }
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
