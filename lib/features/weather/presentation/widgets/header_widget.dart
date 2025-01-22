import 'package:flutter/material.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';

class HeaderWidget extends StatelessWidget {
  final String currentStreet;
  final String currentAddress;
  final Function(BuildContext) onShowBottomSheet;

  const HeaderWidget({
    super.key,
    required this.currentStreet,
    required this.currentAddress,
    required this.onShowBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.my_location_rounded,
              color: AppPalette.onBackgroundColor(context), size: 44),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentStreet,
                  style: TextStyle(
                    color: AppPalette.backgroundColor(context),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentAddress,
                  style: TextStyle(
                      color: AppPalette.onBackgroundColor(context),
                      fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppPalette.onBackgroundColor(context), width: 1),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () => onShowBottomSheet(context),
              child: CircleAvatar(
                backgroundColor: AppPalette.backgroundColor(context).withOpacity(0.2),
                child: Icon(Icons.person,
                    color: AppPalette.backgroundColor(context)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
