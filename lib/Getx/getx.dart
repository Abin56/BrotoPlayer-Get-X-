import 'package:broto_player/Database/datamode.dart';
import 'package:broto_player/Fetching%20files/InnerFetching/fetch_video_data.dart';
import 'package:broto_player/Pages/Recent/R_video_list.dart';
import 'package:broto_player/main.dart';
import 'package:broto_player/widgets/Splashscreens/splashscreen.dart';
import 'package:get/get.dart';

class StateGetx extends GetxController{
  
  @override
  void onInit() {
   splashFetch();
  
    super.onInit();
  }
  int currentIndex = 0;
  currentindex(int index){
    currentIndex =  index;
    update();

  }
  getRecentStatus({required String path}) {
  List<Recentlistingmode> recList = recentDB.values.toList();

  List<Recentlistingmode> result =
      recList.where((checking) => checking.recentpath == path).toList();

  if (result.isEmpty) {
    var recObj = Recentlistingmode(recentpath: path);
    recentDB.add(recObj);
  } else {
   boolrec = true;
  }
}
  
  

  
}