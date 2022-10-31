//
//  Transaction+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Uday on 22/10/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var account: String?
    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var categoryId: String?
    @NSManaged public var date: Date!
    @NSManaged public var id: UUID?
    @NSManaged public var institute: String?
    @NSManaged public var isEdited: Bool
    @NSManaged public var isExpanse: Bool
    @NSManaged public var isPending: Bool
    @NSManaged public var isTransfer: Bool
    @NSManaged public var merchant: String?

}

extension Transaction : Identifiable {

}
