//
//  CustomToastView.swift
//  Autolayout_With_Code
//
//  Created by master on 2020/04/16.
//  Copyright © 2020 ksb. All rights reserved.
//
import UIKit

@objcMembers class KeepToastVM {
    /// toast 메세지
    var message: String = ""
    /// toast 지속시간
    var duration: Double = 0
    /// 보여질 뷰
    var parentView : UIView? = nil
    /// 토스트 뷰 색깔
    var color : UIColor = .systemBlue
    /// 토스트 메세지 색깔
    var textColor : UIColor = .white
}

@objcMembers class CustomToastView : UIView {
    
    //MARK:- 내부변수
    // 뷰모델
    var toastVM : KeepToastVM? = nil
    // 버튼 어레이
    var buttonArray:[DzAlertAction] = [DzAlertAction]()
    // 상하좌우 간격(패딩)
    var padding:CGFloat = 10.0
    // toast 높이
    let toastHeight : CGFloat = 40
    
    //MARK:- View(IBOutlet)
    // 껍데기 뷰 (stackView)
    var wrapperStackView : UIStackView = UIStackView()
    // toast message 표시 될 라벨
    var toastLabel : UILabel = UILabel()
    // 버튼이 있는 경우에 막대기, 버튼을 번갈아가면서 넣어준다.
    var buttonStackView : UIStackView = UIStackView()
    
    
    /// keep 등록완료 custom 토스트 만들기
    /// - Parameters:
    ///   - message: 토스트 메세지
    ///   - duration: 토스트 지속시간
    ///   - parentView: 토스트가 보여지는 뷰(uiview)
    ///   - color: 백그라운드 색깔(기본 : systemBlue)
    ///   - textColor: 토스트 메세지 텍스트 색깔(기본 : white)
    public func makeToast(message: String, duration: Double, parentView: UIView, color: UIColor? = .systemBlue, textColor: UIColor? = .white){
        // 기초 정보 담기.
        if self.toastVM == nil {
            self.toastVM = KeepToastVM.init()
        }
        
        self.toastVM!.message = message
        self.toastVM!.duration = duration
        self.toastVM!.parentView = parentView
        self.toastVM!.color = color!
        self.toastVM!.textColor = textColor!
        
        self.initView()
        self.showToast()
    }
    
    private func initView() {
        
        // 부모뷰에 현재 뷰 add
        self.toastVM!.parentView?.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.leftAnchor.constraint(equalTo: self.toastVM!.parentView!.leftAnchor, constant: 100).isActive = true
        self.centerXAnchor.constraint(equalTo: self.toastVM!.parentView!.centerXAnchor, constant: 0).isActive = true
        
        self.bottomAnchor.constraint(equalTo: self.toastVM!.parentView!.bottomAnchor, constant: -toastHeight).isActive = true
        
        self.backgroundColor = toastVM!.color
        self.layer.cornerRadius = toastHeight / 2
        
        // 1. 라벨과 스택뷰를 담고 있는 껍데기 스택뷰
        self.setWrapperStackView()
        
        // 2. 토스트 메세지가 보여질 라벨
        self.setMessageLabel()
        
        // 3. 버튼 스택뷰(스틱이랑 버튼이 번갈아가면서 들어갈 것임)
        // button이 있을때만 해준다.
        // 버튼이 있는지 없는지 체크
        if true == buttonArray.isEmpty {
            return
        } else {
            self.setButtonStackView()
        }
    }
    
    /// 토스트뷰 보여주기
    private func showToast() {
        
        UIView.animate(withDuration: toastVM!.duration, delay: toastVM!.duration, options: .allowUserInteraction, animations: {
            // alpha를 0.0으로 하면 버튼 액션이 안된다.
            self.alpha = 0.02
        }) { (view) in
            self.alpha = 0.0
        }
    }
    
}

extension CustomToastView {
    
    // 껍데기 뷰 셋팅
    private func setWrapperStackView(){
        self.addSubview(wrapperStackView)
        
        wrapperStackView.translatesAutoresizingMaskIntoConstraints = false
        wrapperStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: toastHeight / 2).isActive = true
        wrapperStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -toastHeight / 2).isActive = true
        wrapperStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        wrapperStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        wrapperStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        wrapperStackView.axis = .horizontal
        wrapperStackView.distribution = .equalSpacing
        wrapperStackView.alignment = .center
        wrapperStackView.spacing = padding
        
    }
    
    // 토스트 메세지 보여질 라벨 셋팅
    private func setMessageLabel() {
        wrapperStackView.addArrangedSubview(toastLabel)
        
        toastLabel.textAlignment = .center
        toastLabel.text = toastVM!.message
        toastLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        toastLabel.textColor = toastVM!.textColor

        // 메세지 길이에 따라서 사이즈가 달라지므로 체크해주기
        let maximumLabelSize : CGSize = CGSize(width: 200, height: 50)
        let expectedLabelSize : CGSize = toastLabel.sizeThatFits(maximumLabelSize)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.widthAnchor.constraint(equalToConstant: expectedLabelSize.width).isActive = true
    }
    
    // 스틱이랑 버튼이 들어간 스택뷰 셋팅
    private func setButtonStackView() {
        wrapperStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.distribution = .equalSpacing
        buttonStackView.spacing = padding
        
        self.addButtonToStackView()
    }
    
    // 스틱뷰 셋팅
    private func setStickView() -> UIView {
        let stickView = UIView()
        stickView.translatesAutoresizingMaskIntoConstraints = false
        stickView.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        stickView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stickView.backgroundColor = toastVM!.textColor
        stickView.sizeToFit()
        return stickView
    }
    
    // buttonStackView 안에 들어가는 버튼
    private func makeActionButton() -> UIButton {
        let button = UIButton()

        button.backgroundColor = .clear
        button.setTitleColor(toastVM!.textColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 15.0)
        button.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return button
    }
}

@objcMembers class DzAlertAction:NSObject {
    var title:String = ""
    var handler:doAlertActionhandler?
    
    /// DzAction 만드는 함수
    /// - Parameters:
    ///   - title:
    ///   - handler:
    public class func action(title:String, handler:@escaping doAlertActionhandler) -> DzAlertAction {
        let action = DzAlertAction()
        action.title = title
        action.handler = handler
        return action
    }
}

extension CustomToastView {
    
    /// 버튼 buttonStackView에 넣어주기
    private func addButtonToStackView() {
        
        // 실제 버튼 붙이는 부분
        for btn in buttonArray {
            let tempBtn = self.makeActionButton()
            tempBtn.setTitle(btn.title, for: .normal)
            tempBtn.tag = (buttonArray.firstIndex(of: btn))!
            
            // 스틱
            let stickView = self.setStickView()
            
            buttonStackView.addArrangedSubview(stickView)
            buttonStackView.addArrangedSubview(tempBtn)
            
        }
        
    }
    
    /// 버튼 액션 붙이는 함수
    /// - Parameter action:
    public func addButtonAction(action: DzAlertAction) {
        buttonArray.append(action)
    }
    
    @objc func btnAction(_ sender: UIButton) {
        let btn:UIButton = sender
        
        let buttonData = buttonArray[btn.tag]
        
        if (buttonData.handler != nil) {
            // 2020. 01. 29 subin 화면전환이 handler에서 이루어지는 경우 main에서 처리하기 위해 추가함.
            DispatchQueue.main.async {
                buttonData.handler!()
            }
        }
    }
}
