//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by Uday on 19/10/22.
//

import Foundation

struct Transaction {
    let id: String
    let institution, account, merchant: String
    let date: Date
    let amount: Double
    let type: String
    let categoryID: Int
    let category: String
    let isPending, isTransfer, isExpense, isEdited: Bool
}
