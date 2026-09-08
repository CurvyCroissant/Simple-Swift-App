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
}
