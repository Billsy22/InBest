//
//  NewBudgetViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class NewBudgetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    // MARK: -  Properties
    @IBOutlet weak var budgetPicker: UIPickerView!
    @IBOutlet weak var newBudgetButton: UIButton!
    let pickerData = ["Select Amount", "500.00", "600.00", "700.00", "800.00", "900.00", "1000.00", "1100.00", "1200.00", "1300.00", "1400.00", "1500.00", "1600.00", "1700.00", "1800.00", "1900.00", "2000.00", "2100.00", "2200.00", "2300.00", "2400.00", "2500.00", "2600.00", "2700.00", "2800.00", "2900.00", "3000.00", "3100.00", "3200.00", "3300.00", "3400.00", "3500.00", "3600.00", "3700.00", "3800.00", "3900.00", "4000.00", "4100.00", "4200.00", "4300.00", "4400.00", "4500.00", "4600.00", "4700.00", "4800.00", "4900.00", "5000.00"]
    var amountPicked: Double = 0
    var budget: Budget?
    
    // MARK: -  LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.budgetPicker.delegate = self
        self.budgetPicker.dataSource = self
        self.newBudgetButton.isEnabled = false
    }
    
    // MARK: -  Picker Delegate/DataSource Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[row] == "Select Amount" {
            newBudgetButton.isEnabled = false
        } else {
            newBudgetButton.isEnabled = true
            guard let pickerData = Double(pickerData[row]) else { return }
            amountPicked = pickerData
        }
    }

    // MARK: -  Actions
    @IBAction func createBudgetButtonTapped(_ sender: Any) {
        print("The picker selected: \(amountPicked)")
        BudgetController.shared.createBudgetOn(date: Date(), initialAmount: amountPicked)
        navigationController?.popViewController(animated: true)
    }
}
