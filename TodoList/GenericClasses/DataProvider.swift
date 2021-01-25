// DataProvider.swift

import Foundation
import CoreData

protocol DataProviderDelegate: class {
    func didInsertItem(at indexPath: IndexPath)
    func didDeleteItem(at indexPath: IndexPath)
}

final class DataProvider<Model: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    
    weak var delegate: DataProviderDelegate?
    
    private var managedObjectContext: NSManagedObjectContext
    private var sortDescriptors: [NSSortDescriptor]
    private var predicate: NSPredicate?
    
    private lazy var request: NSFetchRequest<Model> = {
        let request = NSFetchRequest<Model>(entityName: String(describing: Model.self))
        request.sortDescriptors = sortDescriptors
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Model> = {
        let fetchedResults = NSFetchedResultsController<Model>(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResults.delegate = self
        return fetchedResults
    }()
    
    init(managedObjectContext: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil) {
        self.managedObjectContext = managedObjectContext
        self.sortDescriptors = sortDescriptors
        self.predicate = predicate
        
        super.init()
        
        performFetch()
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func objectAtIndex(indexPath: IndexPath) -> Model {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func rowsInSection(section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let item = objectAtIndex(indexPath: indexPath)
        managedObjectContext.delete(item)
        do {
            try managedObjectContext.save()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            if let idxPath = newIndexPath {
                delegate?.didInsertItem(at: idxPath)
            }
        } else if type == .delete {
            if let idxPath = indexPath {
                delegate?.didDeleteItem(at: idxPath)
            }
        }
    }
}
