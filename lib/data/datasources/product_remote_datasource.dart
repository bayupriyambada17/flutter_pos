import 'package:dartz/dartz.dart';
import 'package:flutter_pos/core/constants/variable.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';

import '../models/response/product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/v1/products'),
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }
}
