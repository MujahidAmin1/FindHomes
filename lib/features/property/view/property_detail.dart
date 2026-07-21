import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:find_homes/features/property/widgets/detail/agent_contact_card.dart';
import 'package:find_homes/features/property/widgets/detail/property_bottom_bar.dart';
import 'package:find_homes/features/property/widgets/detail/property_header_info.dart';
import 'package:find_homes/features/property/widgets/detail/property_image_carousel.dart';
import 'package:find_homes/features/property/widgets/detail/property_specs_row.dart';
import 'package:flutter/material.dart';

class PropertyDetailScreen extends StatelessWidget {
  final PropertyModel property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyImageCarousel(images: property.images),
            
            PropertyHeaderInfo(property: property),
            
            PropertySpecsRow(property: property),
            
            AgentContactCard(agentId: property.agentId),
            
            // Add some padding at the bottom so content isn't hidden by the bottom bar
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: PropertyBottomBar(property: property),
    );
  }
}
