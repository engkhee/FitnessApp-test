import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'fooditem.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class IngredientsPage extends StatelessWidget {
  final FoodItem foodItem;

  const IngredientsPage(this.foodItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${foodItem.name} Preparation'),
        backgroundColor: AppColors.primaryColor1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const  Text(
                'Ingredients:',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.adminpageColor4, // Change color to match your theme
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.lightGrayColor.withOpacity(0.2), // Add a subtle background color
                  border: Border.all(color: AppColors.lightGrayColor),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '${foodItem.ingredient}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.grayColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Preparation Video:',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.adminpageColor4, // Change color to match your theme
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.lightGrayColor.withOpacity(0.2), // Add a subtle background color
                  border: Border.all(color: AppColors.lightGrayColor),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: YoutubePlayer.convertUrlToId(foodItem.preparvideo) ?? '',
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                      startAt: 0,
                      enableCaption: false,
                      disableDragSeek: false,
                      loop: false,
                      isLive: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

