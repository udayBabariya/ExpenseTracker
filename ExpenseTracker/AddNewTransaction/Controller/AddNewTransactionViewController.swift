//
//  AddNewTransactionViewController.swift
//  ExpenseTracker
//
//  Created by Uday on 19/10/22.
//

import UIKit

protocol addNewTransactionDelegate {
    func addNewTransaction(trnasaction: Transaction)
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
        let id = UUID().uuidString
        let institute = institutionTextField.text ?? ""
        let amount = Double(amountTextField.text ?? "0") ?? 0.0
        let account = accountTextField.text ?? ""
        let merchant = merchantTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        
//        let transcation = Transaction(id: id, institution: institute, account: account, merchant: merchant, date: Date(), amount: amount, type: "", categoryID: 0, category: category, isPending: false, isTransfer: false, isExpense: true, isEdited: false)
//        delegate?.addNewTransaction(trnasaction: transcation)
        self.dismiss(animated: true)
    }
}
