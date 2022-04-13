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
    
    @State var txt = ""
    
    var body: some View {
        
        //Search
        NavigationView(){
            ZStack(alignment: .top){
                GeometryReader{_ in
                }.background(Color("Color").edgesIgnoringSafeArea(.all))
                
                VStack (spacing: 0){
                    HStack(alignment: .top){
                        
                        TextField("Search", text: self.$txt)
                        if self.txt != ""{
                            Button(action: {
                                self.txt = ""
                            }, label: {Text("Cansel")}).foregroundColor(.black)
                        }
                    }.padding()
                    if self.txt != ""{
                        if self.model.list.filter({$0.datetime.lowercased().contains(self.txt.lowercased())}).count == 0
                        {
                            Text("No result").foregroundColor(Color.black.opacity(0.5)).padding()
                        }
                        else{
                            List(self.model.list.filter{$0.datetime.lowercased().contains(self.txt.lowercased())})
                            {i in
                                NavigationLink(destination: Detail(data: i)){
                                    Text(i.name)
                                    Text(i.datetime)
                                }
                            }.frame(height: UIScreen.main.bounds.height / 5)//.frame(height: UIScene.main.bounds.height / 5)
                        }
                    }
                }.background(Color.white).padding()
                //model.searchData(qfUpdate: item)
            }
        }.navigationTitle("").navigationBarHidden(true)
       
        
        //
        VStack{
        List(model.list){
            item in
            HStack{
                Text(item.datetime)
                Text(item.name)
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
            Divider()
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

        }//End VStack
        
        //Back to Login Page
        VStack(spacing:5){
            Button(action: {
                
            }, label: {
                Text("Back")
            })
            .buttonStyle(BorderedButtonStyle())
        }.padding()
        
        
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


struct Detail: View{
    var data : QFData
    var body: some View{
        Text(data.name)
        Text(data.datetime)
        Text(data.uid)
    }
}
