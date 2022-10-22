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
        self.title = "Expense Tracker"
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        setupLogOutButton()
        fetchAllTranscationAndReloadTableView()
    }
    
    func fetchAllTranscationAndReloadTableView(){
        transactions = DBManager.shared.fetchTransactions()
        transactionTableView.reloadData()
    }
    
    func setupLogOutButton() {
        let logOutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = logOutButton
    }
    
    @objc func logOutButtonTapped() {
        askUserforLogoutConfirmation()
    }
    
    func askUserforLogoutConfirmation(){
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            Utility.setUserLoginStatus(false)
            Utility.setRootViewController()
        }
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func addNewTransactionButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddNewTransaction", bundle: .main)
        guard let addNewTransactionVC = storyboard.instantiateViewController(withIdentifier: "AddNewTransactionViewController") as? AddNewTransactionViewController else {return}
        addNewTransactionVC.delegate = self
        self.present(addNewTransactionVC, animated: true)
    }
    
    @IBAction func showAllTransactionButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AllTransactions", bundle: .main)
        guard let allTransactionVC = storyboard.instantiateViewController(withIdentifier: "AllTransactionsViewController") as? AllTransactionsViewController else {return}
        allTransactionVC.transactions = transactions
        self.navigationController?.pushViewController(allTransactionVC, animated: true)
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
    func addedNewTransaction() {
        fetchAllTranscationAndReloadTableView()
    }
}
