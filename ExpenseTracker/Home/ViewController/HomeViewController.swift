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
    var reversedTransactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Expense Tracker"
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        setupLogOutButton()
        fetchAllTranscationAndReloadTableView()
        setupChartView()
        upadteChartFromTransactions(transactions)
    }
 
    func upadteChartFromTransactions(_ transactions: [Transaction]) {
        var chartDataEntry: [ChartDataEntry] = []
        var dateWiseTransactions: [Date:Double] = [:]
        var dateArray: [Date] = []
        for trans in transactions {
            if let amount =  dateWiseTransactions[trans.date] {
                dateWiseTransactions[trans.date] = amount + trans.amount
            }else{
                dateWiseTransactions[trans.date] = trans.amount
            }
            if !dateArray.contains(trans.date) { dateArray.append(trans.date)}
        }
        for (index,date) in dateArray.enumerated() {
            chartDataEntry.append(ChartDataEntry(x: Double(index), y: dateWiseTransactions[date] ?? 0.0))
        }
        
        let set1 = LineChartDataSet(entries: chartDataEntry, label: "transactions")
        set1.drawCirclesEnabled = false
        let data = LineChartData(dataSet: set1)
        lineChartsView.data = data
        let df = DateFormatter()
        df.dateFormat = "dd MMM yy"
        lineChartsView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray.map({df.string(from: $0)}))
        lineChartsView.xAxis.granularity = 1
    }
    
    func fetchAllTranscationAndReloadTableView(){
        transactions = DBManager.shared.fetchTransactions().sorted(by: {$0.date < $1.date})
        reversedTransactions = DBManager.shared.fetchTransactions().reversed()
        transactionTableView.reloadData()
    }
    
    func setupLogOutButton() {
        let logOutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logOutButtonTapped))
        self.navigationItem.rightBarButtonItem = logOutButton
    }
    
    func setupChartView(){
        lineChartsView.animate(xAxisDuration: 1)
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
        if reversedTransactions.count >= 5 {
            return 5
        }else{
            return reversedTransactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as? TransactionTableViewCell else {return UITableViewCell()}
        let transaction = reversedTransactions[indexPath.row]
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
        upadteChartFromTransactions(transactions)
    }
}


extension HomeViewController: allTransactionProtocol {
    func deletedTransaction() {
        fetchAllTranscationAndReloadTableView()
        upadteChartFromTransactions(transactions)
    }
}

