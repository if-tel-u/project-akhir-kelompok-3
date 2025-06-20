// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jualin/app/routes/app_pages.dart';
import 'package:jualin/app/themes/colors.dart';
import 'package:jualin/utils/currency_formatter.dart';

import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: TextStyle(
            color: AppColors.neutral10,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.neutral10,
            ),
            onPressed: () {
              Get.toNamed(Routes.MY_ACCOUNT);
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchWishlist();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.wishlists.length,
              itemBuilder: (context, index) {
                final item = controller.wishlists[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: wishlistItem(
                    item: item,
                    title: item['name'],
                    price: "Rp${item['price']}",
                    imageUrl: item['image_url'],
                    onTap: () {
                      Get.toNamed(
                        Routes.DETAILED_ITEM,
                        arguments: {'item': item},
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget wishlistItem({
    required Map<String, dynamic> item,
    required String title,
    required String price,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 8),
                    Text(CurrencyFormatter.toRupiah(price),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outlined,
                        color: AppColors.favorite),
                    onPressed: () {
                      controller.toggleWishlist(item);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
