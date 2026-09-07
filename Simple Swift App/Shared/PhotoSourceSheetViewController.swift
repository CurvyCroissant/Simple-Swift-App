//  Shared/PhotoSourceSheetViewController.swift=

import UIKit

class PhotoSourceSheetViewController: UIViewController {
    private let sheetView = PhotoSourceSheetView()
    
    var onCameraSelected: (() -> Void)?
    var onGallerySelected: (() -> Void)?
    
    override func loadView() {
        view = sheetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        sheetView.cameraButton.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)
        sheetView.galleryButton.addTarget(self, action: #selector(galleryTapped), for: .touchUpInside)
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in 250}), .medium()]
            sheet.prefersGrabberVisible = true
        }
    }
    
    @objc private func cameraTapped() {
        dismiss(animated: true) { [weak self] in self?.onCameraSelected?()}
    }
    
    @objc private func galleryTapped() {
        dismiss(animated: true) { [weak self] in self?.onGallerySelected?()}
    }
}
