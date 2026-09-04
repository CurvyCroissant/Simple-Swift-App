//  Components/BaseFormViewController.swift

import UIKit

class BaseFormViewController: UIViewController {
    private(set) var formView: BaseFormView!
    
    var scrollView: UIScrollView { formView.scrollView }
    var stackView: UIStackView { formView.stackView }
    var submitButton: UIButton { formView.submitButton }
    
    func makeFormView() -> BaseFormView {
        BaseFormView()
    }
    
    override func loadView() {
        formView = makeFormView()
        view = formView
    }
}
