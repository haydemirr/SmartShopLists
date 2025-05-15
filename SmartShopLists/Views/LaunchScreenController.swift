//
//  LaunchScreenController.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//

import UIKit

class LaunchScreenController: UIViewController {
    private let titleLabel = UILabel()
    private let iconView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateAndTransition()
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
        titleLabel.textColor = UIColor(hex: "#FFFFFF")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Icon View (Daire)
        iconView.backgroundColor = UIColor(hex: "#F4A261")
        iconView.layer.cornerRadius = 30
        iconView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconView)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),

            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func animateAndTransition() {
        // Fade-in Animation
        titleLabel.alpha = 0
        iconView.alpha = 0
        iconView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 1
            self.iconView.alpha = 1
            self.iconView.transform = .identity
        }) { _ in
            // 2 saniye sonra AuthVC'ye geçiş
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.transitionToAuthVC()
            }
        }
    }

    private func transitionToAuthVC() {
        let authVC = AuthVC()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = authVC
            window.makeKeyAndVisible()

            // Fade transition
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

// Extension for UIColor hex support (zaten AuthVC'de var, ama buraya da ekleyelim ki bağımsız çalışsın)

