import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_remote_datasource.dart';
import 'package:flutter_pos/data/models/response/product_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(this._productRemoteDatasource) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      final response = await _productRemoteDatasource.getProducts();
      response.fold(
        (l) => emit(ProductState.error(l)),
        (r) {
          products = r.data;
          emit(ProductState.success(r.data));
        },
      );
    });
    on<_FetchLocal>((event, emit) async {
      emit(const _Loading());
      final localProduct =
          await ProductLocalDatasource.instance.getAllProduct();
      products = localProduct;
      emit(ProductState.success(localProduct));
    });
    on<_FetchByCategory>((event, emit) async {
      emit(const _Loading());
      final newProducts = event.category == 'all'
          ? products
          : products
              .where((element) => element.category == event.category)
              .toList();
      emit(ProductState.success(newProducts));
    });
  }
}
