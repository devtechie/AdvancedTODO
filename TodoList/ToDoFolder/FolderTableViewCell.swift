// FolderTableViewCell.swift

import UIKit

final class FolderTableViewCell: UITableViewCell {
    
    var model: Folder? {
        didSet {
            if let folder = model {
                folderTitle.text = folder.title
            }
        }
    }
    
    private lazy var folderTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        v.textColor = .darkGray
        v.numberOfLines = 0
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(folderTitle)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            folderTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            folderTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            folderTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            folderTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
