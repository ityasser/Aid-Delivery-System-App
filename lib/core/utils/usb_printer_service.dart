import 'dart:convert';
import 'dart:ffi';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:aid_registry_flutter_app/core/theme/founts.dart';
import 'package:aid_registry_flutter_app/core/utils/user_preference.dart';
import 'package:aid_registry_flutter_app/data/person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:usb_serial/usb_serial.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import '../../data/project.dart';
import '../app.dart';
import 'helpers.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';


class AidItem {
  final String type;
  final String executor;

  AidItem(this.type, this.executor);
}



class USBPrinterService with Helpers {



  static void  drawAidTable(Canvas canvas, double width, double startY, Person person,List<Project> projects) {
    const double rowHeight = 35;
    const double fontSize = 20;


    double center=(width/2);

    // عنوان الأعمدة
    final lable_type = TextPainter(
      text: TextSpan(
        text: "نوع الطرد",
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    // lable_type.paint(canvas, Offset((center+(center-lable_type.width)/2), startY));


    final lable_doner = TextPainter(
      text: TextSpan(
        text: "تنفيذ",
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();


    // lable_doner.paint(canvas, Offset(((center-lable_doner.width)/2), startY));

  /*  for (int i = 0; i < headers.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: headers[i],
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: Founts.arabic,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout(maxWidth: (i == 0) ? col1Width : col2Width);

      double dx = (i == 0) ? width - col1Width : width - col1Width - col2Width;
      textPainter.paint(canvas, Offset(dx + 10, startY));
    }

   */


    double spaceBetween = 20; // المسافة بين العنصرين في نفس السطر

    startY=startY+15;
    // رسم الصفوف
    for (int i = 0; i < projects.length; i += 2) {
      double y = startY + (i + 1) * (rowHeight/2);
     final lable_type = TextPainter(
       text: TextSpan(
         text: '${projects[i].aids_name} - ${projects[i].donation_name}',
         // text: '${projects[i].type} - ${projects[i].executor}',
         style: TextStyle(
           fontSize: 25,
           fontFamily: Founts.arabic,
           // fontWeight: FontWeight.bold,
           color: Colors.black,
           height: 1
         ),
       ),
       textDirection: TextDirection.rtl,
     )..layout();

     if(projects.length>1)
     lable_type.paint(canvas, Offset((center+(center-lable_type.width)/2), y));
     else
       lable_type.paint(canvas, Offset(((width-lable_type.width)/2), y));

      if (i + 1 < projects.length) {
        final lable_doner = TextPainter(
          text: TextSpan(
            // text: '${projects[i+1].type} - ${projects[i+1].executor}',
            text: '${projects[i+1].aids_name} - ${projects[i+1].donation_name}',
            style: TextStyle(
                fontSize: 25,
                fontFamily: Founts.arabic,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1
            ),
          ),
          textDirection: TextDirection.rtl,
        )
          ..layout();


        lable_doner.paint(
            canvas, Offset(((center - lable_doner.width) / 2), y));


        final line = TextPainter(
          text: TextSpan(
            text: '|',
            style: TextStyle(
                fontSize: 25,
                fontFamily: Founts.arabic,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1
            ),
          ),
          textDirection: TextDirection.rtl,
        )
          ..layout();


        line.paint(
            canvas, Offset(((center ) ), y));



      }
      }


  /*  for (int i = 0; i < items.length; i++) {
      double y = startY + (i + 1) * rowHeight;

      final cells = [items[i].type, items[i].executor];

      for (int j = 0; j < cells.length; j++) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: cells[j],
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: Founts.arabic,
              color: Colors.black,
            ),
          ),
          textDirection: TextDirection.rtl,
        )..layout();

        double dx = (j == 0) ? width - col1Width : width - col1Width - col2Width;
        textPainter.paint(canvas, Offset((dx + 10), y));
      }
    }*/
  }


  static String buildRow(List<String> items, int columnWidth) {
    return items
        .map((item) => item.padRight(columnWidth))
        .join('|');
  }
  static Future<Uint8List> generateArabicImage(Person person, List<Project> projects) async{

    print("generateArabicImage: ${projects}");
    List<AidItem> aidItemsx = [
      AidItem('طرد غذائية', 'الهلال الأحمر'),
      AidItem('طرد غذائية', 'الهلال الأحمر'),
      AidItem('طرد صحي', 'انيرة'),
      AidItem('خضار', 'انقاذ الشبابي'),
       AidItem('حرامات', 'مجموعة غزة'),
    ];

    const double width = 550;
    double height = 150+((projects.length/2).ceil()*35);


    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));



    final title = TextPainter(
      text: TextSpan(
        text: 'وزارة التنمية الاجتماعية - ${projects.first.storesName} - ${UserPreferences().getUser().email?.split('@')[0]}',
            // '${UserPreferences().getUser().store_name}',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
          fontWeight: FontWeight.bold,
          height: 1.5
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    title.paint(canvas, Offset((width-title.width)/2, 0));



    final label_store = TextPainter(
      text: TextSpan(
        text: 'المخزن:',
        style: TextStyle(

          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
          fontWeight: FontWeight.bold,
            height: 1.5
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    // label_store.paint(canvas, Offset(width-100, title.height+1));
/*
    label_store.paint(canvas, Offset(width - label_store.width - 1, title.height+1));

    String nameStrote="النادي الأهلي";
    final name_store = TextPainter(
      text: TextSpan(
        text: '$nameStrote',
        style: TextStyle(

          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
            height: 1.5
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();
        name_store.paint(canvas, Offset(width -name_store.width-90,  title.height+1));

*/

    final dateNow = TextPainter(
      text: TextSpan(
        text: person.receivedTime??'${DateFormat('HH:mm dd-MM-yy').format(DateTime.now())}',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
            height: 1.5
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    dateNow.paint(canvas, Offset(0,  title.height+1));

    final id_user = TextPainter(
      text: TextSpan(

        text:  person.person_pid,
        style: TextStyle(
            fontSize: 25,
            fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
            color: Colors.black,

            height: 1.5
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();
    id_user.paint(canvas, Offset((width-id_user.width)/2,  title.height+1));


   /* final id_user_label = TextPainter(
      text: TextSpan(
        text: 'رقم الهوية:',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          height: 1.5
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();
        id_user_label.paint(canvas, Offset( id_user.width+5, name_store.height+title.height+1));

*/




   /* final name_user_label = TextPainter(
      text: TextSpan(
        text: 'الاسم:',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
          fontWeight: FontWeight.bold,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    name_user_label.paint(canvas, Offset(width - name_user_label.width - 1, label_store.height+title.height+1));
*/
    final name_user = TextPainter(
      text: TextSpan(
        text: person.fullName,
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    name_user.paint(canvas, Offset((width-name_user.width)/2,  name_user.height+title.height+1));


    final dash = TextPainter(
      text: TextSpan(
        text: "- "*40,
        style: TextStyle(
            fontSize: 25,
            fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
            color: Colors.black,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    dash.paint(canvas, Offset(0, label_store.height+ name_user.height+title.height-5));


/*
    final code_label = TextPainter(
      text: TextSpan(
        text: 'كود الدورة:',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
          fontWeight: FontWeight.bold,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    code_label.paint(canvas, Offset(width - code_label.width - 1,name_user_label.height+id_user_label.height+ name_store.height+title.height+1));

    final code = TextPainter(
      text: TextSpan(
        text: 'RDF5253',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    code .paint(canvas, Offset(width -code.width-105,  name_user.height+id_user.height+label_store.height+title.height+1));
*/
    drawAidTable(canvas, width, /*code_label.height+*/
        name_user.height+title.height+35, person,projects);


/*
    final type_aid_label = TextPainter(
      text: TextSpan(
        text: 'نوع الطرد:',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
          fontWeight: FontWeight.bold,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    type_aid_label.paint(canvas, Offset(width - type_aid_label.width - 1,code_label.height+name_user_label.height+id_user_label.height+ name_store.height+title.height+1));

    final type_aid = TextPainter(
      text: TextSpan(
       text: '${buildRow(['طرد غذائي','طرد صحي','خضار'],12)}',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    type_aid .paint(canvas, Offset(width -type_aid.width-105,  code.height+name_user.height+id_user.height+label_store.height+title.height+1));


    final donor_label = TextPainter(
      text: TextSpan(
        text: 'تنفيذ:',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
          fontWeight: FontWeight.bold,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    donor_label.paint(canvas, Offset(width - donor_label.width - 1,type_aid_label.height+code_label.height+name_user_label.height+id_user_label.height+ name_store.height+title.height+1));


    final donor = TextPainter(
      text: TextSpan(
        text: '${buildRow(['الهلال الاحمر','مؤسسة انيرة','مجموعة غزة'],12)}',
        style: TextStyle(
          fontSize: 25,
          fontFamily: Founts.arabic, // استبدلها بخط يدعم العربية إن وجد
          color: Colors.black,
            height: 1.5

        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    donor .paint(canvas, Offset(width -donor.width-105,  code.height+type_aid.height+name_user.height+id_user.height+label_store.height+title.height+1));


*/

    final picture = recorder.endRecording();
    final double scale = 3.0; // جودة أعلى ×3

    final imgc = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await imgc.toByteData(format: ui.ImageByteFormat.png);


    return byteData!.buffer.asUint8List();
  }
  Future<List<int>> generateArabicReceipt(Person person,List<Project> projects) async {

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile, spaceBetweenRows: 0,);
    List<int> bytes = [];


    var pngBytes = await generateArabicImage(person, projects);
    bytes += generator.feed(0);      // بدون سطر إضافي
    bytes += generator.reset();      // إعادة التنسيق الافتراضي
    bytes += generator.hr();         // خط فاصل بدون فراغ


      bytes +=  generator.image(img.decodeImage(pngBytes)!);

    // List<int> arabicTextBytes = await CharsetConverter.encode("ISO-8859-6", "فاتورة المبيعات");
    //
    // bytes += generator.rawBytes(arabicTextBytes); // طباعة النص العربي بالترميز المدعوم
    // إعداد نص الفاتورة
    // Uint8List uint8List = Uint8List.fromList(utf8.encode('فاتورة المبيعات'));
    //
    // bytes += generator.textEncoded(uint8List,
    //     styles: PosStyles(
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //       align: PosAlign.center,
    //     ));



    // bytes += generator.text('شاي           2        10.00');
    // bytes += generator.text('سكر           1         5.00');
    bytes += generator.hr(); // خط فاصل

    // bytes += generator.text('الإجمالي:            25.00', styles: PosStyles(align: PosAlign.right));

    bytes += generator.feed(0); // مسافة فارغة قبل القص
    bytes += generator.cut(); // قص الورقة

    return bytes;
  }

  void listAllPrinters() {
    final bufferSize = 4096; // حجم البفر
    final buffer = calloc<Uint8>(bufferSize);
    final needed = calloc<Uint32>();
    final returned = calloc<Uint32>();

    // جلب قائمة الطابعات
    final result = EnumPrinters(
        PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS |PRINTER_ENUM_NETWORK, // يجلب جميع الطابعات
        nullptr,
        2, // استخدام المستوى 2 للحصول على معلومات إضافية
        buffer,
        bufferSize,
        needed,
        returned);

    if (result != 0) {
      final count = returned.value ~/ sizeOf<PRINTER_INFO_2>();
      final printers = buffer.cast<PRINTER_INFO_2>();

      print("تم العثور على ${count} طابعة:");

      for (var i = 0; i < count; i++) {
        final printerName = printers[i].pPrinterName.toDartString();
        final status = printers[i].Status;

        String statusText;
        if (status == 0) {
          statusText = "متصلة وجاهزة ✅";
        } else if (status  != 0) {
          statusText = "غير متصلة ❌";
        } else {
          statusText = "في حالة غير معروفة ⚠️";
        }

        print('- $printerName [$statusText]');
      }
    } else {
      print("لم يتم العثور على أي طابعة.");
    }

    free(buffer);
    free(needed);
    free(returned);
  }


  void listPrinters() {
    listAllPrinters();
    final bufferSize = 4096;

    final needed = calloc<Uint32>();
    final buffer = calloc<Uint8>(bufferSize);
    final result = EnumPrinters(
        PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS | PRINTER_ENUM_NETWORK, nullptr, 2, buffer, bufferSize, needed, nullptr);

    if (result != 0) {
      final count = needed.value ~/ sizeOf<PRINTER_INFO_2>();
      final printers = buffer.cast<PRINTER_INFO_2>();

      for (var i = 0; i < count; i++) {
        final printerName = printers[i].pPrinterName.toDartString();
        print('تم العثور على الطابعة: $printerName');
      }
    } else {
      print('لم يتم العثور على أي طابعة.');
    }

    free(buffer);
    free(needed);
  }
  List<String> getAllPrinters() {
    final bufferSize = calloc<DWORD>();
    EnumPrinters(PRINTER_ENUM_LOCAL, nullptr, 2, nullptr, 0, bufferSize, nullptr);

    final buffer = calloc<Uint8>(bufferSize.value);
    final printerInfo = buffer.cast<PRINTER_INFO_2>();

    EnumPrinters(PRINTER_ENUM_LOCAL, nullptr, 2, buffer, bufferSize.value, bufferSize, nullptr);

    List<String> printers = [];
    for (int i = 0; i < bufferSize.value ~/ sizeOf<PRINTER_INFO_2>(); i++) {
      printers.add(printerInfo[i].pPrinterName.toDartString());
    }

    calloc.free(buffer);
    calloc.free(bufferSize);

    return printers;
  }
  String getDefaultPrinter() {
    final bufferSize = calloc<DWORD>();
    GetDefaultPrinter(nullptr, bufferSize); // Get required size

    final buffer = calloc<Uint16>(bufferSize.value).cast<Utf16>(); // Correct allocation
    if (GetDefaultPrinter(buffer, bufferSize) != 0) {
      return buffer.toDartString(); // Convert to Dart String
    }

    calloc.free(buffer);
    calloc.free(bufferSize);
    return "No default printer found";
  }




  showMessagec(String message){
    print(message);
  }
  void printToUSBPrinter(String printerName, Uint8List data) {
    final printerHandle = calloc<HANDLE>();
    final docInfo = calloc<DOC_INFO_1>()
      ..ref.pDocName = 'فاتورة مبيعات'.toNativeUtf16()
      ..ref.pOutputFile = nullptr
      ..ref.pDatatype = 'RAW'.toNativeUtf16();

    // فتح الطابعة
    if (OpenPrinter(printerName.toNativeUtf16(), printerHandle, nullptr) == 0) {
      print('❌ فشل فتح الطابعة');
      return;
    }

    // بدء الطباعة
    if (StartDocPrinter(printerHandle.value, 1, docInfo.cast()) == 0) {
      print('❌ فشل بدء الطباعة');
      ClosePrinter(printerHandle.value);
      return;
    }

    if (StartPagePrinter(printerHandle.value) == 0) {
      print('❌ فشل بدء صفحة الطباعة');
      EndDocPrinter(printerHandle.value);
      ClosePrinter(printerHandle.value);
      return;
    }

    // إرسال البيانات للطابعة
    final written = calloc<DWORD>();
    final Pointer<Uint8> dataPointer = malloc.allocate<Uint8>(data.length);
    dataPointer.asTypedList(data.length).setAll(0, data);

    if (WritePrinter(printerHandle.value, dataPointer.cast(), data.length, written) == 0) {
      print('❌ فشل إرسال البيانات إلى الطابعة');
    }

    malloc.free(dataPointer);

    // إنهاء الطباعة
    EndPagePrinter(printerHandle.value);
    EndDocPrinter(printerHandle.value);
    ClosePrinter(printerHandle.value);

    showMessage('✅ تم الطباعة بنجاح',error: false);
    print('✅ تم الطباعة بنجاح!');
  }
  Future<void> printReceipt(Person person,List<Project> projects) async {
    if (Platform.isAndroid) {
      await _printOnAndroid();
      listUsbDevices();
    } else if (Platform.isWindows) {
      List<String> printers = getAllPrinters();
       listPrinters();
      print("Installed Printers: $printers");
      print("getDefaultPrinter Printers: ${getDefaultPrinter()}");

      final receiptData = await generateArabicReceipt( person, projects);
      printToUSBPrinter(getDefaultPrinter(), Uint8List.fromList(receiptData));
    } else {
      showMessage("❌ نظام التشغيل غير مدعوم للطباعة عبر USB");
    }
  }
  Future<void> listUsbDevices() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isNotEmpty) {
      print("الأجهزة المتصلة عبر USB:");
      for (var device in devices) {
        print("${device.productName} - ${device.manufacturerName}");
      }
    } else {
      print("لم يتم العثور على أي أجهزة USB");
    }
  }

  /// 🟢 الطباعة على Android باستخدام usb_serial
  Future<void> _printOnAndroid() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      showMessage("❌ لم يتم العثور على أي طابعة USB على Android");
      return;
    }

    UsbPort? port;
    try {
      port = await devices.first.create();
      if (port == null) {
        showMessage("❌ تعذر إنشاء الاتصال بالطابعة.");
        return;
      }

      if (!await port.open()) {
        showMessage("❌ تعذر فتح منفذ USB على Android");
        return;
      }

      await port.setDTR(true);
      await port.setRTS(true);

      List<int> printData = _generateESC_POS();
      await port.write(Uint8List.fromList(printData));
      showMessage("✅ تمت الطباعة بنجاح على Android");
    } catch (e) {
      showMessage("❌ خطأ أثناء الطباعة على Android: $e");
    } finally {
      port?.close();
    }
  }



  /// 🔵 إنشاء بيانات الطباعة باستخدام أوامر ESC/POS
  List<int> _generateESC_POS() {
    return [
      0x1B, 0x40, // إعادة تعيين الطابعة
      0x1B, 0x61, 0x01, // محاذاة إلى المنتصف
      ...'*** متجر التقنية ***\n'.codeUnits,
      0x1B, 0x45, 0x01, // خط عريض
      ...'رقم الفاتورة: 12345\n'.codeUnits,
      0x1B, 0x45, 0x00, // تعطيل الخط العريض
      ...'--------------------------\n'.codeUnits,
      ...'الصنف       السعر     الكمية\n'.codeUnits,
      ...'منتج 1      10.00     2\n'.codeUnits,
      ...'منتج 2      15.00     1\n'.codeUnits,
      ...'--------------------------\n'.codeUnits,
      ...'الإجمالي:   35.00 ريال\n'.codeUnits,
      0x1D, 0x56, 0x41, 0x10, // قص الورق
    ];
  }


  Future<Uint8List> generateInvoice() async {
    String invoice = """
  شركة التجارة العامة
  ----------------------------
  التاريخ: ${DateTime.now()}
  الصنف        الكمية     السعر
  منتج 1        1        50.00
  منتج 2        2        30.00
  ----------------------------
  الإجمالي: 110.00
  """;
    return Uint8List.fromList(invoice.codeUnits);
  }


}

Future<Uint8List?> widgetToImage(GlobalKey key) async {
  try {
    RenderRepaintBoundary boundary =
    key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } catch (e) {
    debugPrint("Error: $e");
    return null;
  }
}





void saveInvoiceAsImage(BuildContext context, GlobalKey key) async {
  Uint8List? imageBytes = await widgetToImage(key);
  if (imageBytes != null) {
    String base64Image = base64Encode(imageBytes);
    debugPrint("Base64 Image: $base64Image");
  }
}
class InvoicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, ui.Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );

    final boldStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    // رسم مستطيل الفاتورة
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // رسم النصوص
    drawText(canvas, "فاتورة مبيعات", boldStyle, Offset(80, 20));
    drawText(canvas, "التاريخ: 2025-03-27", textStyle, Offset(10, 50));
    drawText(canvas, "العميل: ياسر كحيل", textStyle, Offset(10, 80));
    drawText(canvas, "----------------------------", textStyle, Offset(10, 110));
    drawText(canvas, "العنصر          السعر    الكمية", boldStyle, Offset(10, 140));
    drawText(canvas, "قهوة             10₪       2", textStyle, Offset(10, 170));
    drawText(canvas, "خبز              5₪        3", textStyle, Offset(10, 200));
    drawText(canvas, "----------------------------", textStyle, Offset(10, 230));
    drawText(canvas, "الإجمالي: 35₪", boldStyle, Offset(10, 260));
    drawText(canvas, "شكراً لزيارتكم!", textStyle, Offset(80, 300));
  }

  void drawText(Canvas canvas, String text, TextStyle style, Offset position) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}