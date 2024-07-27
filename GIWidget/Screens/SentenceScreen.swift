//
//  SentenceScreen.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/24.
//

import SwiftUI

struct SentenceScreen: View {
    @ObservedObject private var model = SentenceScreenModel()
    @State private var showAddSheet = false
    @State private var selectedGroup = "please-choose"
    @State private var sentenceContext = ""
    @State private var showErrDialog = false
    @State var filterName = ""
    
    init() {
        model.loadSentences()
    }
    
    var body: some View {
        if model.loadSuccess {
            VStack {
                HStack {
                    Text("sentence.title")
                        .padding(.leading)
                    Spacer()
                }.padding(.bottom)
                HStack {
                    TextField(text: $filterName, label: {Text("输入分组名进行筛选。")})
                    Spacer()
                    Button(action: {
                        model.showWantedList(requiredKey: filterName)
                    }, label: {Image(systemName: "magnifyingglass")})
                    Button(action: {
                        filterName = ""
                        model.loadSentences()
                    }, label: {Image(systemName: "xmark")})
                }
                .padding(.horizontal, 16.0)
                Form {
                    ForEach(model.sentences.indices, id: \.self){single in
                        HStack {
                            Image(systemName: "list.triangle")
                                .padding(.trailing)
                                .frame(width: 36.0, height: 36.0)
                                .scaledToFit()
                            VStack {
                                HStack {
                                    Text(model.sentences[single]["value"] as! String).font(.title3).fontWeight(.bold)
                                    Spacer()
                                }
                                HStack {
                                    Text("所属分组：\(model.sentences[single]["group"] as! String)")
                                        .font(.callout)
                                    Spacer()
                                }
                            }
                            Spacer()
                            Button(action: {
                                let clipboard = NSPasteboard.general
                                clipboard.clearContents()
                                clipboard.setString(model.sentences[single]["value"] as! String, forType: .string)
                            }, label: {
                                Image(systemName: "doc.on.clipboard")
                                    .help("复制到剪贴板")
                            })
                            Button(action: {
                                model.removeTile(index: single)
                            }, label: {
                                Image(systemName: "trash.circle")
                                    .help("group.remove")
                            })
                        }
                    }
                }.formStyle(.grouped)
            }
            .navigationTitle(Text("home.menu.sentences"))
            .toolbar(content: {
                ToolbarItem {
                    Button(action: { showAddSheet = true }, label: {
                        Image(systemName: "plus")
                            .help("sentence.add")
                    })
                }
                ToolbarItem {
                    Button(action: {
                        showErrDialog = !model.saveSentences()
                    }, label: {
                        Image(systemName: "square.and.arrow.down")
                            .help("group.save")
                    })
                }
            })
            .alert(
                "保存更改时出错！",
                isPresented: $showErrDialog,
                actions: {
                    Button(action: {
                        showErrDialog = false
                    }, label: {
                        Text("app.event.ok")
                    })
                })
            .sheet(isPresented: $showAddSheet, content: {
                VStack {
                    Text("sentence.add").font(.headline).padding(.bottom)
                    TextField("sentence.context.tip", text: $sentenceContext)
                        .padding(.bottom)
                    Picker(
                        "分组",
                        selection: $selectedGroup,
                        content: {
                            Text("请选择一项").tag("please-choose")
                            let data = model.getGroups()
                            ForEach(data.indices, id: \.self){single in
                                Text(data[single]).tag(data[single])
                            }
                        }
                    )
                    Spacer()
                    HStack {
                        Button("app.event.cancel", action: {
                            cleanAddWindowAndClose()
                        }).padding(.trailing)
                        Button("app.event.confirm", action: {
                            //model.addGroupItem(name: newGroup)
                            if selectedGroup != "please-choose" {
                                model.addSingleSentence(context: sentenceContext, group: selectedGroup)
                                cleanAddWindowAndClose()
                            }
                        })
                    }
                }
                .frame(minWidth: 300.0, minHeight: 170.0)
                .padding()
            })
        } else {
            VStack {
                Image(systemName: "nosign")
                    .frame(width: 48.0, height: 48.0)
                Text("出现错误，可能的原因：路径不可用或文件被手动修改。")
                    .font(.title).padding(.bottom)
                Button(
                    action: { model.loadSentences() }, label: {
                    Text("group.retry")
                })
            }.padding()
        }
    }
    
    private func cleanAddWindowAndClose() {
        selectedGroup = "please-choose"
        sentenceContext = ""
        showAddSheet = false
    }
}

#Preview {
    SentenceScreen()
}
