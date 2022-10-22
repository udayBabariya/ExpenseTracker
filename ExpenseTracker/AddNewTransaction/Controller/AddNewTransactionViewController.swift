//
//  AddNewTransactionViewController.swift
//  ExpenseTracker
//
//  Created by Uday on 19/10/22.
//

import UIKit

protocol addNewTransactionDelegate {
    func addedNewTransaction()
}

class AddNewTransactionViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var institutionTextField: UITextField!
    @IBOutlet weak var merchantTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    var delegate: addNewTransactionDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let institute = institutionTextField.text ?? ""
        let amount = Double(amountTextField.text ?? "0") ?? 0.0
        let account = accountTextField.text ?? ""
        let merchant = merchantTextField.text ?? ""
        let category = categoryTextField.text ?? ""
 
        let transaction = Transaction(context: DBManager.shared.context)
        transaction.institute = institute
        transaction.amount = amount
        transaction.account = account
        transaction.merchant = merchant
        transaction.category = category
        DBManager.shared.saveContext()
        delegate?.addedNewTransaction()
        self.dismiss(animated: true)
    }
}
