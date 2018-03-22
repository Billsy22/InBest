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
    
    private let hasCreatedScreenNameKey = "hasCreatedScreenName"
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        showCreateScreenNameAlert()
        CustomUserController.shared.fetchCurrentUser {
            BudgetController.shared.load()
        }
        CompanyController.shared.loadAllCompanies()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateMoneyImageView()
    }
    
    func animateMoneyImageView() {
        moneyImageView.frame.size.height = 60
        moneyImageView.frame.size.width = 30
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
    
    
    
    func showCreateScreenNameAlert() {
        guard UserDefaults.standard.bool(forKey: hasCreatedScreenNameKey) != true else { return }
        let alert = UIAlertController(title: "Welcome", message: "Please pick a screen name. This can not be changed.", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Screen Name..."
        }
        let enter = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let textFields = alert.textFields else { return }
            guard let screenName = textFields.first?.text, !screenName.isEmpty else { return }
            CustomUserController.shared.createUserWith(screenName: screenName, completion: {
                UserDefaults.standard.set(true, forKey: self.hasCreatedScreenNameKey)
                print("CustomUser Created")
            })
        }
        alert.addAction(enter)
        present(alert, animated: true, completion: nil)
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
