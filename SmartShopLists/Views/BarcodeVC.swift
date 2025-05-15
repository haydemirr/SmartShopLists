//
//  BarcodeVC.swift
//  SmartShopLists
//
//  Created by Hüseyin Aydemir on 15.05.2025.
//

import UIKit
import Vision
import AVFoundation

class BarcodeVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let coreDataService = CoreDataService.shared
    private var currentList: ShoppingListEntity?
    private let scanFrameView = UIView()
    private let instructionLabel = UILabel()
    var onScanComplete: (() -> Void)?

    init(list: ShoppingListEntity) {
        self.currentList = list
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
    }

    private func setupUI() {
        view.backgroundColor = .black

        // Instruction Label
        instructionLabel.text = "Barkodu taramak için kamerayı ürünün üzerine tutun"
        instructionLabel.font = UIFont(name: "AvenirNext-Regular", size: 16) ?? .systemFont(ofSize: 16, weight: .regular)
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)

        // Scan Frame
        scanFrameView.layer.borderColor = UIColor(hex: "#64DFDF").cgColor
        scanFrameView.layer.borderWidth = 2
        scanFrameView.layer.cornerRadius = 12
        scanFrameView.backgroundColor = .clear
        scanFrameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanFrameView)

        // Constraints
        NSLayoutConstraint.activate([
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            instructionLabel.widthAnchor.constraint(equalToConstant: 300),

            scanFrameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanFrameView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scanFrameView.widthAnchor.constraint(equalToConstant: 250),
            scanFrameView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = previewLayer {
            view.layer.insertSublayer(previewLayer, at: 0)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let request = VNDetectBarcodesRequest { [weak self] request, error in
            guard let results = request.results as? [VNBarcodeObservation], let self = self else { return }
            for barcode in results {
                if let payload = barcode.payloadStringValue {
                    DispatchQueue.main.async {
                        self.handleBarcode(payload)
                    }
                }
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }

    private func handleBarcode(_ barcode: String) {
        captureSession?.stopRunning()
        fetchProductName(from: barcode) { [weak self] productName in
            DispatchQueue.main.async {
                guard let self = self, let list = self.currentList else { return }
                let name = productName ?? "Barkod Ürün: \(barcode)"
                self.coreDataService.addProduct(to: list, name: name, category: "Bilinmeyen", priority: "Orta")
                self.onScanComplete?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func fetchProductName(from barcode: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let product = json["product"] as? [String: Any],
                   let productName = product["product_name"] as? String,
                   !productName.isEmpty {
                    completion(productName)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
