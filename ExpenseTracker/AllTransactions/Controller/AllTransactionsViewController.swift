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
    var transactionByMonth: [String: [Transaction]] = [:] // ["Feb": [T1,T2,T3,T4], "July" :[T5,T6...]]
    var months: [Date] = []
    let dateFormatter = DateFormatter()
  
    
    var delegate: allTransactionProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Transactions"
        dateFormatter.dateFormat = "MMM"
        allTransactionsTableView.delegate = self
        allTransactionsTableView.dataSource = self
        prepareMonthWiseTransactions()
        allTransactionsTableView.reloadData()
    }
    
    func prepareMonthWiseTransactions() {
        
        for transaction in transactions {
            let month = dateFormatter.string(from: transaction.date)
            if transactionByMonth[month] != nil {
                transactionByMonth[month]?.append(transaction)
            } else {
                transactionByMonth[month] = [transaction]
            }
            
            guard let firstDateOfMonth = transaction.date.getStart(of: .month) else {
                fatalError("Not able to get first date of month")
            }
            if !months.contains( firstDateOfMonth) {
                months.append(firstDateOfMonth)
            }
        }
        months = months.sorted()
    }
}

extension AllTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = dateFormatter.string(from: months[section])
        return transactionByMonth[month]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as? TransactionTableViewCell else {return UITableViewCell()}
        let month = dateFormatter.string(from: months[indexPath.section])
        guard let transactionsForMonth = transactionByMonth[month] else { return UITableViewCell() }
        cell.configureCell(transaction: transactionsForMonth[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: months[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension Date {

    func getStart(of component: Calendar.Component, calendar: Calendar = Calendar.current) -> Date? {
        return calendar.dateInterval(of: component, for: self)?.start
    }
}
