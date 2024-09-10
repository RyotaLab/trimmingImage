//
//  ContentView.swift
//  makePhotoApp
//
//  Created by 渡邊涼太 on 2024/07/02.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    //photoPickerで選択されたitem
    @State var selectedPhotos: [PhotosPickerItem] = []
    //UIImageに変換したアイテムを格納する
    @State var getUImage: UIImage?
    @State var CreppedUImage: UIImage?
    
    @State private var showImageCropper = false
    
    @State var showCameraSheet: Bool = false
    
    
    var body: some View {
        VStack {
            //編集後の表示
            if (CreppedUImage != nil) {
                Image(uiImage: CreppedUImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:300, height: 300)
            }
            
            //画像選択
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, matching: .images){
                Text("getPhoto")
            }
            //カメラ表示
            Button{
                showCameraSheet = true
            }label:{
                Text("getCamera")
            }
            
            
        }
        .padding()
        
        //アルバムから取得した画像はuiImage型に変更する
        .onChange(of: selectedPhotos){
            Task{
                guard let data = try? await selectedPhotos[0].loadTransferable(type: Data.self) else {return}
                
                guard let uiImage = UIImage(data:data) else {return}
                
                getUImage = uiImage
                
            }
        }
        //得た画像を編集する時に表示
        .sheet(isPresented: $showImageCropper) {
            ImageCropper(image: self.$getUImage, visible: self.$showImageCropper, done: imageCropped)
        }
        //写真を撮る時に表示
        .fullScreenCover(isPresented:$showCameraSheet){
            CameraView(image: $getUImage).ignoresSafeArea()
        }
        //UIImageが変化したとき
        .onChange(of:getUImage){
            showImageCropper = true
        }
    }
    
    //編集が終わった後に呼ばれる
    func imageCropped(image: UIImage){
        CreppedUImage = image
    }
}

//#Preview {
//    ContentView()
//}
