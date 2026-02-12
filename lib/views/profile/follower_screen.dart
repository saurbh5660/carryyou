import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowersScreen extends StatelessWidget {
  FollowersScreen({super.key});

  final List<Follower> followers = [
    Follower(name: 'Angel', image: 'https://i.pravatar.cc/150?img=1'),
    Follower(name: 'Katy', image: 'https://i.pravatar.cc/150?img=2'),
    Follower(name: 'Sweetie', image: 'https://i.pravatar.cc/150?img=3'),
    Follower(name: 'Bubbly', image: 'https://i.pravatar.cc/150?img=4'),
    Follower(name: 'Honey', image: 'https://i.pravatar.cc/150?img=5'),
    Follower(name: 'Katy', image: 'https://i.pravatar.cc/150?img=6'),
    Follower(name: 'Bubbly', image: 'https://i.pravatar.cc/150?img=7'),
    Follower(name: 'Bubbly', image: 'https://i.pravatar.cc/150?img=7'),
    Follower(name: 'Bubbly', image: 'https://i.pravatar.cc/150?img=7'),
    Follower(name: 'Bubbly', image: 'https://i.pravatar.cc/150?img=7'),
    Follower(name: 'Bubbly', image: 'https://i.pravatar.cc/150?img=7'),
    Follower(name: 'Bubbly', image: 'https://i.pravatar.cc/150?img=7'),
    Follower(name: 'Bubbly', image: 'https://i.pravatar.cc/150?img=7'),
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
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Followers',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: followers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return _followerTile(followers[index]);
        },
      ),
    );
  }

  /// ================= FOLLOWER ITEM =================
  Widget _followerTile(Follower follower) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(follower.image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              follower.name,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _unfollowButton(),
        ],
      ),
    );
  }

  /// ================= UNFOLLOW BUTTON =================
  Widget _unfollowButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Unfollow',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

/// ================= MODEL =================
class Follower {
  final String name;
  final String image;

  Follower({
    required this.name,
    required this.image,
  });
}
