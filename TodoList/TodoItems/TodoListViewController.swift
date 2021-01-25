// TodoListViewController.swift

import UIKit

final class TodoListViewController: UIViewController {
    
    var folder: String
    
    private lazy var tableView: GenericTableView<TodoTableViewCell, Todo> = {
        let sortD = [NSSortDescriptor(key: "title", ascending: true)]
        let predicate = NSPredicate(format: "folder == %@", folder)
        
        let dataProvider = DataProvider<Todo>(managedObjectContext: CoreDataManager.shared.managedObjectContext, sortDescriptors: sortD, predicate: predicate)
        
        let v = GenericTableView<TodoTableViewCell, Todo>(dataProvider: dataProvider) { (cell, todo) in
            cell.model = todo
        } selectionHandler: { (todo) in
            print("\(todo.title ?? "") selected")
        }
        
        return v
    }()
    
    private lazy var addNewItem: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 32.0, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        v.setImage(image, for: .normal)
        v.tintColor = .white
        v.backgroundColor = .blue
        v.layer.cornerRadius = 10
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        v.addTarget(self, action: #selector(didTapAdd(_:)), for: .touchUpInside)
        return v
    }()
    
    init(folder: String) {
        self.folder = folder
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        tableView.performFetch()
    }
    
    private func setupView() {
        title = folder
        view.addSubview(tableView)
        view.addSubview(addNewItem)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // table view
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // add new
        NSLayoutConstraint.activate([
            addNewItem.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addNewItem.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNewItem.widthAnchor.constraint(equalToConstant: 44),
            addNewItem.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapAdd(_ sender: UIButton) {
        let vc = AddNewItemViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension TodoListViewController: AddNewItemViewControllerDelegate {
    func saveNewItem(item: String) {
        CoreDataManager.shared.saveTodo(folder: folder, todoItem: item)
        tableView.performFetch()
    }
}

