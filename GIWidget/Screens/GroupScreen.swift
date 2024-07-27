//
//  GroupScreen.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/23.
//

import SwiftUI

struct GroupScreen: View {
    @ObservedObject private var model: GroupScreenModel = GroupScreenModel()
    @State private var showAlert = false
    @State private var showAddGroup = false
    @State private var alertMsg = ""
    @State private var newGroup = ""
    
    init (){
        model.loadGroups()
    }
    
    var body: some View {
        if !model.showExtraButton {
            VStack {
                HStack {
                    Text("group.explanation")
                        .padding(.leading)
                    Spacer()
                }
                Form {
                    ForEach(model.groups.indices, id: \.self){ single in
                        HStack {
                            Image(systemName: "list.triangle")
                                .padding(.trailing)
                            Text(model.groups[single])
                            Spacer()
                            Button(action: {
                                let result = model.removeGroup(index: single)
                                if !result.eventOK {
                                    showAlert = true
                                    alertMsg = result.message!
                                }
                            }, label: {
                                Image(systemName: "trash.circle")
                                    .help("group.remove")
                            })
                        }
                    }
                }.formStyle(.grouped)
            }
            .navigationTitle(Text("home.menu.group.manager"))
            .toolbar {
                ToolbarItem {
                    Button(action: { showAddGroup = true }, label: {
                        Image(systemName: "plus")
                            .help("group.add")
                    })
                }
                ToolbarItem {
                    Button(action: {
                        let result = model.saveGroups()
                        if !result {
                            showAlert = true
                            alertMsg = "出现错误，无法保存。"
                        }
                    }, label: {
                        Image(systemName: "square.and.arrow.down")
                            .help("group.save")
                    })
                }
            }
            .alert(
                "group.error.dialog",
                isPresented: $showAlert,
                actions: {
                    Button(action: {
                        showAlert = false
                        alertMsg = ""
                    }, label: {
                        Text("app.event.ok")
                    })
                },
                message: { Text(alertMsg) }
            )
            .sheet(isPresented: $showAddGroup, content: {
                VStack {
                    Text("group.add").font(.headline).padding(.bottom)
                    TextField("group.name", text: $newGroup)
                    Text("group.name.tip")
                    HStack {
                        Button("app.event.cancel", action: {
                            cleanAddWindowAndClose()
                        }).padding(.trailing)
                        Button("app.event.confirm", action: {
                            model.addGroupItem(name: newGroup)
                            cleanAddWindowAndClose()
                        })
                    }.padding(.top)
                }.padding().frame(minWidth: 300.0, minHeight: 160.0)
            })
        } else {
            VStack {
                Image(systemName: "nosign")
                    .frame(width: 48.0, height: 48.0)
                Text(model.extraMsg)
                    .font(.title).padding(.bottom)
                Button(
                    action: { model.loadGroups() }, label: {
                    Text("group.retry")
                })
            }.padding()
        }
    }
    
    private func cleanAddWindowAndClose() {
        newGroup = ""
        showAddGroup = false
    }
}

#Preview {
    GroupScreen()
}
