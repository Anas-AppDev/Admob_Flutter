import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  var deviceIds = ["48E0041DFD6567F7509C3B093E447BDD"];
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: deviceIds,
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(MaterialApp(
    home: BannerAdmobPage(),
  ));
}

class BannerAdmobPage extends StatefulWidget {
  const BannerAdmobPage({super.key});

  @override
  State<BannerAdmobPage> createState() => _BannerAdmobPageState();
}

class _BannerAdmobPageState extends State<BannerAdmobPage> {

  late BannerAd bannerAd;
  bool isBannerLoaded = false;

  void initBannerAd() async{
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      request: AdRequest(),
      listener: BannerAdListener(
          onAdLoaded: (ad){
            setState(() {
              print("banner loaded");
              isBannerLoaded = true;
            });
          },
          onAdClosed: (ad){
            setState(() {
              print("banner closed");
              ad.dispose();
              isBannerLoaded = false;
            });
          },
          onAdFailedToLoad: (ad, err){
            setState(() {
              print("banner error");
              print(err.toString());
              ad.dispose();
              isBannerLoaded = false;
            });
          }
      ),
    );

    await bannerAd.load();
  }


  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isBannerLoaded ? SizedBox(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd,),
      ) : SizedBox(),
      body: Center(
        child: Text("Banner Ad"),
      ),
    );
  }
}
