//
//  AddProductVC.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//
import UIKit

class AddProductVC: UIViewController {
    private let nameTextField = UITextField()
    private let categoryPicker = UIPickerView()
    private let priorityPicker = UIPickerView()
    private let quantityPicker = UIPickerView()
    private let addButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let coreDataService = CoreDataService.shared
    private let list: ShoppingListEntity

    private let categories = ["Gıda", "İçecek", "Temizlik", "Kişisel Bakım", "Elektronik", "Giyim","Diğer","Bebek ve Çocuk","Evcil Hayvan"]
    private let priorities = ["Yüksek", "Orta", "Düşük"]
    private let quantities = Array(1...50)
    private var selectedCategory = "Gıda" // Default kategori
    private var selectedPriority = "Orta" // Default öncelik
    private var selectedQuantity = 1      // Default miktar

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
        setupPickers()
        addAnimations()
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
        navigationItem.title = "Yeni Ürün Ekle"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "AvenirNext-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))

        // Title Label
        titleLabel.text = "Ürün Bilgilerini Girin"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 24) ?? .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Name TextField
        nameTextField.placeholder = "Ürün Adı"
        nameTextField.borderStyle = .none
        nameTextField.backgroundColor = .white.withAlphaComponent(0.95)
        nameTextField.layer.cornerRadius = 12
        nameTextField.layer.shadowColor = UIColor.black.cgColor
        nameTextField.layer.shadowOpacity = 0.3
        nameTextField.layer.shadowOffset = CGSize(width: 0, height: 4)
        nameTextField.layer.shadowRadius = 6
        nameTextField.textColor = .black
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        nameTextField.leftViewMode = .always
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)

        // Category Picker
        categoryPicker.backgroundColor = .white.withAlphaComponent(0.95)
        categoryPicker.layer.cornerRadius = 12
        categoryPicker.layer.shadowColor = UIColor.black.cgColor
        categoryPicker.layer.shadowOpacity = 0.3
        categoryPicker.layer.shadowOffset = CGSize(width: 0, height: 4)
        categoryPicker.layer.shadowRadius = 6
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryPicker)

        // Priority Picker
        priorityPicker.backgroundColor = .white.withAlphaComponent(0.95)
        priorityPicker.layer.cornerRadius = 12
        priorityPicker.layer.shadowColor = UIColor.black.cgColor
        priorityPicker.layer.shadowOpacity = 0.3
        priorityPicker.layer.shadowOffset = CGSize(width: 0, height: 4)
        priorityPicker.layer.shadowRadius = 6
        priorityPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priorityPicker)

        // Quantity Picker
        quantityPicker.backgroundColor = .white.withAlphaComponent(0.95)
        quantityPicker.layer.cornerRadius = 12
        quantityPicker.layer.shadowColor = UIColor.black.cgColor
        quantityPicker.layer.shadowOpacity = 0.3
        quantityPicker.layer.shadowOffset = CGSize(width: 0, height: 4)
        quantityPicker.layer.shadowRadius = 6
        quantityPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(quantityPicker)

        // Add Button
        addButton.setTitle("Ekle", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        addButton.backgroundColor = UIColor(hex: "#5E60CE")
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 12
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addButton.layer.shadowRadius = 6
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextField.widthAnchor.constraint(equalToConstant: 300),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            categoryPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryPicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            categoryPicker.widthAnchor.constraint(equalToConstant: 200),
            categoryPicker.heightAnchor.constraint(equalToConstant: 80),

            priorityPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priorityPicker.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 20),
            priorityPicker.widthAnchor.constraint(equalToConstant: 200),
            priorityPicker.heightAnchor.constraint(equalToConstant: 80),

            quantityPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quantityPicker.topAnchor.constraint(equalTo: priorityPicker.bottomAnchor, constant: 20),
            quantityPicker.widthAnchor.constraint(equalToConstant: 100),
            quantityPicker.heightAnchor.constraint(equalToConstant: 80),

            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: quantityPicker.bottomAnchor, constant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupPickers() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.selectRow(0, inComponent: 0, animated: false) // Default: "Gıda"

        priorityPicker.dataSource = self
        priorityPicker.delegate = self
        priorityPicker.selectRow(1, inComponent: 0, animated: false) // Default: "Orta"

        quantityPicker.dataSource = self
        quantityPicker.delegate = self
        quantityPicker.selectRow(0, inComponent: 0, animated: false) // Default: 1
    }

    private func addAnimations() {
        titleLabel.alpha = 0
        nameTextField.alpha = 0
        categoryPicker.alpha = 0
        priorityPicker.alpha = 0
        quantityPicker.alpha = 0
        addButton.alpha = 0

        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 1
            self.nameTextField.alpha = 1
            self.categoryPicker.alpha = 1
        })

        UIView.animate(withDuration: 1.0, delay: 0.4, options: .curveEaseInOut, animations: {
            self.priorityPicker.alpha = 1
            self.quantityPicker.alpha = 1
        })

        UIView.animate(withDuration: 1.0, delay: 0.6, options: .curveEaseInOut, animations: {
            self.addButton.alpha = 1
        })

        addButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        }
    }

    @objc private func addTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showErrorAlert(message: "Lütfen ürün adı girin.")
            return
        }
        coreDataService.addProduct(to: list, name: "\(name) (\(selectedQuantity) adet)", category: selectedCategory, priority: selectedPriority)
        if let detailVC = presentingViewController as? DetailVC {
            detailVC.refreshProducts()
        }
        dismiss(animated: true, completion: nil)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

extension AddProductVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categories.count
        } else if pickerView == priorityPicker {
            return priorities.count
        } else {
            return quantities.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categories[row]
        } else if pickerView == priorityPicker {
            return priorities[row]
        } else {
            return "\(quantities[row])"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            selectedCategory = categories[row]
        } else if pickerView == priorityPicker {
            selectedPriority = priorities[row]
        } else {
            selectedQuantity = quantities[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title: String
        if pickerView == categoryPicker {
            title = categories[row]
        } else if pickerView == priorityPicker {
            title = priorities[row]
        } else {
            title = "\(quantities[row])"
        }
        return NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "AvenirNext-Regular", size: 16) ?? .systemFont(ofSize: 16, weight: .regular)
            ]
        )
    }
}
