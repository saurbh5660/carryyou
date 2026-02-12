import 'package:get/get.dart';
import '../model/interest_model.dart';

class InterestController extends GetxController {
  RxList<InterestModel> interestList = RxList();

  @override
  void onInit() {
    super.onInit();
    interestList.clear();
    interestList.add(InterestModel(name: 'Basketball', selected: false));
    interestList.add(InterestModel(name: 'Fitness', selected: false));
    interestList.add(InterestModel(name: 'Wellness', selected: false));
    interestList.add(InterestModel(name: 'Community', selected: false));
  }

  void toggleInterest(int index){
    interestList[index].selected = !interestList[index].selected;
    interestList.refresh();
  }

}
