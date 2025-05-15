//
//  AuthVC.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//
import UIKit
import FirebaseAuth

class AuthVC: UIViewController {
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let welcomeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

        // Title Label
        titleLabel.text = "SmartShopLists"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 40) ?? .systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Welcome Label
        welcomeLabel.text = "Hoş Geldin!\nListelerini Oluşturmaya Başla"
        welcomeLabel.font = UIFont(name: "AvenirNext-Regular", size: 18) ?? .systemFont(ofSize: 18, weight: .regular)
        welcomeLabel.textColor = UIColor(hex: "#64DFDF")
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.numberOfLines = 0 // Çok satırlı yap
               welcomeLabel.lineBreakMode = .byWordWrapping // Kelimeleri bölmeden satır atla
        view.addSubview(welcomeLabel)

        // Email TextField
        emailTextField.placeholder = "E-posta"
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = .white.withAlphaComponent(0.95)
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.shadowColor = UIColor.black.cgColor
        emailTextField.layer.shadowOpacity = 0.3
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 4)
        emailTextField.layer.shadowRadius = 6
        emailTextField.textColor = .black
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        emailTextField.leftViewMode = .always
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)

        // Password TextField
        passwordTextField.placeholder = "Şifre"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = .white.withAlphaComponent(0.95)
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.layer.shadowColor = UIColor.black.cgColor
        passwordTextField.layer.shadowOpacity = 0.3
        passwordTextField.layer.shadowOffset = CGSize(width: 0, height: 4)
        passwordTextField.layer.shadowRadius = 6
        passwordTextField.textColor = .black
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        passwordTextField.leftViewMode = .always
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)

        // Login Button
        loginButton.setTitle("Giriş Yap", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        loginButton.backgroundColor = UIColor(hex: "#5E60CE")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOpacity = 0.3
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        loginButton.layer.shadowRadius = 6
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)

        // Register Button
        registerButton.setTitle("Kayıt Ol", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        registerButton.backgroundColor = UIColor(hex: "#F4A261")
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOpacity = 0.3
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        registerButton.layer.shadowRadius = 6
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 300),

            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 200),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func addAnimations() {
        titleLabel.alpha = 0
        welcomeLabel.alpha = 0
        emailTextField.alpha = 0
        passwordTextField.alpha = 0
        loginButton.alpha = 0
        registerButton.alpha = 0

        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 1
            self.welcomeLabel.alpha = 1
        })

        UIView.animate(withDuration: 1.0, delay: 0.4, options: .curveEaseInOut, animations: {
            self.emailTextField.alpha = 1
            self.passwordTextField.alpha = 1
        })

        UIView.animate(withDuration: 1.0, delay: 0.6, options: .curveEaseInOut, animations: {
            self.loginButton.alpha = 1
            self.registerButton.alpha = 1
        })

        loginButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
        registerButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
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

    @objc private func loginTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showErrorAlert(message: "Giriş hatası: \(error.localizedDescription)")
                return
            }
            self.navigateToListScreen()
        }
    }

    @objc private func registerTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showErrorAlert(message: "Kayıt hatası: \(error.localizedDescription)")
                return
            }
            self.navigateToListScreen()
        }
    }

    private func navigateToListScreen() {
        let listVC = ListVC()
        let navController = UINavigationController(rootViewController: listVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        present(navController, animated: true, completion: nil)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
