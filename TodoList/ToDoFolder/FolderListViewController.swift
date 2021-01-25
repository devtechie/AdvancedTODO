// FolderListViewController.swift

import UIKit
import CoreData

final class FolderListViewController: UIViewController {
    
    private lazy var tableView: GenericTableView<FolderTableViewCell, Folder> = {
        let sortD = [NSSortDescriptor(key: "title", ascending: true)]
        let dataProvider = DataProvider<Folder>(managedObjectContext: CoreDataManager.shared.managedObjectContext, sortDescriptors: sortD)
        
        let v = GenericTableView<FolderTableViewCell, Folder>(dataProvider: dataProvider) { (cell, folder) in
            cell.model = folder
        } selectionHandler: { [weak self] (folder) in
            guard let strongSelf = self, let folderTitle = folder.title else { return }
            strongSelf.navigationController?.pushViewController(TodoListViewController(folder: folderTitle), animated: true)
        }
        
        return v
    }()
    
    private lazy var addNewButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 32.0, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        v.setImage(image, for: .normal)
        v.tintColor = .white
        v.backgroundColor = .blue
        v.layer.cornerRadius = 10
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        v.addTarget(self, action: #selector(didTapNew(_:)), for: .touchUpInside)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.performFetch()
    }
    
    private func setupView() {
        title = "My List"
        view.addSubview(tableView)
        view.addSubview(addNewButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        // tableview
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // add new button
        NSLayoutConstraint.activate([
            addNewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addNewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNewButton.widthAnchor.constraint(equalToConstant: 44),
            addNewButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapNew(_ sender: UIButton) {
        let vc = AddNewItemViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension FolderListViewController: AddNewItemViewControllerDelegate {
    func saveNewItem(item: String) {
        CoreDataManager.shared.saveFolder(name: item)
        tableView.performFetch()
    }
}
