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
    @State var photo = ""
    
    @State var txt = ""

    var body: some View {
        
        //Update and Delete
        NavigationView(){
            ZStack(alignment: .top){
            VStack(spacing: 0){
                List(model.list){ item in
            HStack{
                if(item.notes == ""){
                    Text(item.datetime).background().colorMultiply(.green)
                    Text(item.name).background().colorMultiply(.green)
                }
                else{
                    Text(item.datetime).background().colorMultiply(.red)
                    Text(item.name).background().colorMultiply(.red)}
                Spacer()
                //Updata data
                /*Button(action: {
                    model.updataData(qfUpdate: item)
                }, label: {
                    Image(systemName: "pencil")
                })
                .buttonStyle(BorderedButtonStyle())*/
                
                //Delete data
                Button(action: {
                    model.deleteData(qfDelete: item)
                }, label: {
                    Image(systemName: "minus.circle")
                })
                .buttonStyle(BorderedButtonStyle())
            }
        }
                Divider()
                VStack(spacing: 10){
                    NavigationLink("Поиск",destination: SearchTable()).padding()
                }
            /*NavigationLink(){ SearchTable() }
            label: { Text("Поиск") }
            }.padding()*/
        }
            }
        }.navigationTitle("").navigationViewStyle(StackNavigationViewStyle())
        
        
        //Back to Login Page
        /*VStack(spacing:5){
            Button(action: {
                
            }, label: {
                Text("Back")
            })
            .buttonStyle(BorderedButtonStyle())
        }.padding()*/
    } //End View
    
    init() {
        model.getData()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchTable:View{
    
    @ObservedObject var model = ViewModel()

    @State var datetime = ""
    @State var name = ""
    @State var uid = ""
    @State var notes = ""
    @State var txt = ""
    
    var body: some View{
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
                            }
                        }
                    }
                }
            }
        }.navigationTitle("").navigationViewStyle(StackNavigationViewStyle())
    }
    init() {
        model.getData()
    }
}

struct Detail: View{
    var data : QFData
    @ObservedObject var model = ViewModel()
    @State var datetime = ""
    @State var name = ""
    @State var uid = ""
    @State var notes = ""
    @State var photo = ""
    
    var body: some View{
        Text(data.name)
        Text(data.datetime)
        //Text(data.uid)
        Text(data.notes)
        if data.notes != ""{
            Text(data.photo).onTapGesture {
                let url = URL(string: data.photo)
                UIApplication.shared.open(url!)
                //print("1\(data.photo)")
            }.foregroundColor(.blue)
        }
    }
}
