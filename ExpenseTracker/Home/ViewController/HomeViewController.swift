//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Uday on 19/10/22.
//

import UIKit
import Charts

class HomeViewController: UIViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var addNewTransactionButton: UIButton!
    @IBOutlet weak var lineChartsView: LineChartView!
    
    var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Expense Tracker"
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        setupLogOutButton()
        fetchAllTranscationAndReloadTableView()
        setupChartView()
    }
    
    let yValues: [ChartDataEntry] = {[
        ChartDataEntry(x: 1.0, y: 10.0),
        ChartDataEntry(x: 2.0, y: 12.0),
        ChartDataEntry(x: 3.0, y: 14.0),
        ChartDataEntry(x: 5.0, y: 10.0),
        ChartDataEntry(x: 6.0, y: 6.0)
        ]
    }()
    
    func fetchAllTranscationAndReloadTableView(){
        transactions = DBManager.shared.fetchTransactions()
        transactionTableView.reloadData()
    }
    
    func setupLogOutButton() {
        let logOutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = logOutButton
    }
    
    func setupChartView(){
        let set1 = LineChartDataSet(entries: yValues, label: "transactions")
        set1.drawCirclesEnabled = false
        let data = LineChartData(dataSet: set1)
        lineChartsView.data = data
        lineChartsView.animate(xAxisDuration: 2)
        lineChartsView.rightAxis.enabled = false
        lineChartsView.xAxis.labelPosition = .bottom
        lineChartsView.xAxis.drawGridLinesEnabled = false
        lineChartsView.leftAxis.drawGridLinesEnabled = false
     
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
        allTransactionVC.delegate = self
        self.navigationController?.pushViewController(allTransactionVC, animated: true)
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactions.count >= 5 {
            return 5
        }else{
            return transactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as? TransactionTableViewCell else {return UITableViewCell()}
        let transaction = transactions[indexPath.row]
        cell.configureCell(transaction: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: addNewTransactionDelegate {
    func addedNewTransaction() {
        fetchAllTranscationAndReloadTableView()
    }
}


extension HomeViewController: allTransactionProtocol {
    func deletedTransaction() {
        fetchAllTranscationAndReloadTableView()
    }
}


extension HomeViewController: ChartViewDelegate {
    
}
