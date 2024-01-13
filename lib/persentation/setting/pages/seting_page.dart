import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/constants/colors.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/persentation/auth/pages/login_page.dart';
import 'package:flutter_pos/persentation/home/bloc/logout/logout_bloc.dart';
import 'package:flutter_pos/persentation/home/bloc/product/product_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                state.maybeMap(
                    orElse: () {},
                    success: (_) async {
                      await ProductLocalDatasource.instance.removeAllProduct();
                      await ProductLocalDatasource.instance
                          .insertAllProducts(_.products.toList());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.primary,
                          content: Text('Successfully sync product'),
                        ),
                      );
                    });
              },
              builder: (context, state) {
                return state.maybeWhen(orElse: () {
                  return ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(const ProductEvent.fetch());
                    },
                    child: const Text('Sync Products'),
                  );
                }, loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                });
              },
            ),
            const Divider(),
            BlocConsumer<LogoutBloc, LogoutState>(
              listener: (context, state) {
                state.maybeMap(
                    orElse: () {},
                    success: (_) {
                      AuthLocalDatasource().removeAuthData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    });
              },
              builder: (context, state) {
                return ElevatedButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    context.read<LogoutBloc>().add(const LogoutEvent.logout());
                  },
                );
              },
            ),
            const Divider(),
          ],
        ));
  }
}
