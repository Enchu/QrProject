//
//  SearchHome.swift
//  QrProject
//
//  Created by Алексей Германов on 13.05.2022.
//

import SwiftUI

struct SearchHome: View {
    @ObservedObject var model = ViewModel()
    @State var txt = ""
    
    var body: some View{
        NavigationView{
            ScrollView{
            VStack (spacing: 10){
                    HStack(){
                        TextField("Поиск", text: self.$txt).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.top)
                        if self.txt != ""{
                            Button(action: {
                                self.txt = ""
                            })
                            {
                                Text("Закрыть")
                            }.foregroundColor(.black).padding(.top)
                        }
                    }.padding()
                    
                    if self.txt != ""{
                        if self.model.list.filter({$0.datetime.lowercased().contains(self.txt.lowercased())}).count == 0
                        {
                            Text("Нет результата").foregroundColor(Color.black.opacity(0.5)).padding()
                        }
                        else{
                            ForEach(self.model.list.filter{
                                $0.datetime.lowercased().contains(self.txt.lowercased())
                                || $0.name.lowercased().contains(self.txt.lowercased())
                            })
                            {i in
                                NavigationLink(destination: Detail(data: i))
                                {
                                    VStack(alignment:.leading){
                                        Text(i.name).font(.headline)
                                        HStack{
                                            Text(i.datetime)
                                            Spacer()
                                            if i.notes != "" {
                                                Image(systemName: "pencil")
                                            }
                                        }
                                    }
                                }.foregroundColor(.white)
                                    .padding()
                                    .background(Color("DarkBlueRGB").cornerRadius(10))
                                    .padding(.horizontal)
                            }
                        }
                    }
                    else{
                        ForEach(self.model.list.sorted(by: {$0.datetime > $1.datetime}))
                        {i in
                            NavigationLink(destination: Detail(data: i))
                            {
                                VStack(alignment:.leading){
                                    Text(i.name).font(.headline)
                                    HStack{
                                        Text(i.datetime)
                                        Spacer()
                                        if i.notes != "" {
                                            Image(systemName: "pencil")
                                        }
                                    }
                                }
                            }.foregroundColor(.white)
                                .padding()
                                .background(Color("DarkBlueRGB").cornerRadius(10))
                                .padding(.horizontal)
                        }
                    }
                    Divider()
                }
            }.navigationTitle("Назад к поиску")
                .navigationBarHidden(true)
                .navigationViewStyle(StackNavigationViewStyle())
                .background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
        }
    }
    init(){
        model.getData()
    }
}

struct SearchHome_Previews: PreviewProvider {
    static var previews: some View {
        SearchHome()
    }
}
