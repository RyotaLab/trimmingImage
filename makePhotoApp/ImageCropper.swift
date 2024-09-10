//
//  ImageCropper.swift
//  makePhotoApp
//
//  Created by 渡邊涼太 on 2024/07/02.
//

//https://github.com/TimOliver/TOCropViewController/issues/421

import Foundation
import SwiftUI
import UIKit
import CropViewController

struct ImageCropper: UIViewControllerRepresentable{
    
    @Binding var image: UIImage?
    @Binding var visible: Bool
    
    var done: (UIImage) -> Void
    
    class Coordinator: NSObject, CropViewControllerDelegate{
        let parent : ImageCropper
        
        
        
        init(_ parent: ImageCropper){
            self.parent = parent
        }
        
        
        //編集完了時(done）
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            
            print("didcroped")
            parent.done(image)
            self.parent.visible = false
        }
        
        //cancel時
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation{
                    self.parent.visible = false
                }
            }
        }
    }//class
    
    func makeCoordinator() -> Coordinator {
         return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let img = self.image ?? UIImage()
        let cropViewController = CropViewController(image:img)
        cropViewController.delegate = context.coordinator
        cropViewController.aspectRatioPreset = .presetSquare
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.aspectRatioLockEnabled = true
        return cropViewController
    }
    
}
