//
//  DetailVC.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//
import UIKit

class DetailVC: UIViewController {
    private let tableView = UITableView()
    private let list: ShoppingListEntity
    private var products: [ProductEntity] = []
    private let coreDataService = CoreDataService.shared
    private let refreshControl = UIRefreshControl()
    private var sortOption: SortOption = .alphabetical

    enum SortOption {
        case alphabetical
        case priorityLowToHigh
        case priorityHighToLow
    }

    init(list: ShoppingListEntity) {
        self.list = list
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        refreshProducts()
        addTableViewAnimations()
    }

    private func setupUI() {
        // Gradient Background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(hex: "#1E1E2F").cgColor, UIColor(hex: "#2E2E4F").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)

        // Navigation Bar
        navigationItem.title = list.name
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "AvenirNext-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
        ]

        // Back Button
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
        backButton.tintColor = UIColor(hex: "#F4A261")
        navigationItem.leftBarButtonItem = backButton

        // Add Button
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addProductTapped))
        addButton.tintColor = UIColor(hex: "#F4A261")
        let scanButton = UIBarButtonItem(image: UIImage(systemName: "barcode.viewfinder"), style: .plain, target: self, action: #selector(scanBarcodeTapped))
        scanButton.tintColor = UIColor(hex: "#F4A261")
        navigationItem.rightBarButtonItems = [addButton, scanButton, createSortButton()]

        // Table View
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Refresh Control
        refreshControl.tintColor = UIColor(hex: "#F4A261")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func createSortButton() -> UIBarButtonItem {
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortTapped))
        sortButton.tintColor = UIColor(hex: "#64DFDF")
        return sortButton
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func addProductTapped() {
        let addProductVC = AddProductVC(list: list)
        let navController = UINavigationController(rootViewController: addProductVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }

    @objc private func sortTapped() {
        let alert = UIAlertController(title: "Sıralama Seçenekleri", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Alfabetik", style: .default) { _ in
            self.sortOption = .alphabetical
            self.refreshProducts()
        })
        alert.addAction(UIAlertAction(title: "Öncelik (Düşükten Yükseğe)", style: .default) { _ in
            self.sortOption = .priorityLowToHigh
            self.refreshProducts()
        })
        alert.addAction(UIAlertAction(title: "Öncelik (Yüksekten Düşüğe)", style: .default) { _ in
            self.sortOption = .priorityHighToLow
            self.refreshProducts()
        })
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func refreshData() {
        refreshProducts()
        refreshControl.endRefreshing()
    }

    func refreshProducts() {
        products = (list.products?.allObjects as? [ProductEntity]) ?? []
        switch sortOption {
        case .alphabetical:
            products.sort { $0.name ?? "" < $1.name ?? "" }
        case .priorityLowToHigh:
            products.sort { ($0.priority ?? "Düşük") < ($1.priority ?? "Düşük") }
        case .priorityHighToLow:
            products.sort { ($0.priority ?? "Düşük") > ($1.priority ?? "Düşük") }
        }
        tableView.reloadData()
    }

    // MARK: - Barcode Scanner Integration
    private func openBarcodeScanner() {
        let barcodeVC = BarcodeVC(list: list)
        barcodeVC.onScanComplete = { [weak self] in
            self?.refreshProducts()
        }
        navigationController?.pushViewController(barcodeVC, animated: true)
    }

    @objc private func scanBarcodeTapped() {
        openBarcodeScanner()
    }

    private func addTableViewAnimations() {
        tableView.alpha = 0
        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseInOut, animations: {
            self.tableView.alpha = 1
        })
    }

    private func toggleProductPurchased(_ product: ProductEntity) {
        product.isPurchased.toggle()
        coreDataService.saveContext()
        refreshProducts()
    }
}

extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        cell.configure(product: product)
        cell.onCheckboxTapped = { [weak self] in
            self?.toggleProductPurchased(product)
        }
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), options: .curveEaseInOut, animations: {
            cell.alpha = 1
        })
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = products[indexPath.row]
            coreDataService.deleteProduct(product)
            refreshProducts()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// Custom Product Cell
class ProductCell: UITableViewCell {
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priorityLabel = UILabel()
    private let checkboxButton = UIButton()
    private var isChecked: Bool = false
    var onCheckboxTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        // Container View
        containerView.backgroundColor = UIColor(hex: "#64DFDF").withAlphaComponent(0.2)
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 6
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Name Label
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)

        // Category Label
        categoryLabel.font = UIFont(name: "AvenirNext-Regular", size: 14) ?? .systemFont(ofSize: 14, weight: .regular)
        categoryLabel.textColor = UIColor(hex: "#F4A261")
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(categoryLabel)

        // Priority Label
        priorityLabel.font = UIFont(name: "AvenirNext-Regular", size: 14) ?? .systemFont(ofSize: 14, weight: .regular)
        priorityLabel.textColor = .white
        priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(priorityLabel)

        // Checkbox Button
        checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkboxButton.tintColor = UIColor(hex: "#F4A261")
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(checkboxButton)

        // Constraints
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            checkboxButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            checkboxButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),

            categoryLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),

            priorityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            priorityLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    func configure(product: ProductEntity) {
        nameLabel.text = product.name
        categoryLabel.text = product.category
        priorityLabel.text = product.priority
        isChecked = product.isPurchased
        checkboxButton.isSelected = isChecked
        updateTextAppearance()
    }

    @objc private func checkboxTapped() {
        isChecked.toggle()
        checkboxButton.isSelected = isChecked
        updateTextAppearance()
        onCheckboxTapped?()
    }

    private func updateTextAppearance() {
        if isChecked {
            nameLabel.textColor = .gray
            categoryLabel.textColor = .gray
            priorityLabel.textColor = .gray
        } else {
            nameLabel.textColor = .white
            categoryLabel.textColor = UIColor(hex: "#F4A261")
            priorityLabel.textColor = .white
        }
    }
}
