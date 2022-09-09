import 'package:basic_todolist/app/data/services/storage/services.dart';
import 'package:basic_todolist/app/modules/home/binding.dart';
import 'package:basic_todolist/app/modules/home/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo Apps using GetX',
      home: const HomePage(),
      onReady: () => Get.to(() => const HomePage()),
      initialBinding: HomeBinding(),
      builder: EasyLoading.init(),
    );
  }
}
