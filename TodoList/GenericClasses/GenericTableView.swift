// GenericTableView.swift

import UIKit
import CoreData

final class GenericTableView<Cell: UITableViewCell, Model: NSManagedObject>: UITableView, UITableViewDelegate {
    private var cellId = String(describing: Cell.self)
    private var configCell: (Cell, Model) -> Void
    private var selectionHandler: (Model) -> Void
    
    private var dataProvider: DataProvider<Model>
    
    private lazy var modelDataSource: DataSource<Cell, Model> = {
        return DataSource<Cell, Model>(cellId: cellId, dataProvider: dataProvider, configCell: configCell)
    }()
    
    init(dataProvider: DataProvider<Model>, configCell: @escaping (Cell, Model) -> Void, selectionHandler: @escaping (Model) -> Void) {
        self.dataProvider = dataProvider
        self.configCell = configCell
        self.selectionHandler = selectionHandler
        
        super.init(frame: .zero, style: .plain)
        
        self.delegate = self
        self.dataSource = modelDataSource
        self.register(Cell.self, forCellReuseIdentifier: cellId)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tableFooterView = UIView()
        self.modelDataSource.tableView = self
        performFetch()
    }
    
    func performFetch() {
        dataProvider.performFetch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataProvider.objectAtIndex(indexPath: indexPath)
        selectionHandler(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
