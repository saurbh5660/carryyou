import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final DatePickerController _datePickerController = DatePickerController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Events',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDatePicker(),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (item, index) {
                return _eventItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        controller: _datePickerController,
        initialSelectedDate: DateTime.now(),
        selectionColor: AppColor.transparent,
        selectedTextColor: AppColor.yellowColor,
        dateTextStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColor.blackColor,
        ),
        dayTextStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
        monthTextStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Widget _eventItem() {
    return GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.eventDetail);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(Assets.imagesDummyImage, width: 140, height: 140,fit: BoxFit.cover,),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text('International Music Festival dfdsgdsg',style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                  )),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month,size: 20,color: Colors.grey.shade500,),
                            SizedBox(width: 3),
                            Flexible(
                              child: Text('16 April, 2025',style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black
                              )),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded,size: 20,color: Colors.grey.shade500),
                            SizedBox(width: 3),
                            Flexible(
                              child: Text('05:30 PM',style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black
                              )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,size: 20,color: Colors.grey.shade500,),
                      SizedBox(width: 3),
                      Flexible(
                        child: Text('Elberto, Canada',style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  profileAvatarStack([
                    'https://randomuser.me/api/portraits/men/1.jpg',
                    'https://randomuser.me/api/portraits/women/2.jpg',
                    'https://randomuser.me/api/portraits/men/3.jpg',
                    'https://randomuser.me/api/portraits/women/4.jpg',
                    'https://randomuser.me/api/portraits/men/5.jpg',
                    'https://randomuser.me/api/portraits/men/5.jpg',
                  ]),
                  SizedBox(height: 6),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget profileAvatarStack(List<String> images) {
    final int maxVisible = 3;
    final double size = 26;
    final double overlap = 18;

    int remaining = images.length - maxVisible;

    return SizedBox(
      height: size,
      width: images.length > maxVisible
          ? (maxVisible + 1) * overlap + size
          : images.length * overlap + size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Show max 3 profile images
          for (int i = 0; i < images.length && i < maxVisible; i++)
            Positioned(
              left: i * overlap,
              child: _circleImage(images[i], size),
            ),

          // Show +N if more than 3
          if (remaining > 0)
            Positioned(
              left: maxVisible * overlap,
              child: _moreCountCircle(remaining, size),
            ),
        ],
      ),
    );
  }

  Widget _circleImage(String image, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _moreCountCircle(int count, double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        '+$count',
        style: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

}
