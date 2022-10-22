//
//  DBManager.swift
//  ExpenseTracker
//
//  Created by Uday on 22/10/22.
//

import Foundation
import CoreData

class DBManager {
    
    static let shared = DBManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExpenseTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    lazy var context = persistentContainer.viewContext
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func fetchTransactions() -> [Transaction] {
        var transactions: [Transaction] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        do{
            transactions = try context.fetch(fetchRequest) as! [Transaction]
        }catch{
            print("Fetch Error")
        }
        return transactions
    }
}
