import 'package:elmaleka_kitchen_project/core/Utils/dummy_products.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/search_bar.dart';
import 'package:elmaleka_kitchen_project/view/screens/Home/Home%20Widgets/new_food_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:elmaleka_kitchen_project/data/datasources/products_remote_datasource.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../view_model/Home/Search/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) {
        final ProductsDataSource dataSource = GetIt.instance<ProductsDataSource>();
        final searchFunction = (String query) async {
          final futures = await Future.wait([
            dataSource.getProducts(categoryId: 1),
            dataSource.getProducts(categoryId: 2),
            dataSource.getProducts(categoryId: 3),
          ]);
          final List<ProductModel> allProducts = [...futures[0], ...futures[1], ...futures[2]];
          return allProducts.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
        };
        final cubit=  SearchCubit(searchFunction);
        cubit.loadRecentSearches();
         return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomSearchBar(controller: _controller),
          actions: [
            IconButton(
              icon: Icon(Icons.clear, size: 6.sw),
              onPressed: () {
                _controller.clear();
                context.read<SearchCubit>().queryChanged('');
              },
            )
          ],
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoadInProgress) {
              return SingleChildScrollView(
                child: Skeletonizer(enabled: true, child: TodayDishSection(itemsFamous: getDummyProducts(5))),
              );
            }
            if (state is SearchLoadFailure) {
              return Center(child: Text('خطأ: ${state.error}',style: TextStyle(fontSize: 4.sw),));
            }
            if (state is SearchLoadSuccess) {
              final results = state.results;
              if (results.isEmpty) {
                return Center(child: Text('لا توجد نتائج',style: TextStyle(fontSize: 4.sw),));
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: results.length,
                separatorBuilder: (_, __) => Divider(height: 1, color:
                Colors.grey.shade300,),
                itemBuilder: (ctx, i) {
                  final item = results[i];
                  return ListTile(
                    title: Text(item.name,style: TextStyle(fontSize: 4.sw),),
                    onTap: () {
                      context.read<SearchCubit>().saveSearchQuery(item.name);
                      context.push('/productItem', extra: {'product': item});
                    },
                  );
                },
              );
            }
            if (state is SearchHistoryLoaded) {
              final history = state.history;
              if (history.isEmpty) {
                return  Center(child: Text('ابدأ بالبحث',style: TextStyle(fontSize: 4.sw),));
              }
              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (ctx, i) {
                  final query = history[i];
                  return ListTile(
                    leading: Icon(Icons.history,size: 5.sw,),
                    title: Text(query,style: TextStyle(fontSize: 3.5.sw),),
                    onTap: () {
                      _controller.text = query;
                      context.read<SearchCubit>().queryChanged(query);
                    },
                  );
                },
              );
            }
            // Default initial state
            return Center(child: Text('ابدأ بالبحث',style: TextStyle
              (fontSize: 4.sw)
              ,));
          },
        ),
      ),
    );
  }
}
