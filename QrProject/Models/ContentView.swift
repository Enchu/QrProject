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
    @State private var selection = 1
    var body: some View {
        TabView(selection:$selection){
            ArraysHomeView().tabItem({
                Image(systemName: "house")
                Text("Главная")
            }).tag(1)
            SearchTable().tabItem({
                Image(systemName: "magnifyingglass")
                Text("Поиск")
            }).tag(2)
            ArrayesFilter().tabItem({
                Image(systemName: "link")
                Text("Фильтр")
            }).tag(3)
        }.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .font(.headline)
    } //End View
    init(){
        //UITabBar.appearance().backgroundColor = UIColor(Color("BlueRGB"))
        //UITabBar.appearance().isTranslucent = false
        //UITabBar.appearance().barTintColor = UIColor.blue
    }
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
                                    VStack(alignment:.leading){
                                        Text(i.name).font(.headline)
                                        HStack{
                                            Text(i.datetime)
                                            Spacer()
                                            if i.notes != "" {
                                                Image(systemName: "pencil")
                                            }
                                        }
                                        if i.notes != ""{
                                            Text(i.notes).font(.title2)
                                                .fontWeight(.bold)
                                        }
                                        if i.photo != ""{
                                            Text("Посмотреть фото")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .underline()
                                                .onTapGesture {
                                                    let url = URL(string: i.photo)
                                                    UIApplication.shared.open(url!)
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
                                VStack(alignment:.leading){
                                    Text(i.name).font(.headline)
                                    HStack{
                                        Text(i.datetime)
                                        Spacer()
                                        if i.notes != "" {
                                            Image(systemName: "pencil")
                                        }
                                    }
                                    if i.notes != ""{
                                        Text(i.notes).font(.title2)
                                            .fontWeight(.bold)
                                    }
                                    if i.photo != ""{
                                        Text("Посмотреть фото")//.font(Font.custom("AvenirNext-Medium",size: 20))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .underline()
                                            .onTapGesture {
                                                let url = URL(string: i.photo)
                                                UIApplication.shared.open(url!)
                                            }
                                    }
                                }.foregroundColor(.white)
                                    .padding()
                                    .background(Color("DarkBlueRGB").cornerRadius(10))
                                    .padding(.horizontal)
                        }
                    }
                }
            }.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
    }//End View
    
    init() {
        model.getData()
    }
}

struct HomeView:View{
    @ObservedObject var model = ViewModel()
    @State private var showingAlert = false
    @State var txt = ""
    let Probel = " "
    
    func compareDates(_ first: String, _ second: String) -> Bool {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd/MM/yyyy"
        return formatterDate.date(from: first)! < formatterDate.date(from: second)!
    }
    
    var body: some View{
        //Update and Delete
        NavigationView(){
            ZStack(alignment: .top){
                GeometryReader{_ in}.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
            VStack(spacing: 0){
                List(model.list.sorted(by: {$0.datetime > $1.datetime})) { item in
            HStack{
                if(item.notes == ""){
                    Group{ Text(item.name + Probel + item.datetime)
                    }.background(Color("GreenRGB"))
                }
                else{
                    Group{ Text(item.name + Probel + item.datetime)
                    }.background(Color.red).foregroundColor(.white)//.background(Color("RedRGB"))
                }
                Spacer()
                //Delete data
                Button(action: {
                    showingAlert = true
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
        }//.padding(.top).background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
    }
    init() {
        model.getData()
    }
}

struct ArraysHomeView: View{
    
    @ObservedObject var model = ViewModel()
    @State private var showingAlert = false
    @State var txt = ""
    let Probel = " "
    
    var body: some View{
        ScrollView{
            VStack(spacing:10){
                ForEach(model.list.sorted(by: {$0.datetime > $1.datetime})) { item in
                    VStack(alignment:.leading){
                        Text(item.name).font(.headline)
                        HStack{
                            Text("Дата и время: \(item.datetime)")
                            Spacer()
                            if item.notes != "" {
                                Image(systemName: "pencil")
                            }
                            Button(action: {
                                showingAlert = true
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
                    }
                }.foregroundColor(.white)
                    .padding()
                    .background(Color("DarkBlueRGB").cornerRadius(10))
                    .padding(.horizontal)
            }
        }.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
    }
    
    init(){
        model.getData()
    }
}

struct ArrayesFilter:View{
    @ObservedObject var model = ViewModel()
    @State var dateStart = Date()
    @State var dateEnd = Date()
    @State var txt = ""
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        return dateFormatter
    }()
    
    var body: some View{
        ScrollView{
            VStack(spacing: 10){
                VStack(){
                    DatePicker("Дата начала", selection: $dateStart,displayedComponents: [.date]).environment(\.locale, Locale.init(identifier: "ru_Ru")).padding(.top)
                    DatePicker("Дата окончания", selection: $dateEnd,displayedComponents: [.date]).environment(\.locale, Locale.init(identifier: "ru_Ru")).padding(.top)
                }.padding()
                var txtStart = dateFormatter.string(from: dateStart)
                var txtEnd = dateFormatter.string(from: dateEnd)
                    
                if dateStart != dateEnd{
                    ForEach(self.model.list.filter{
                        $0.datetime.lowercased() >= txtStart.lowercased() && $0.datetime.lowercased() <= txtEnd.lowercased()
                    }){i in
                        VStack(alignment:.leading){
                            Text(i.name).font(.headline).font(.headline)
                            HStack{
                                Text(i.datetime).font(.headline)
                                Spacer()
                            }
                        }
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color("DarkBlueRGB").cornerRadius(10))
                    .padding(.horizontal)
                }
            }
        }.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
    }
    
    init() {
        model.getData()
    }
}

struct Detail: View{
    var data : QFData
    
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
            }.font(Font.custom("Apple SD Gothic Neo", size: 20))
        }
    }
}
