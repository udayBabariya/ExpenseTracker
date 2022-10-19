//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Uday on 19/10/22.
//

import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var addNewTransactionButton: UIButton!
    
    var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
//        createDummyTransactions()
    }
    
//    func createDummyTransactions(){
//        let t1 = Transaction(id: 0, date: "11-10-2022", institution: "abc", account: "test", merchant: "xyz", amount: 99.78, type: "credit", categoryID: 1, category: "Public Transportation", isPending: true, isTransfer: false, isExpense: true, isEdited: false)
//
//        let t2 = Transaction(id: 0, date: "11-10-2022", institution: "abc", account: "test", merchant: "xyz", amount: 20.85, type: "credit", categoryID: 1, category: "Public Transportation", isPending: true, isTransfer: false, isExpense: true, isEdited: false)
//
//        let t3 = Transaction(id: 0, date: "11-10-2022", institution: "abc", account: "test", merchant: "xyz", amount: 86.00, type: "credit", categoryID: 1, category: "Public Transportation", isPending: true, isTransfer: false, isExpense: true, isEdited: false)
//        transactions = [t1,t2,t3]
//    }
    
    @IBAction func addNewTransactionButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddNewTransaction", bundle: .main)
        guard let addNewTransactionVC = storyboard.instantiateViewController(withIdentifier: "AddNewTransactionViewController") as? AddNewTransactionViewController else {return}
        addNewTransactionVC.delegate = self
        self.present(addNewTransactionVC, animated: true)
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as? TransactionTableViewCell else {return UITableViewCell()}
        let transaction = transactions[indexPath.row]
        cell.configureCell(transaction: transaction)
        return cell
    }
}

extension HomeViewController: addNewTransactionDelegate {
    func addNewTransaction(trnasaction: Transaction) {
        transactions.append(trnasaction)
        transactionTableView.reloadData()
    }
}
