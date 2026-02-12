import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/assets.dart';

class ReviewRateScreen extends StatelessWidget {
  ReviewRateScreen({super.key});

  /// Rating distribution data
  final List<Map<String, dynamic>> ratingStats = [
    {'stars': 5, 'value': 0.85,},
    {'stars': 4, 'value': 0.60},
    {'stars': 3, 'value': 0.35},
    {'stars': 2, 'value': 0.20},
    {'stars': 1, 'value': 0.10},
  ];

  /// Reviews list
  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Kim Shine',
      'rating': 4,
      'date': 'August 13, 2025',
      'comment':
      'Lorem Ipsum is simply dummy text Lorem Ip sum is simply dummy text.'
    },
    {
      'name': 'Kim Shine',
      'rating': 5,
      'date': 'August 13, 2025',
      'comment':
      'Lorem Ipsum is simply dummy text Lorem Ip sum is simply dummy text.'
    },
    {
      'name': 'Kim Shine',
      'rating': 3,
      'date': 'August 13, 2025',
      'comment':
      'Lorem Ipsum is simply dummy text Lorem Ip sum is simply dummy text.'
    },
    {
      'name': 'Kim Shine',
      'rating': 4,
      'date': 'August 13, 2025',
      'comment':
      'Lorem Ipsum is simply dummy text Lorem Ip sum is simply dummy text.'
    },
    {
      'name': 'Kim Shine',
      'rating': 4,
      'date': 'August 13, 2025',
      'comment':
      'Lorem Ipsum is simply dummy text Lorem Ip sum is simply dummy text.'
    },
    {
      'name': 'Kim Shine',
      'rating': 4,
      'date': 'August 13, 2025',
      'comment':
      'Lorem Ipsum is simply dummy text Lorem Ip sum is simply dummy text.'
    },

    {
      'name': 'Kim Shine',
      'rating': 4,
      'date': 'August 13, 2025',
      'comment':
      'Lorem Ipsum is simply dummy text Lorem Ip sum is simply dummy text.'
    },
    {
      'name': 'Kim Shine',
      'rating': 4,
      'date': 'August 13, 2025',
      'comment':
      'Lorem Ipsum is simply dummy text Lorem Ip sum is simply dummy text.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Review & Rate',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ratingSummary(),
            const SizedBox(height: 20),

            /// Review List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return _reviewItem(reviews[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ⭐ Rating Summary
  Widget _ratingSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Average
        Column(
          children: [
            Text(
              '4.5',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w400,
              ),
            ),
          /*  _starRow(4),
            const SizedBox(height: 4),*/
            Text(
              '23 ratings',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),

        const SizedBox(width: 24),

        /// Distribution
        Expanded(
          child: Column(
            children: ratingStats
                .map((e) => _ratingBar(e['stars'], e['value']))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _ratingBar(int stars, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _starRow1(stars, size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor:
              const AlwaysStoppedAnimation<Color>(Colors.orange),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            stars.toString(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                const AssetImage(Assets.imagesDummyImage),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _starRow(review['rating']),
                  ],
                ),
              ),
              Text(
                review['date'],
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'],
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _starRow(int count, {double size = 14}) {
    return Row(
      children: List.generate(
        5,
            (index) => Icon(
          Icons.star,
          size: size,
          color: index < count ? Colors.orange : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _starRow1(int count, {double size = 14}) {
    return Row(
      children: List.generate(
        count,
            (index) => Icon(
          Icons.star,
          size: size,
          color: Colors.orange,
        ),
      ),
    );
  }
}
