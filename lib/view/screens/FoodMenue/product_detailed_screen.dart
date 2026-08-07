import 'package:elmaleka_kitchen_project/core/Utils/build_image_error_general.dart';
import 'package:elmaleka_kitchen_project/core/Utils/dummy_products.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/try_again_section.dart';
import 'package:elmaleka_kitchen_project/view/screens/Home/Home%20Widgets/food_category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/Utils/is_tablet_service.dart';
import '../../../core/theme/colors.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/review_model.dart';
import '../../../view_model/Favourite/favourite_cubit.dart';
import '../../../view_model/Product Details/product_details_cubit.dart';
import '../../../view_model/Review/review_cubit.dart';
import '../../../view_model/Review/review_state.dart';
import '../../Widgets/rating_stars.dart';
import 'Food Menue Widgets/description_section.dart';
import 'Food Menue Widgets/favourite_button.dart';
import 'Food Menue Widgets/product_bottom_area.dart';
import 'Food Menue Widgets/product_header.dart';
import 'Food Menue Widgets/product_header_icon.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int qty = 1;
  SizeModel? selectedSize;
  List<AddonDetail> selectedAddons = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  void _loadProductDetails() async {
    context.read<ProductDetailsCubit>().fetchProduct(widget.product.id);
    context.read<ReviewCubit>().fetchReviews(widget.product.id);
  }

  void increment() => setState(() => qty++);
  void decrement() => setState(() {
        if (qty >= 1) qty--;
      });

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    // fonts & sizes (using your .sw / .sh usage)
    final double titleFont = tablet ? 6.sw : 5.sw;
    final double smallFont = 4.sw;
    final double priceFont = tablet ? 8.sw : 7.sw;
    final double imageAreaHeight = tablet ? 40.sh : 38.sh;

    // bottom card sizes
    final double cardHeight = tablet ? 20.sh : 18.sh;
    final double redWidth = tablet ? 28.sw : 30.sw;
    final double circleSize = 12.sw;
    final double sidePadding = 6.sw;

    return Scaffold(
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return Skeletonizer(
              enabled: true,
              child: SingleChildScrollView(
                child: FoodCategoryList(
                    itemsFamous: getDummyProducts(5), isVertical: true),
              ));
        } else if (state is ProductDetailsLoaded) {
          final productDetails = state.product;
          final product = productDetails.product;
          final productPrice = product.price;
          final productName = product.name;
          final productRating = product.ratingAverage;
          final reviewsCount = product.ratingCount;
          final description = product.description;
          final categoryName = product.category.name;
          return Stack(
            children: [
              // Top image area
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: imageAreaHeight,
                child:buildErrorImageGeneral(item: widget.product,
                    size:18.sw)
              ),

              // Top icons row
              Positioned(
                top: 5.sh,
                left: 3.sw,
                right: 3.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: HeaderIcon(icon: Icons.arrow_back_ios_new),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/cart'),
                      child: HeaderIcon(icon: Icons.shopping_cart_outlined),
                    ),
                  ],
                ),
              ),

              // Main scrollable content (placed under the overlay card)
              Positioned(
                top: imageAreaHeight - (imageAreaHeight * 0.3),
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.sw),
                          topLeft: Radius.circular(10.sw))),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(right: 3.sw, top: 1.sh),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // push content a bit to match overlay card
                        SizedBox(height: imageAreaHeight * 0.05),
                        BlocBuilder<ReviewCubit, ReviewState>(
                            builder: (context, state) {
                          if (state is ReviewLoaded) {
                            return ProductHeader(
                              productName: productName,
                              titleFont: titleFont,
                              productRating: productRating,
                              reviewsCount: reviewsCount,
                              smallFont: smallFont,
                              productPrice: productPrice,
                              priceFont: priceFont,
                              summary: state.summary,
                              categoryName: categoryName,
                            );
                          } else if (state is ReviewError) {
                            return TryAgainSection(
                              message: state.message,
                              method: () => context
                                  .read<ReviewCubit>()
                                  .fetchReviews(widget.product.id),
                            );
                          } else if (state is ReviewLoading) {
                            return Skeletonizer(
                              enabled: true,
                              justifyMultiLineText: true,
                              child: Text('Reviews Hereeeeeeeeeeee'),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                        SizedBox(height: 2.sh),
                        // Description
                        DescriptionSection(description: description),
                        SizedBox(height: 4.sh),
                        // Options
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.sw),
                          child: Column(
                            children: [
                              _optionRow(selectedSize?.name ?? 'حدد حجم الجزء',
                                  () async {
                                final result =
                                    await showModalBottomSheet<SizeModel>(
                                  context: context,
                                  builder: (_) => _SizePickSheet(
                                    title: 'حدد حجم الجزء',
                                    options: productDetails.sizes,
                                    selected: selectedSize,
                                  ),
                                );
                                if (result != null) {
                                  setState(() => selectedSize = result);
                                }
                              }),
                              SizedBox(height: 2.sh),
                              _optionRow(
                                  selectedAddons
                                          .map((e) => e.name)
                                          .toList()
                                          .isNotEmpty
                                      ? selectedAddons
                                          .map((e) => e.name)
                                          .join(', ')
                                      : 'حدد المحتويات', () async {
                                final result = await showModalBottomSheet<
                                    List<AddonDetail>>(
                                  context: context,
                                  builder: (_) => _AddonPickSheet(
                                    title: 'حدد المحتويات',
                                    options: productDetails.addons,
                                    selected: selectedAddons,
                                  ),
                                );
                                if (result != null) {
                                  setState(() => selectedAddons = result);
                                }
                              }),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.sh),

                        // Quantity
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.sw),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('عدد القطع',
                                  style: TextStyle(
                                      fontSize: smallFont,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  QuantityButton(
                                      isPlus: false,
                                      method: decrement,
                                      smallFont: smallFont),
                                  SizedBox(width: smallFont),
                                  Container(
                                    width: 12.sw,
                                    height: 7.sw,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(smallFont),
                                      border: Border.all(
                                          color: AppColors.secondaryColor),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text('$qty',
                                          style: TextStyle(
                                              fontSize: smallFont,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  SizedBox(width: smallFont),
                                  QuantityButton(
                                      isPlus: true,
                                      method: increment,
                                      smallFont: smallFont),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 5.sh),
                        // Bottom sticky area: red + white card + circular cart
                        BottomProductArea(
                          sidePadding: sidePadding,
                          cardHeight: cardHeight,
                          redWidth: redWidth,
                          circleSize: circleSize,
                          productPrice: productPrice,
                          qty: qty,
                          selectedSize: selectedSize,
                          selectedAddons: selectedAddons,
                          product: product,
                          sizePrice: selectedSize?.price ?? 0,
                          addonsPrice: selectedAddons.fold(
                              0.0, (sum, addon) => sum + addon.price),
                        ),
                        SizedBox(height: 2.sh),

                        // REVIEW SECTION
                        BlocBuilder<ReviewCubit, ReviewState>(
                          builder: (context, reviewState) {
                            if (reviewState is ReviewLoading) {
                              return Skeletonizer(
                                enabled: true,
                                justifyMultiLineText: true,
                                child: Text('Reviews Hereeeeeeeeeeee'),
                              );
                            } else if (reviewState is ReviewLoaded) {
                              final summary = reviewState.summary;
                              final me = reviewState.myReview;
                              final reviewsResp = reviewState.productReviews;

                              final ReviewView? myReviewView = me != null
                                  ? ReviewView.fromMeReview(me, myName: 'أنت')
                                  : null;

                              final List<ReviewView> reviewsList = reviewsResp
                                  .items
                                  .where((r) =>
                                      me == null || r.user.id != me.userId)
                                  .map((r) => ReviewView.fromReviewModel(r))
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildReviewHeader(summary),
                                  SizedBox(height: 2.sh),
                                  _buildMyReviewSection(
                                      context, myReviewView, widget.product.id),
                                  // SizedBox(height: 2.sh),
                                  _buildProductReviews(reviewsList, context,
                                      widget.product.id, reviewsResp),
                                ],
                              );
                            } else if (reviewState is ReviewError) {
                              return TryAgainSection(
                                message:
                                    'خطأ في تحميل المراجعات: ${reviewState.message}',
                                method: () => context
                                    .read<ReviewCubit>()
                                    .fetchReviews(widget.product.id),
                              );
                            }
                            return const SizedBox();
                          },
                        ),

                        SizedBox(
                          height: 2.sh,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Floating favourite button (circular)
              // Positioned(
              //   top: imageAreaHeight - (imageAreaHeight * 0.4),
              //   left: 6.sw,
              //   child: InkWell(
              //     onTap: () => setState(() => isFavorite = !isFavorite),
              //     child: FavouriteButton(isFavorite: isFavorite),
              //   ),
              // ),
              Positioned(
                top: imageAreaHeight - (imageAreaHeight * 0.4),
                left: 6.sw,
                child: BlocBuilder<FavouriteCubit, FavouriteState>(
                  builder: (context, favState) {
                    final toggling = favState is FavouriteLoaded && favState.togglingIds.contains(widget.product.id);
                    final favValue = widget.product.isFavorite ?? isFavorite;
                    return InkWell(
                      onTap: () async {
                        // instant local feedback
                        setState(() => isFavorite = !isFavorite);
                        try {
                          await context.read<FavouriteCubit>().toggleFromDetails(widget.product);
                          // optionally refresh product details or other UI after server response
                        } catch (e) {
                          // revert in case of error
                          setState(() => isFavorite = !isFavorite);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('فشل تحديث المفضلة')),
                          );
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FavouriteButton(isFavorite: favValue),
                          if (toggling)
                            const SizedBox(width: 44, height: 44, child: CircularProgressIndicator(strokeWidth: 2)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is ProductDetailsError) {
          return TryAgainSection(
              message: state.msg, method: () => _loadProductDetails());
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  Widget _optionRow(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 2.sh),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2.sw),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(text,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 4.sw))),
            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 6.sw),
          ],
        ),
      ),
    );
  }
// Add these widget methods inside your _ProductDetailScreenState class

  Widget _buildReviewHeader(ReviewSummary? summary) {
    if (summary == null) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقييمات المنتج',
            style: TextStyle(fontSize: 5.sw, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMyReviewSection(
      BuildContext context, ReviewView? myReview, int productId) {
    if (myReview != null) {
      return _buildReviewCard(
        myReview,
        isMyReview: true,
        onEdit: () => _showReviewDialog(
          context,
          productId,
          currentReview: myReview,
        ),
        onDelete: () => context.read<ReviewCubit>().deleteReview(myReview.id),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.sw),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _showReviewDialog(context, productId),
          child: Text('أضف تقييمك',style: TextStyle(fontSize: 4.sw),),
        ),
      );
    }
  }

  Widget _buildProductReviews(List<ReviewView> reviews, BuildContext context,
      int productId, ReviewResponse resp) {
    return Column(
      children: [
        ...reviews.map((review) {
          return _buildReviewCard(review, isMyReview: review.isMine);
        }).toList(),
        if (resp.page * resp.limit < resp.total)
          TextButton(
            onPressed: () => context.read<ReviewCubit>().loadMoreReviews(),
            child: Text('تحميل المزيد'),
          )
      ],
    );
  }

  Widget _buildReviewCard(ReviewView review,
      {bool isMyReview = false, VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Card(
      color: Colors.grey.shade100,
      margin: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 1.sh),
      child: Padding(
        padding: EdgeInsets.all(4.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(review.authorName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 4.sw)),
                if (isMyReview)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 6.sw),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 6.sw),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
              ],
            ),
            RatingStars(
              rating: review.rating.toDouble(),
              size: 5.sw,
            ),
            Text(
              review.comment,
              style: TextStyle(fontSize: 4.sw),
            ),
            Row(
              children: [
                Spacer(),
                Text(
                  '${review.createdAt.day}-${review.createdAt.month}-${review.createdAt.year}',
                  style: TextStyle(color: Colors.grey, fontSize: 3.5.sw),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, int productId,
      {ReviewView? currentReview}) {
    final TextEditingController commentController =
        TextEditingController(text: currentReview?.comment);
    double rating = currentReview?.rating.toDouble() ?? 5.0;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            currentReview == null ? 'أضف تقييمك' : 'تعديل التقييم',
            style: TextStyle(fontSize: 5.sw),
          ),
          content: SizedBox(
            width: 70.sw,
            height: 20.sh,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(builder: (ctx, setState) {
                  return RatingStars(
                    rating: rating,
                    size: 4.sw,
                    onRatingUpdate: (newRating) =>
                        setState(() => rating = newRating),
                  );
                }),
                SizedBox(height: 2.sh),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(hintText: "اكتب تعليقك هنا",
                      hintStyle: TextStyle(fontSize: 4.sw)),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(color: AppColors.secondaryColor,fontSize: 3
                    .sw),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (currentReview != null) {
                  // Update review
                  final body = UpdateReviewBody(
                      rating: rating.toInt(), comment: commentController.text);
                  context
                      .read<ReviewCubit>()
                      .updateReview(currentReview.id, body);
                } else {
                  // Add new review
                  final body = AddReviewBody(
                      productId: productId,
                      rating: rating.toInt(),
                      comment: commentController.text);
                  context.read<ReviewCubit>().addReview(body);
                }
                Navigator.of(ctx).pop();
              },
              child: Text(
                'حفظ',
                style: TextStyle(color: AppColors.secondaryColor,fontSize: 3
                    .sw),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SizePickSheet extends StatelessWidget {
  final String title;
  final List<SizeModel> options;
  final SizeModel? selected;

  const _SizePickSheet(
      {required this.title, required this.options, this.selected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            style: TextStyle(fontSize: 5.sw, fontWeight: FontWeight.bold)),
        SizedBox(height: 2.sh),
        ...options
            .map((o) => ListTile(
                  title: Text(o.name, textAlign: TextAlign.right,style: TextStyle(fontSize: 3.sw),),
                  subtitle:
                      Text(o.price.toString(), textAlign: TextAlign.right,style: TextStyle(fontSize: 3.sw),),
                  trailing: o.id == selected?.id ? Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop(o),
                ))
            .toList(),
      ],
    );
  }
}

class _AddonPickSheet extends StatelessWidget {
  final String title;
  final List<AddonDetail> options;
  final List<AddonDetail> selected;

  const _AddonPickSheet(
      {required this.title, required this.options, required this.selected});

  @override
  Widget build(BuildContext context) {
    // This sheet needs to be stateful to handle multiple selections
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: TextStyle(fontSize: 5.sw, fontWeight: FontWeight.bold)),
            SizedBox(height: 2.sh),
            ...options.map((o) {
              final isSelected = selected.any((e) => e.id == o.id);
              return CheckboxListTile(

                activeColor: AppColors.secondaryColor,
                title: Text(o.name, textAlign: TextAlign.right,style: TextStyle(fontSize: 3.sw),),
                subtitle: Text('${o.price.toString()} جنيه', textAlign:
                TextAlign.right,style: TextStyle(fontSize: 3.sw),),
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selected.add(o);
                    } else {
                      selected.removeWhere((e) => e.id == o.id);
                    }
                  });
                },
              );
            }).toList(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor),
              onPressed: () => Navigator.of(context).pop(selected),
              child: Text(
                'تم',
                style: TextStyle(fontSize: 3.5.sw,color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class QuantityButton extends StatelessWidget {
  const QuantityButton(
      {super.key,
      required this.isPlus,
      required this.method,
      required this.smallFont});
  final bool isPlus;
  final double smallFont;
  final VoidCallback method;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: method,
      child: Container(
        width: 12.sw,
        height: 7.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(smallFont),
          color: AppColors.secondaryColor,
        ),
        child: Center(
            child: Icon(isPlus ? Icons.add : Icons.remove,
                color: Colors.white, size: 5.sw)),
      ),
    );
  }
}
