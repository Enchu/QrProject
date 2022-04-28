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
import AVFAudio


struct ContentView: View {

    @State var datetime = ""
    @State var name = ""
    @State var uid = ""
    @State var notes = ""
    @State var photo = ""
    
    @State var txt = ""
    var body: some View {
        TabView{
            HomeView().tabItem({
                Image(systemName: "house")
                Text("Главная")
            })
            SearchTable().tabItem({
                Image(systemName: "magnifyingglass")
                Text("Поиск")
            })
            Filter().tabItem({
                Image(systemName: "link")
                Text("Фильтр")
            })
        }.background(Color("BlueRGB")).edgesIgnoringSafeArea(.all)
    } //End View
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
                GeometryReader{_ in
                    //Text("Home")
                }.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
                
                VStack (spacing: 0){
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
                            List(self.model.list.filter{$0.datetime.lowercased().contains(self.txt.lowercased())}
                            )
                            {i in
                                NavigationLink(destination: Detail(data: i)){
                                Text(i.name)
                                Text(i.datetime)
                                }
                            }.background().colorMultiply(Color("BlueRGB"))
                                .foregroundColor(.black)
                        }
                    }
                    Divider()
                }
            }.navigationTitle("Назад к поиску")
                .navigationBarHidden(true)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    init() {
        model.getData()
    }
}

struct HomeView:View{
    @ObservedObject var model = ViewModel()
    @State var datetime = ""
    @State var name = ""
    @State var uid = ""
    @State var notes = ""
    @State var photo = ""
    
    @State var txt = ""
    
    var body: some View{
        //Update and Delete
        NavigationView(){
            ZStack(alignment: .top){
                GeometryReader{_ in}.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
            VStack(spacing: 0){
                List(model.list){ item in
            HStack{
                var Probel = " "
                if(item.notes == ""){
                    Group{
                        Text(item.datetime + Probel + item.name)
                    }.background(Color("GreenRGB"))
                        .font(Font.custom("Apple SD Gothic Neo", size: 20))
                }
                else{
                    Group{
                        Text(item.datetime + Probel + item.name)
                    }.background(Color("RedRGB"))//Color("RedRGB")
                        .font(Font.custom("Apple SD Gothic Neo", size: 20))
                }
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
                }.background().colorMultiply(Color("BlueRGB"))
                    .foregroundColor(.black)
                //End List
                Divider()
                //VStack(spacing: 10){NavigationLink("Поиск",destination: SearchTable())}
        }
            }.navigationTitle("Назад")
                .navigationBarHidden(true)
                .navigationViewStyle(StackNavigationViewStyle())
        }.padding(.top).background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
    }
    init() {
        model.getData()
        //UITableView.appearance().backgroundColor = .clear
    }
}

struct Filter:View{
    @ObservedObject var model = ViewModel()
    @State private var dateTime = Date()
    @State var dateStart = Date()
    @State var dateEnd = Date()
    
    var body: some View{
        ZStack(alignment: .top){
            GeometryReader{_ in}.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
            VStack(spacing: 10){
                DatePicker("Дата начала", selection: $dateTime).environment(\.locale, Locale.init(identifier: "ru_Ru")).padding(.top)
                DatePicker("Дата окончания", selection: $dateTime).environment(\.locale, Locale.init(identifier: "ru_Ru")).padding(.top)
                Divider()
                //let fallsBerween = (dateStart ... dateEnd).contains(Date())
                //print(fallsBerween)
            }.padding()
        }
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
        ZStack(alignment: .top){
        GeometryReader{_ in
        }.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
            VStack (spacing: 10){
            Text(data.name)
            Text(data.datetime)
            Text(data.notes)
            if data.notes != ""{
                Text(data.photo).onTapGesture {
                    let url = URL(string: data.photo)
                    UIApplication.shared.open(url!)
                }.foregroundColor(Color("DarkBlueRGB"))
            }
            }
        }
    }
}
