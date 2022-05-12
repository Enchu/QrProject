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
            ArraysHomeView().tabItem({
                Image(systemName: "house")
                Text("Главная")
            })
            /*HomeView().tabItem({
                Image(systemName: "house")
                Text("Главная")
            })*/
            SearchTable().tabItem({
                Image(systemName: "magnifyingglass")
                Text("Поиск")
            })
            /*Filter().tabItem({
                Image(systemName: "link")
                Text("Фильтр")
            })*/
            ArrayesFilter().tabItem({
                Image(systemName: "link")
                Text("Фильтр")
            })
        }.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
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
            ScrollView{
                //GeometryReader{_ in}.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
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
                            List(self.model.list.filter{
                                $0.datetime.lowercased().contains(self.txt.lowercased()) ||
                                $0.name.lowercased().contains(self.txt.lowercased())})
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
                        ForEach(self.model.list.sorted(by: {$0.datetime > $1.datetime}))
                        {i in
                            NavigationLink(destination: Detail(data: i))
                            {
                                VStack(alignment:.leading){
                                    HStack{
                                        Text(i.name)
                                        Text(i.datetime)
                                        Spacer()
                                    }
                                }
                            }.foregroundColor(.white)
                                .padding()
                                .background(Color("DarkBlueRGB").cornerRadius(10))
                                .padding(.horizontal)
                        }//.background().colorMultiply(Color("BlueRGB")).foregroundColor(.black)
                    }
                    Divider()
                }
            }.navigationTitle("Назад к поиску")
                .navigationBarHidden(true)
                .navigationViewStyle(StackNavigationViewStyle())
                .background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
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

struct Filter:View{
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
        ZStack(alignment: .top){
            GeometryReader{_ in}.background(Color("BlueRGB").edgesIgnoringSafeArea(.all))
            VStack(spacing: 10){
                DatePicker("Дата начала", selection: $dateStart,displayedComponents: [.date]).environment(\.locale, Locale.init(identifier: "ru_Ru")).padding(.top)
                DatePicker("Дата окончания", selection: $dateEnd,displayedComponents: [.date]).environment(\.locale, Locale.init(identifier: "ru_Ru")).padding(.top)
                    var txtStart = dateFormatter.string(from: dateStart)
                    var txtEnd = dateFormatter.string(from: dateEnd)
                    
                    List(self.model.list.filter{
                        $0.datetime.lowercased() >= txtStart.lowercased() && $0.datetime.lowercased() <= txtEnd.lowercased()
                    })
                    {i in
                        NavigationLink(destination: Detail(data: i)){
                            Text(i.name)
                            Text(i.datetime)
                        }
                    }.foregroundColor(.black).background().colorMultiply(Color("BlueRGB"))
            }
        }
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
                                Image(systemName: "flame.fill")
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
                }
                    .foregroundColor(.white)
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
                DatePicker("Дата начала", selection: $dateStart,displayedComponents: [.date]).environment(\.locale, Locale.init(identifier: "ru_Ru")).padding()
                DatePicker("Дата окончания", selection: $dateEnd,displayedComponents: [.date]).environment(\.locale, Locale.init(identifier: "ru_Ru")).padding()
                var txtStart = dateFormatter.string(from: dateStart)
                var txtEnd = dateFormatter.string(from: dateEnd)
                    
                if dateStart != dateEnd{
                    ForEach(self.model.list.filter{
                        $0.datetime.lowercased() >= txtStart.lowercased() && $0.datetime.lowercased() <= txtEnd.lowercased()
                    }){i in
                        VStack(alignment:.leading){
                            HStack{
                                Text(i.name).font(.headline)
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
