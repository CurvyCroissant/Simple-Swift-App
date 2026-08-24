//
//  UIKitMerchantFormResultViewController.swift
//  Simple Swift App
//
//  Created by ITBCA on 21/08/26.
//

import UIKit

class UIKitMerchantFormResultViewController: UIViewController {
    private let ktp: String
    private let npwp: String
    private let kodePos: String
    private let namaUsaha: String
    
    init(ktp: String, npwp: String, kodePos: String, namaUsaha: String) {
        self.ktp = ktp
        self.npwp = npwp
        self.kodePos = kodePos
        self.namaUsaha = namaUsaha
        
        super.init(nibName: nil, bundle: nil) // required by UI Kit
    }
    
    private var resultView: UIKitMerchantFormResultView {
        return view as! UIKitMerchantFormResultView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var formView: UIKitMerchantFormView {
        return view as! UIKitMerchantFormView
    }
    
    override func loadView() {
        view = UIKitMerchantFormResultView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultView.configure(ktp: ktp, npwp: npwp, kodePos: kodePos, namaUsaha: namaUsaha)
    }
}   
