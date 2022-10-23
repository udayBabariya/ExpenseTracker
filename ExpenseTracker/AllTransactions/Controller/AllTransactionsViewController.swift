//
//  AllTransactionsViewController.swift
//  ExpenseTracker
//
//  Created by Uday on 20/10/22.
//

import UIKit

protocol allTransactionProtocol {
    func deletedTransaction()
}

class AllTransactionsViewController: UIViewController {
    
    @IBOutlet weak var allTransactionsTableView: UITableView!
    
    var transactions: [Transaction] = []
    var delegate: allTransactionProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Transactions"
        allTransactionsTableView.delegate = self
        allTransactionsTableView.dataSource = self
    }
    
}

extension AllTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as? TransactionTableViewCell else {return UITableViewCell()}
        cell.configureCell(transaction: transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DBManager.shared.deleteTransaction(transactions[indexPath.row])
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            delegate?.deletedTransaction()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
