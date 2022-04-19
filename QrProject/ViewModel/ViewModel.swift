//
//  ViewModel.swift
//  QrProject
//
//  Created by Алексей Германов on 12.04.2022.
//

import Foundation
import Firebase

class ViewModel: ObservableObject{
    @Published var list = [QFData]()
    
    func updataData(qfUpdate:QFData){
        let db = Firestore.firestore()
        
        db.collection("qf").document(qfUpdate.id).setData(["notes": (qfUpdate.notes)],merge: true){ error in
        //db.collection("qf").document(qfUpdate.id).setData(["notes": notes],merge: true){ error in
            if error == nil{
                self.getData()
            }
        }
    }
    
    func deleteData(qfDelete:QFData){
        let db = Firestore.firestore()
        
        db.collection("qf").document(qfDelete.id).delete {error in
            if error == nil{
                
                DispatchQueue.main.async {
                    self.list.removeAll { qf in
                        return qf.id == qfDelete.id
                    
                    }
                }
            }
        }
    }
    
    func addData(datetime:String,name:String,notes:String){
        let db = Firestore.firestore()
        db.collection("qf").addDocument(data: ["datetime":datetime, "name":name,"notes":notes]){
            error in
            if error == nil{
                self.getData()
            }
            else{
                
            }
        }
    }
    
    func searchData(){
        let db = Firestore.firestore()
        db.collection("qf").getDocuments{snapshot,error in
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            for i in snapshot!.documents{
                let id = i.documentID
                let datetime = i.get("datetime") as! String
                let name = i.get("name") as! String
                let uid = i.get("uid") as! String
                let notes = i.get("notes") as! String
                let photo = i.get("photo") as! String
                self.list.append(QFData(id: id, name: name, datetime: datetime, uid: uid,notes: notes,photo: photo))
        }
    }
    }
    
    func getData(){
        let db = Firestore.firestore()
        db.collection("qf").getDocuments{snapshot,error in
            if error == nil{
               //No errors
                if let shapshot = snapshot{
                    //Update the list property in the main theard
                    DispatchQueue.main.async {
                        //get all the documents and Create qf
                        self.list = shapshot.documents.map{d in
                            //Crate a QF item for each document returned
                            return QFData(id: d.documentID, name: d["name"] as? String ?? "",
                                          datetime: d["datetime"] as? String ?? "",
                                          uid: d["uid"] as? String ?? "",
                                          notes:d["notes"] as? String ?? "",
                                        photo:d["photo"] as? String ?? "")
                                            
                        }
                    }
                    
                }
            }
            else{
                //handle the error
            }
            
        }
    }
}
