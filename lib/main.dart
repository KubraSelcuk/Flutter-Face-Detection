import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //Flutter uygulamasında Firebase'i başlatmak için gerekli adımları gerçekleştirir.
  //İlk olarak, Flutter widgetlerinin başlatılmasını sağlar. 
  //Ardından, Firebase'i varsayılan seçeneklerle başlatır ve bu işlem tamamlanana kadar diğer kod satırlarının çalışmasını engeller. 
  //Bu kod, Firebase ile etkileşime geçmek ve Firebase hizmetlerini kullanmak için gereklidir.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FacePage(),
    ),
  );
}

class FacePage extends StatefulWidget {
  const FacePage({Key? key}) : super(key: key);

  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  XFile? _imageFile; //Seçilen veya alınan bir görüntünün dosya yolunu temsil eden bir _imageFile değişkeni tanımlar,
  //Resim dosyalarını temsil etmek için kullandığı bir sınıftır.
  
  List<Face>? faceslist = []; 
  //Yüz tanıma sonuçlarını depolamak için bir liste olan faceslist değişkenini tanımlar. 
  //Face sınıfı, yüzlerin özelliklerini ve konumlarını temsil etmek için kullanılan bir sınıftır ? işareti, bu listenin null olabileceğini ifade eder.
  
  bool isLoading = false; 

  //Bir yüklenme durumunu temsil eden isLoading değişkenini tanımlar. 
  //Bu değişken, görüntünün işlenme sürecinde olduğunda veya yüklenirken true değerini alır.
  
  late ui.Image _image;

  //Görüntünün işlenmiş hali olan _image değişkenini tanımlar.
  // ui. Image sınıfı, Flutter'ın 2D grafikleri temsil etmek için kullandığı bir sınıftır. 
  //late kelimesi, _image değişkeninin daha sonra atama yapılacağını ve non-null olacağını belirtir.

  _getImageAndDetectFaces() async {
    //resim seçmek için kullanıcının galeriyi açmasına izin verir ve seçilen resmi yüz tanıma işlemine tabi tutar.
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      //Eğer imageFile null ise (kullanıcı herhangi bir resim seçmezse), _imageFile ve faceslist değişkenleri null olarak ayarlanır ve işlev sonlandırılır.
      setState(() {
        _imageFile = null;
        faceslist = [];
      });
      return;
    }
    setState(() {
      //isLoading değişkeni true olarak ayarlanır, böylece yüklenme durumu gösterilir.
      isLoading = true;
    });
    final InputImage inputImage = InputImage.fromFile(File(imageFile.path));
    //Seçilen resim inputImage olarak dönüştürülür ve Google ML Kit Vision kütüphanesindeki yüz tanıma işlemine tabi tutulur. 
    //Bu işlem sonucunda tespit edilen yüzler faces listesine atanır.
    final faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(enableLandmarks: true),
    );
    List<Face> faces = await faceDetector.processImage(inputImage);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        faceslist = faces;
        _loadImage(File(imageFile.path));
        //Eğer widget ağacında hala yer alıyorsa (mounted durumu), _imageFile ve faceslist değişkenleri güncellenir ve _loadImage() fonksiyonu çağrılır.
      });
    }
  }

  _loadImage(File file) async {

    //verilen bir dosyadan görüntüyü yükleyen ve _image değişkenine atayan bir asenkron işlevdir.
    final data = await file.readAsBytes();
    //Dosya verileri readAsBytes() kullanılarak okunur.
    await decodeImageFromList(data).then(
      //Okunan veriler decodeImageFromList() kullanılarak görüntüye dönüştürülür.
      (value) => setState(() {
        _image = value;
       // Dönüştürülen görüntü _image değişkenine atanır.
        isLoading = false;

        //isLoading değişkeni false olarak ayarlanır, yüklenme durumu sonlandırılır.
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Detection')),
      //Eğer isLoading true ise, yani resim yükleniyor ise, ekranda yüklenme göstergesi (CircularProgressIndicator) görüntülenir
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_imageFile == null)

              ? const Center(child: Text('Görsel Seçiniz'))
              //Eğer _imageFile null ise, yani herhangi bir resim seçilmemiş ise, ekranda "Görsel Seçiniz" metni görüntülenir.
              : Center(
                  child: FittedBox(
                    child: SizedBox(
                      width: _image.width.toDouble(),
                      height: _image.height.toDouble(),
                      child: CustomPaint(
                        painter: FacePainter(_image, faceslist!),
                        //Eğer _imageFile null değilse, yani bir resim seçilmiş ise, CustomPaint widget'ı kullanılarak yüzleri çizen bir FacePainter özelleştirilmiş resim görüntülenir. 
                        //FittedBox ve SizedBox widget'ları, görüntünün uygun boyutlarda ve sınırlarda görüntülenmesini sağlar.
                      ),
                    ),
                  ),
                ),

                //floatingActionButton özelliği, kullanıcıya resim seçme işlemini gerçekleştirebilmek için bir yüzen eylem düğmesi (floating action button) ekler.
                // Bu düğme, onPressed olayına _getImageAndDetectFaces işlevini atar ve bir fotoğraf simgesini içerir.
      floatingActionButton: FloatingActionButton(
        onPressed: _getImageAndDetectFaces,
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.black,
          size: 35.0,
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  //FacePainter sınıfının yapıcısı, bir ui.Image nesnesi (image) ve bir List<Face> (faces) alır. 
  //image, çizilecek resmi temsil ederken, faces ise yüz tespit sonuçlarını içeren bir liste olarak gelir.
  final ui.Image image;
  final List<Face> faces;
  //rects listesi, yüzlerin sınırlayıcı dikdörtgenlerini depolamak için kullanılır. 
  final List<Rect> rects = [];

//Yapıcı içinde, yüzlerin sınırlayıcı dikdörtgenleri (boundingBox) faces listesindeki her yüz için rects listesine eklenir.
  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  //paint metodu, özel çizim işlemlerini gerçekleştirir. Bu metod, ui.Canvas ve ui.Size parametrelerini alır.
  // ui.Canvas nesnesi, çizim işlemlerini gerçekleştirmek için kullanılır. ui.Size ise çizim alanının boyutunu temsil eder.
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
    //Paint nesnesi oluşturulur ve çizim ayarları atanır.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = Colors.red;


    canvas.drawImage(image, Offset.zero, Paint());
    //image nesnesini (ui.Image) sol üst köşeden başlayarak canvas üzerine çizer.
    for (var i = 0; i < faces.length; i++) {
      //yüzlerin sınırlayıcı dikdörtgenleri (rects) canvas.drawRect(rects[i], paint) kullanılarak çizilir. 
      //Bu işlem, her yüz için bir dikdörtgenin çizilmesini sağlar.
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  //shouldRepaint metodu, FacePainter nesnesinin yeniden çizim yapılıp yapılmayacağını kontrol eder. 
  //Bu metot, eski ve yeni FacePainter nesnelerinin resim (image) ve yüzler (faces) özelliklerini karşılaştırarak yeniden çizim gerekliliğini belirler.
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
