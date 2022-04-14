//
//  ContentView.swift
//  QrProject
//
//  Created by Алексей Германов on 12.04.2022.
//
import UIKit
import SwiftUI
import Firebase
import CoreMedia


struct ContentView: View {
    
    @ObservedObject var model = ViewModel()

    @State var datetime = ""
    @State var name = ""
    @State var uid = ""
    @State var notes = ""
    
    @State var txt = ""
    
    var body: some View {
        
        //search
        NavigationView(){
            ZStack(alignment: .top){
                VStack (spacing: 0){
                    HStack(){
                        TextField("Поиск", text: self.$txt).textFieldStyle(RoundedBorderTextFieldStyle())
                        if self.txt != ""{
                            Button(action: {
                                self.txt = ""
                            }, label: {Text("Закрыть")}).foregroundColor(.black)
                        }
                    }.padding()
                    
                    if self.txt != ""{
                        if self.model.list.filter({$0.datetime.lowercased().contains(self.txt.lowercased())}).count == 0
                        {
                            Text("Нет результата").padding().foregroundColor(Color.black.opacity(0.5)).padding()
                        }
                        else{
                            List(self.model.list.filter{$0.datetime.lowercased().contains(self.txt.lowercased())})
                            {i in
                                NavigationLink(destination: Detail(data: i)){
                                Text(i.name)
                                Text(i.datetime)
                                }
                            }.frame(height: UIScreen.main.bounds.height / 5)
                        }
                    }
                }
                //CustomSearchBar(data: self.$model.list).padding(.top)
                //model.searchData(qfUpdate: item)
        }
        }.navigationTitle("").navigationBarHidden(true)
        
        
        //Update and Delete
        VStack(spacing: 0){
        List(model.list){ item in
            HStack{
                if(item.notes == "")
                {
                    Text(item.datetime).background().colorMultiply(.green)
                    Text(item.name).background().colorMultiply(.green)
                }
                else{
                    Text(item.datetime).background().colorMultiply(.red)
                    Text(item.name).background().colorMultiply(.red)
                    
                }
                
                Spacer()
                
                //Updata data
                Button(action: {
                    model.updataData(qfUpdate: item)
                }, label: {
                    Image(systemName: "pencil")
                })
                .buttonStyle(BorderedButtonStyle())
                
                //delete
                Button(action: {
                    model.deleteData(qfDelete: item)
                }, label: {
                    Image(systemName: "minus.circle")
                })
                .buttonStyle(BorderedButtonStyle())
            }
        }
            
            
            /*Divider()
            //Add data
            VStack(spacing:5){
                TextField("datetime",text: $datetime)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("name",text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    model.addData(datetime: datetime, name: name)
                    
                    datetime = ""
                    name = ""
                    
                }, label: {
                    Text("Add data item")
                })
            }.padding()
             */
        }//End VStack
        
        
        //Back to Login Page
        /*VStack(spacing:5){
            Button(action: {
                
            }, label: {
                Text("Back")
            })
            .buttonStyle(BorderedButtonStyle())
        }.padding()*/
        
        
    }
    init() {
        model.getData()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CustomSearchBar:View{
    
    @ObservedObject var model = ViewModel()
    @Binding var data : [QFData]
    @State var txt = ""
    
    var body: some View{
        VStack (spacing: 0){
            HStack(){
                TextField("Поиск", text: self.$txt)
                if self.txt != ""{
                    Button(action: {
                        self.txt = ""
                    }, label: {Text("Закрыть")}).foregroundColor(.black)
                }
            }.padding()
            if self.txt != ""{
                if self.model.list.filter({$0.datetime.lowercased().contains(self.txt.lowercased())}).count == 0
                {
                    Text("Нет результата").foregroundColor(Color.black.opacity(0.5)).padding()
                }
                else{
                    List(self.model.list.filter{$0.datetime.lowercased().contains(self.txt.lowercased())})
                    {i in
                        NavigationLink(destination: Detail(data: i)){
                            Text(i.name)
                            Text(i.datetime)
                        }
                    }.frame(height: UIScreen.main.bounds.height / 5)
                }
            }
        }.background(Color.white).padding()
        
    }//End View
}


struct Detail: View{
    var data : QFData
    @ObservedObject var model = ViewModel()
    @State var datetime = ""
    @State var name = ""
    @State var uid = ""
    @State var notes = ""
    
    @State var isHidden = false
    
    var body: some View{
        Text(data.name)
        Text(data.datetime)
        //Text(data.uid)
        Text(data.notes)
        
        /*List(model.list){item in
            HStack{
                    Text(item.datetime).background().colorMultiply(.green)
                    Text(item.name).background().colorMultiply(.green)
            }
            Divider()
            VStack(spacing:5){
                TextField("Комментарий",text: $notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    model.updataData(qfUpdate: item)
                }, label: {
                }).buttonStyle(BorderedButtonStyle())
            }.padding()
        }.opacity(isHidden ? 0 : 1)
        Button("Tougle"){
            isHidden.toggle()
        }*/
    }
}
