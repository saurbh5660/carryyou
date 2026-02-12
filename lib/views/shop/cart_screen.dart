import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../generated/assets.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final List<CartItem> cartItems = [
    CartItem(
      name: 'Girl Slim Fit Plain Shirt',
      size: 'L',
      price: 500,
      discount: 130,
      rating: 4.4,
    ),
    CartItem(
      name: 'Women Casual Top',
      size: 'M',
      price: 420,
      discount: 80,
      rating: 4.2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final totalPrice =
    cartItems.fold(0, (sum, item) => sum + item.price);
    final totalDiscount =
    cartItems.fold(0, (sum, item) => sum + item.discount);
    final totalAmount = totalPrice - totalDiscount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cart',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _deliveryAddress(),
                  const SizedBox(height: 16),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _productCard(cartItems[index]),
                  ),

                  const SizedBox(height: 20),
                  _priceDetails(
                    totalPrice: totalPrice,
                    totalDiscount: totalDiscount,
                    totalAmount: totalAmount,
                    itemCount: cartItems.length,
                  ),
                ],
              ),
            ),
          ),
          _placeOrderButton(),
        ],
      ),
    );
  }

  // ================= DELIVERY ADDRESS =================
  Widget _deliveryAddress() {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(color: Colors.black),
              children: const [
                TextSpan(
                    text: 'Deliver to : ',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(
                    text: 'New York City',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 1,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {},
              child: Text(
                'Change',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColor.yellowColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= PRODUCT CARD =================
  Widget _productCard(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              Assets.imagesDummyImage,
              height: 64,
              width: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size : ${item.size}',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                _ratingStars(item.rating),
              ],
            ),
          ),

          /// DELETE BUTTON
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10)
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.delete, size: 18, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ================= STAR RATING =================
  Widget _ratingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round()
              ? Icons.star
              : Icons.star_border,
          size: 14,
          color: Colors.orange,
        );
      }),
    );
  }

  // ================= PRICE DETAILS =================
  Widget _priceDetails({
    required int totalPrice,
    required int totalDiscount,
    required int totalAmount,
    required int itemCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _priceRow('Price ($itemCount items)', '₹$totalPrice'),
          _priceRow('Discount', '- ₹$totalDiscount',
              valueColor: Colors.green),
          const Divider(height: 24),
          _priceRow('Total Amount', '₹$totalAmount', isBold: true),
        ],
      ),
    );
  }

  Widget _priceRow(
      String title,
      String value, {
        bool isBold = false,
        Color? valueColor,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight:
              isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight:
              isBold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ================= PLACE ORDER BUTTON =================
  Widget _placeOrderButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          onPressed: () {},
          child: Text(
            'PLACE ORDER',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= CART ITEM MODEL =================
class CartItem {
  final String name;
  final String size;
  final int price;
  final int discount;
  final double rating;

  CartItem({
    required this.name,
    required this.size,
    required this.price,
    required this.discount,
    required this.rating,
  });
}
