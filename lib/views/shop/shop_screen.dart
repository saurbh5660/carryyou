import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../generated/assets.dart';
import '../../routes/app_routes.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

/* ================= MODELS ================= */

class CategoryModel {
  final IconData icon;
  final String title;

  CategoryModel({required this.icon, required this.title});
}

class GenderModel {
  final IconData icon;
  final String title;

  GenderModel({required this.icon, required this.title});
}

/* ================= SCREEN ================= */

class _ShopScreenState extends State<ShopScreen> {
  // Categories (Backend ready)
  final List<CategoryModel> categories = [
    CategoryModel(icon: Icons.checkroom, title: 'Fashion'),
    CategoryModel(icon: Icons.devices, title: 'Electronics'),
    CategoryModel(icon: Icons.brush, title: 'Beauty'),
    CategoryModel(icon: Icons.chair, title: 'Furniture'),
  ];

  // Gender filters (Backend ready)
  final List<GenderModel> genders = [
    GenderModel(icon: Icons.male, title: 'Men'),
    GenderModel(icon: Icons.female, title: 'Women'),
    GenderModel(icon: Icons.child_care, title: 'Kids'),
  ];

  int selectedCategoryIndex = 0;
  int selectedGenderIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBar(),
            const SizedBox(height: 12),
            _searchBar(),
            const SizedBox(height: 16),
            _categorySection(),
            const SizedBox(height: 16),
            _genderSection(),
            const SizedBox(height: 16),
            Expanded(child: _productGrid()),
          ],
        ),
      ),
    );
  }

  /* ================= TOP BAR ================= */

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => Get.back(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Shopping',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New York City',
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 16),
                    ],
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.cartScreen);
              },
              child: const Icon(Icons.shopping_cart, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  /* ================= SEARCH BAR ================= */

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search..",
                    hintStyle: GoogleFonts.montserrat(fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColor.yellowColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ================= CATEGORY ================= */

  Widget _categorySection() {
    return SizedBox(
      height: 90, // important for horizontal ListView
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategoryIndex == index;
          final item = categories[index];

          return GestureDetector(
            onTap: () {
              setState(() => selectedCategoryIndex = index);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.yellowColor
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /* ================= GENDER FILTER ================= */

  Widget _genderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(genders.length, (index) {
          final isSelected = selectedGenderIndex == index;
          final item = genders[index];

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedGenderIndex = index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.yellowColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /* ================= PRODUCT GRID ================= */

  Widget _productGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return _productCard();
        },
      ),
    );
  }

  Widget _productCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.shopDetail);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              Assets.imagesDummyImage,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Women Tshirt',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$100.00',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
