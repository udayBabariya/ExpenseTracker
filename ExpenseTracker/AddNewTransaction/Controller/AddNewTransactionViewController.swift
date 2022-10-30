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
    @IBOutlet weak var dateTextField: UITextField!
    
    var delegate: addNewTransactionDelegate? = nil
    
    private lazy var datePicker: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
      datePicker.datePickerMode = .date
      datePicker.timeZone = TimeZone.current
        datePicker.preferredDatePickerStyle = .wheels
      return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        accountTextField.text = "account"
//        institutionTextField.text = "institute"
//        merchantTextField.text = "merchant"
//        amountTextField.text = "1"
//        categoryTextField.text = "cat"
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        dateTextField.inputAccessoryView = toolBar
    }
    
    @objc func datePickerDone() {
          dateTextField.resignFirstResponder()
      }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd MMM yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
     }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let institute = institutionTextField.text ?? ""
        let amount = Double(amountTextField.text ?? "0") ?? 0.0
        let account = accountTextField.text ?? ""
        let merchant = merchantTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        let date = dateTextField.text ?? ""
        
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
 
        let transaction = Transaction(context: DBManager.shared.context)
        transaction.institute = institute
        transaction.amount = amount
        transaction.account = account
        transaction.merchant = merchant
        transaction.category = category
        transaction.date = df.date(from: date) ?? Date()
        DBManager.shared.saveContext()
        delegate?.addedNewTransaction()
        self.dismiss(animated: true)
    }
}
