import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elmaleka_kitchen_project/view_model/Favourite/favourite_cubit.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/core/Utils/build_image_error_general.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});
  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavouriteCubit>().fetchFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>context.pop(), icon: Icon(Icons
            .arrow_back_ios,color: Colors.white,size: 5.sw,)),
        title:  Text('المفضلات',style: TextStyle(fontSize: 5.sw,color:
        Colors.white),),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: BlocBuilder<FavouriteCubit, FavouriteState>(
        builder: (context, state) {
          if (state is FavouriteLoading || state is FavouriteInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavouriteError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('حدث خطأ: ${state.message}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<FavouriteCubit>().fetchFavourites(),
                    child: const Text('حاول مرة أخرى'),
                  )
                ],
              ),
            );
          } else if (state is FavouriteLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return Center(child: Text('لا توجد عناصر في المفضلة', style: TextStyle(fontSize: 16)));
            }

            final mq = MediaQuery.of(context);
            final isTablet = mq.size.shortestSide >= 600;
            final crossAxisCount = isTablet ? 3 : 2;

            return Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  final p = items[index];
                  final toggling = state.togglingIds.contains(p.id);
                  return _FavCard(
                    product: p,
                    isToggling: toggling,
                    onToggle: () => context.read<FavouriteCubit>().toggleFavourite(p.id),
                    onTap: () => context.push('/productItem', extra: {'product': p}),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _FavCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final bool isToggling;
  const _FavCard({
    required this.product,
    required this.onToggle,
    required this.onTap,
    this.isToggling = false,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust sizes as you use sw/sh in your app; I used fixed responsive-friendly sizes.
    final titleStyle = const TextStyle(fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 4/3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: buildErrorImageGeneral(item: product, size:18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: titleStyle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${product.price.toString()} جنيه', style: const
                      TextStyle(fontSize: 14)),
                      const Spacer(),
                      InkWell(
                        onTap: onToggle,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.secondaryColor,
                          child: isToggling
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Icon(product.isFavorite == true ? Icons.favorite : Icons.favorite_border, color: Colors.white, size: 18),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
