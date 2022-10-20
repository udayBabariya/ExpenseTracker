//
//  AllTransactionsViewController.swift
//  ExpenseTracker
//
//  Created by Uday on 20/10/22.
//

import UIKit

class AllTransactionsViewController: UIViewController {
    
    @IBOutlet weak var allTransactionsTableView: UITableView!
    
    var transactions: [Transaction] = []
    
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
    
    
}
