class UserData { 
  static int? user_id;
   
  setUserId(int id){
     user_id = id;
  }

  getUserId(){
    return user_id;
  }
}