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
    @State var txt = ""
    
    var body: some View{
        NavigationView(){
            ZStack(alignment: .top){
                GeometryReader{_ in}.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
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
                            List(self.model.list.filter{$0.datetime.lowercased().contains(self.txt.lowercased())})
                            {i in
                                NavigationLink(destination: Detail(data: i))
                                {
                                    Text(i.name)
                                    Text(i.datetime)
                                }
                            }.background().colorMultiply(Color("BlueRGB"))
                                .foregroundColor(.black)
                        }
                    }
                    else{
                        List(self.model.list)
                        {i in
                            NavigationLink(destination: Detail(data: i))
                            {
                                Text(i.name)
                                Text(i.datetime)
                            }
                        }.background().colorMultiply(Color("BlueRGB"))
                            .foregroundColor(.black)
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
    @State private var showingAlert = false
    @State var txt = ""
    
    var body: some View{
        //Update and Delete
        NavigationView(){
            ZStack(alignment: .top){
                GeometryReader{_ in}.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
            VStack(spacing: 0){
                List(model.list){ item in
            HStack{let Probel = " "
                if(item.notes == ""){
                    Group{
                        Text(item.datetime + Probel + item.name)
                    }.background(Color("GreenRGB"))
                }
                else{
                    Group{
                        Text(item.datetime + Probel + item.name)
                    }.background(Color.red).foregroundColor(.white)//.background(Color("RedRGB"))
                }
                Spacer()
                //Delete data
                Button(action: {
                    showingAlert = true
                    //model.deleteData(qfDelete: item)
                }, label: {
                    Image(systemName: "minus.circle")
                }).buttonStyle(BorderedButtonStyle())
                    .alert(isPresented: $showingAlert){
                    Alert(
                    title: Text("Вы действительно хотите удалить"),
                    primaryButton: .destructive(Text("Удалить"),action:{
                    model.deleteData(qfDelete: item)
                }),
                      secondaryButton:.cancel(Text("Отменить"),action: {
                }))}
            }
                }.background().colorMultiply(Color("BlueRGB"))
                    .font(Font.custom("Apple SD Gothic Neo", size: 20))
                Divider()
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
    
    @State var dateStart = Date()
    @State var dateEnd = Date()
    @State var txt = ""
    
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        return dateFormatter
    }()
    
    var body: some View{
        ZStack(alignment: .top){
            GeometryReader{_ in}.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
            VStack(spacing: 0){
                DatePicker("Дата начала", selection: $dateStart).environment(\.locale, Locale.init(identifier: "ru_Ru"))
                DatePicker("Дата окончания", selection: $dateEnd).environment(\.locale, Locale.init(identifier: "ru_Ru"))
                /*if self.model.list.filter({$0.datetime.lowercased().contains(dateFormatter.string(from: dateStart))}).count == 0
                && self.model.list.filter({$0.datetime.lowercased().contains(dateFormatter.string(from: dateEnd))}).count == 0
                {
                    Text("Нет результата").foregroundColor(Color.black.opacity(0.5)).padding()
                }*/
                //else{
                if dateStart != dateEnd{
                    var txtStart = dateFormatter.string(from: dateStart)
                    var txtEnd = dateFormatter.string(from: dateEnd)
                    List(self.model.list.filter{
                        $0.datetime.lowercased() > txtStart.lowercased() && $0.datetime.lowercased() < txtEnd.lowercased()
                    })
                    {i in
                        NavigationLink(destination: Detail(data: i)){
                            Text(i.name)
                            Text(i.datetime)
                        }
                    }.background().colorMultiply(Color("BlueRGB")).foregroundColor(.black)
                //}
                }
                else{
                    List(self.model.list)
                    {i in
                        NavigationLink(destination: Detail(data: i)){
                        Text(i.name)
                        Text(i.datetime)
                        }
                    }.background().colorMultiply(Color("BlueRGB")).foregroundColor(.black)
                }
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
