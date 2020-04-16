//
//  SubUIView.swift
//  Autolayout_With_Code
//
//  Created by master on 2020/04/15.
//  Copyright © 2020 ksb. All rights reserved.
//
import UIKit

class ToastVM {
    var toastMessage : String = ""
    var toastDuration : Double = 0.0
    var parentView : UIView? = nil
}

class SubUIView : UIView {
    
    //MARK:- IBOutlet
    var wrapperStackView = UIStackView()
    var messageLabel = UILabel()
    
    //MARK:- ViewModel
    var toastVM : ToastVM? = nil
    
    
    // 입력 파라미터로 데이터 셋팅 및 토스트 만들기
    public func makeToast(message: String, duration: Double, parentView: UIView) {
        if self.toastVM == nil {
            self.toastVM = ToastVM.init()
        }
        
        // 보여질 메세지
        toastVM!.toastMessage = message
        // 보여질 시간
        toastVM!.toastDuration = duration
        // 보여질 곳
        toastVM!.parentView = parentView
        
        self.setAutoLayout()
        self.showToast()
    }
    
    // 뷰 오토레이아웃 셋팅
    private func setAutoLayout() {
        // 1. 껍데기 뷰
        self.wrapperStackView = self.setWrapperStackView()
        self.addSubview(wrapperStackView)
        wrapperStackView.translatesAutoresizingMaskIntoConstraints = false
        wrapperStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        wrapperStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        wrapperStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        wrapperStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        // 2. 라벨
        self.messageLabel = self.setMessageLabel()
        self.wrapperStackView.addArrangedSubview(self.messageLabel)
    }
    
    private func showToast() {
        // 보여질 곳에 subview로 붙여주고 보여준다.
        
        toastVM!.parentView?.addSubview(self)
        
        UIView.animate(withDuration: toastVM!.toastDuration, delay: toastVM!.toastDuration, options: .allowUserInteraction, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}

extension SubUIView {
    
    // 껍데기 스택뷰 만들기
    private func setWrapperStackView() -> UIStackView{
        let row = UIStackView()
        row.axis = .horizontal  //스텍 방향
        row.alignment = .center  //정렬
        
        row.distribution = .equalSpacing  //공간분배
        row.spacing = 5
        
        return row
    }
    
    private func setMessageLabel() -> UILabel{
        let label = UILabel()
        // 2-1. 메세지 길이에 따라서 사이즈가 달라지므로 체크해주기
        let maximumLabelSize : CGSize = CGSize(width: 200, height: 50)
        let expectedLabelSize : CGSize = label.sizeThatFits(maximumLabelSize)
        label.frame.size = expectedLabelSize
        label.textAlignment = .center
        label.text = toastVM!.toastMessage
        label.textColor = .white
        
        return label
    }
}
