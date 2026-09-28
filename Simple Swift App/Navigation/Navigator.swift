//  Navigation/Navigator.swift

import UIKit

class Navigator {
    static let shared = Navigator()
    
    private weak var navigationController: UINavigationController?
    
    private init() {}
    
    func start(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        showMerchantForm()
    }
    
    func showMerchantForm() {
        let formVC = MerchantFormViewController()
        navigationController?.pushViewController(formVC, animated: false)
    }
    
    func showMerchantPhoto(for merchant: MerchantModel) {
        let photoVC = MerchantPhotoViewController()
        photoVC.merchant = merchant
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    func showMerchantDetails(for merchant: MerchantModel) {
        let detailsVC = MerchantDetailsViewController()
        detailsVC.merchant = merchant
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func showMerchantResult(for merchant: MerchantModel) {
        let resultVC = MerchantResultViewController()
        resultVC.merchant = merchant
        navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func showEditField(for merchant: MerchantModel, field: EditField) {
        switch field {
        case .ktp, .npwp, .nomorRekening, .namaUsaha:
            showMerchantForm()
        case .foto:
            showMerchantPhoto(for: merchant)
        case .nama, .nomorHp, .nominal, .tanggal:
            showMerchantDetails(for: merchant)
        case .none:
            break
        }
    }
    
    func returnToResult(with merchant: MerchantModel) {
        guard let nav = navigationController,
              let resultVC = nav.viewControllers.last(where: { $0 is MerchantResultViewController }) as? MerchantResultViewController else {
            return
        }
        resultVC.update(with: merchant)
        nav.popToViewController(resultVC, animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
