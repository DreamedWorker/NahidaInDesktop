//
//  ImageSourceScreen.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/27.
//

import SwiftUI
import AppKit

struct ImageSourceScreen: View {
    @ObservedObject private var model = ImageScreenModel()
    @State var showFileImporter = false
    @State var window = false
    @State var errMsg: String = ""
    let rows = [GridItem(.flexible()), GridItem(.flexible())]
    
    init() {
        model.initDir()
        model.getPictures()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("管理你的图片资源（只有本页面中列出的图片是可以显示在小组件中的。）").font(.headline)
                Spacer()
            }
            ScrollView {
                LazyVGrid(columns: rows, content: {
                    ForEach(model.imgs.indices, id: \.self){single in
                        HStack {
                            Image(nsImage: NSImage(contentsOf: model.imgs[single])!)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 100.0)
                            VStack {
                                Text(model.imgs[single].path().split(separator: "/").last!.removingPercentEncoding!).padding(.bottom)
                                HStack {
                                    Button(action: {
                                        let pasteBoard = NSPasteboard.general
                                        pasteBoard.clearContents()
                                        pasteBoard.setString(model.imgs[single].path().split(separator: "/").last!.removingPercentEncoding!, forType: .string)
                                    }, label: {
                                        Image(systemName: "doc.on.clipboard")
                                    })
                                    Button(action: {
                                        let result = model.remove2trash(objectURL: model.imgs[single])
                                        if !result.eventOK {
                                            window = true
                                            errMsg = result.message!
                                        }
                                    }, label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(Color.red)
                                    })
                                }
                            }
                        }
                    }
                }).padding()
            }
        }
        .navigationTitle(Text("所有图像"))
        .toolbar(content: {
            ToolbarItem(content: {
                Button(action: {
                    showFileImporter = true
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .help("添加新图片")
                })
            })
        })
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.image], allowsMultipleSelection: false, onCompletion: {results in
            switch results {
            case .success(let dics):
                let sele = dics[0].getPathWithoutEscape()
                let result = model.cp2storage(requiredPath: sele)
                if !result.eventOK {
                    window = true
                    errMsg = result.message!
                }
            case .failure(let errs):
                print(errs)
            }
        })
        .alert("发生错误", isPresented: $window, actions: {
            Button(action: {
                errMsg = ""
                window = false
            }, label: {
                Text("OK")
            })
        }, message: {
            Text(errMsg)
        })
    }
}

#Preview {
    ImageSourceScreen()
}
