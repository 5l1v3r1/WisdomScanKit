//
//  WisdomScanKit+Extension.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/11/24.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     *     ScannPhotos拍摄图片，支持拍摄多张:
     *     WisdomScanningType:   ScannPhotos跳转动画类型
     *     WisdomPhotosType  :   ScannPhotos数量类型
     *     WisdomPhotosTask  :   ScannPhotos完成回调
     *     WisdomErrorTask   :   ScannPhotos失败错误回调
     */
    @objc public func startScanPhotos(startType: WisdomScanStartType,
                                      countType: WisdomPhotoCountType,
                                      photosTask: @escaping WisdomPhotoTask,
                                      errorTask: @escaping WisdomErrorTask) {
        
        let photosVC = WisdomPhotosVC(startTypes: startType,
                                      countTypes: countType,
                                      photoTasks: photosTask,
                                      errorTasks: errorTask)
        switch startType {
        case .push:
            if isKind(of: UINavigationController.self){
                (self as! UINavigationController).pushViewController(photosVC, animated: true)
            }else if navigationController != nil {
                navigationController!.pushViewController(photosVC, animated: true)
            }else{
                push(rootVC: photosVC)
            }
        case .present:
            present(photosVC, animated: true, completion: nil)
        }
    }
    
    /**
     *     扫二维码(ScanRQCode):
     *     WisdomScanningType      :   ScanRQCode跳转动画类型
     *     WisdomRQCodeThemeType   :   ScanRQCode主题风格
     *     WisdomScanNavbarDelegate:   ScanRQCode导航栏代理，不需要显示导航栏传nil
     *     WisdomRQCodeFinishTask  :   ScanRQCode 完成回调
     *     WisdomRQCodeErrorTask   :   ScanRQCode 失败回调
     */
    @objc public func startScanRQCode(startType: WisdomScanStartType,
                                      themeType: WisdomRQCodeThemeType,
                                      navDelegate: WisdomScanNavbarDelegate?,
                                      answerTask: @escaping WisdomRQCodeFinishTask,
                                      errorTask: @escaping WisdomRQCodeErrorTask) {
        
        let rqCodeVC = WisdomRQCodeVC(startTypes: startType,
                                      themeTypes: themeType,
                                      navDelegate: navDelegate,
                                      answerTasks: answerTask,
                                      errorTasks: errorTask)
        switch startType {
        case .push:
            if isKind(of: UINavigationController.self){
                (self as! UINavigationController).pushViewController(rqCodeVC, animated: true)
            }else if navigationController != nil {
                navigationController!.pushViewController(rqCodeVC, animated: true)
            }else{
                push(rqCodeVC: rqCodeVC, navDelegate: navDelegate)
            }
        case .present:
            var rootVC: UIViewController = rqCodeVC
            if navDelegate != nil {
                let nav = UINavigationController(rootViewController: rqCodeVC)
                rqCodeVC.isCreatNav = true
                rootVC = nav
            }
            present(rootVC, animated: true, completion: nil)
        }
    }
    
    /**
     *     获取系统相册图片 :
     *     WisdomScanStartType     :  系统相册跳转动画类型
     *     WisdomSetectPhotoType   :  系统相册图片展示样式
     *     WisdomPhotoCountType    :  选择数量
     *     WisdomScanNavbarDelegate:  ScanRQCode导航栏代理，不需要显示导航栏传nil
     *     WisdomPhotoTask         :  完成回调
     *     WisdomErrorTask         :  失败回调
     */
    @objc public func startSelectSystemPhoto(startType: WisdomScanStartType,
                                             showElectType: WisdomShowElectPhotoType,
                                             countType: WisdomPhotoCountType,
                                             navDelegate: WisdomScanNavbarDelegate?,
                                             photoTasks: @escaping WisdomPhotoTask,
                                             errorTasks: @escaping WisdomErrorTask) {
        
        let selectVC = WisdomPhotoSelectVC(startTypes: startType,
                                           showElectTypes: showElectType,
                                           countTypes: countType,
                                           navDelegate: navDelegate,
                                           photoTasks: photoTasks,
                                           errorTasks: errorTasks)
        switch startType {
        case .push:
            if isKind(of: UINavigationController.self){
                (self as! UINavigationController).pushViewController(selectVC, animated: true)
            }else if navigationController != nil {
                navigationController!.pushViewController(selectVC, animated: true)
            }else{
                //push(rqCodeVC: selectVC, navDelegate: navDelegate)
            }
        case .present:
            var rootVC: UIViewController = selectVC
            if navDelegate != nil {
                let nav = UINavigationController(rootViewController: selectVC)
                selectVC.isCreatNav = true
                rootVC = nav
            }
            present(rootVC, animated: true, completion: nil)
        }
    }
    
    /** 系统界面提示 */
    @objc public func showAlert(title: String,
                                message: String,
                                cancelActionTitle: String?,
                                rightActionTitle: String?,
                                handler: @escaping ((UIAlertAction) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancelActionTitle != nil {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        
        if rightActionTitle != nil {
            let rightAction = UIAlertAction(title: rightActionTitle, style: UIAlertAction.Style.default, handler: { action in
                handler(action)
            })
            alert.addAction(rightAction)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    
    fileprivate func push(rqCodeVC: WisdomRQCodeVC, navDelegate: WisdomScanNavbarDelegate?) {
        var rootVC: UIViewController = rqCodeVC
        if navDelegate != nil {
            let nav = UINavigationController(rootViewController: rqCodeVC)
            rqCodeVC.isCreatNav = true
            rootVC = nav
        }
        push(rootVC: rootVC)
    }
    
    fileprivate func push(rootVC: UIViewController) {
        addChild(rootVC)
        view.addSubview(rootVC.view)
        rootVC.view.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        
        UIView.animate(withDuration: 0.35) {
            rootVC.view.transform = .identity
        }
    }
}