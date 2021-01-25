// TodoTableViewCell.swift

import UIKit

final class TodoTableViewCell: UITableViewCell {
    
    var model: Todo? {
        didSet {
            if let item = model {
                todoTitle.text = item.title
            }
        }
    }
    
    private lazy var todoTitle: UILabel = {
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
        fatalError("Not implemented")
    }
    
    private func setupView() {
        contentView.addSubview(todoTitle)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            todoTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            todoTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            todoTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            todoTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
