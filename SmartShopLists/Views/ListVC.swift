//
//  ListVC.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//
import UIKit

class ListVC: UIViewController {
    private let tableView = UITableView()
    private let viewModel = ListVM()
    private var isEditingMode = false
    private var selectedLists: [ShoppingListEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        addTableViewAnimations()
    }

    private func setupUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(hex: "#1E1E2F").cgColor, UIColor(hex: "#2E2E4F").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)

        navigationItem.title = "Alışveriş Listelerim"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "AvenirNext-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
        ]

        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addListTapped))
        addButton.tintColor = UIColor(hex: "#F4A261")

        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(deleteSelectedListsTapped))
        trashButton.tintColor = UIColor(hex: "#F4A261")

        let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil.circle.fill"), style: .plain, target: self, action: #selector(toggleEditingMode))
        editButton.tintColor = UIColor(hex: "#64DFDF")

        navigationItem.rightBarButtonItems = [addButton, trashButton, editButton]

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ListCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.onListsUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.updateTrashButtonState()
        }
    }

    @objc private func addListTapped() {
        let alert = UIAlertController(title: "Yeni Liste Ekle", message: "Liste adını girin", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Liste Adı"
        }
        alert.addAction(UIAlertAction(title: "Ekle", style: .default) { _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            self.viewModel.createList(name: name)
        })
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func toggleEditingMode() {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
        selectedLists.removeAll()
        navigationItem.rightBarButtonItems?.forEach { item in
            if item.image == UIImage(systemName: "trash.fill") {
                item.isEnabled = false
            }
        }
        tableView.reloadData()
    }

    @objc private func deleteSelectedListsTapped() {
        guard !selectedLists.isEmpty else { return }
        let alert = UIAlertController(title: "Listeleri Sil", message: "Seçili listeleri silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive) { _ in
            for list in self.selectedLists {
                self.viewModel.deleteList(list)
            }
            self.selectedLists.removeAll()
            self.toggleEditingMode()
        })
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func updateTrashButtonState() {
        navigationItem.rightBarButtonItems?.forEach { item in
            if item.image == UIImage(systemName: "trash.fill") {
                item.isEnabled = !selectedLists.isEmpty
            }
        }
    }

    private func addTableViewAnimations() {
        tableView.alpha = 0
        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseInOut, animations: {
            self.tableView.alpha = 1
        })
    }
}

extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let list = viewModel.lists[indexPath.row]

        cell.textLabel?.text = list.name
        cell.textLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        let containerView = UIView()
        containerView.backgroundColor = UIColor(hex: "#64DFDF").withAlphaComponent(0.2)
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 6
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let selectionCircle = UIView()
        selectionCircle.backgroundColor = selectedLists.contains(list) ? UIColor(hex: "#F4A261") : UIColor.clear
        selectionCircle.layer.borderColor = UIColor(hex: "#64DFDF").cgColor
        selectionCircle.layer.borderWidth = 2
        selectionCircle.layer.cornerRadius = 10
        selectionCircle.isHidden = !tableView.isEditing
        selectionCircle.translatesAutoresizingMaskIntoConstraints = false

        cell.contentView.addSubview(containerView)
        containerView.addSubview(selectionCircle)
        containerView.addSubview(cell.textLabel!)
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),

            selectionCircle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            selectionCircle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            selectionCircle.widthAnchor.constraint(equalToConstant: 20),
            selectionCircle.heightAnchor.constraint(equalToConstant: 20),

            cell.textLabel!.leadingAnchor.constraint(equalTo: selectionCircle.trailingAnchor, constant: 12),
            cell.textLabel!.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), options: .curveEaseInOut, animations: {
            cell.alpha = 1
        })

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let selectedList = viewModel.lists[indexPath.row]
            if !selectedLists.contains(selectedList) {
                selectedLists.append(selectedList)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            updateTrashButtonState()
        } else {
            let list = viewModel.lists[indexPath.row]
            let detailVC = DetailVC(list: list)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let deselectedList = viewModel.lists[indexPath.row]
            if let index = selectedLists.firstIndex(of: deselectedList) {
                selectedLists.remove(at: index)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            updateTrashButtonState()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
