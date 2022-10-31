//
//  TransactionTableViewCell.swift
//  ExpenseTracker
//
//  Created by Uday on 19/10/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(transaction: Transaction) {
        accountLabel.text = transaction.account
        amountLabel.text = String(transaction.amount)
        categoryLabel.text = transaction.category
        
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        dateLabel.text = df.string(from: transaction.date ?? Date())
    }
}
