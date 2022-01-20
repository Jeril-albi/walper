import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:wallper/data/data.dart';
import 'package:wallper/model/wallpaper.dart';
import 'package:wallper/views/image_view.dart';
import 'package:wallper/views/ads.dart';

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wal",
        style: TextStyle(color: Colors.black87),
      ),
      Text(
        "Per",
        style: TextStyle(color: Colors.redAccent[700]),
      ),
    ],
  );
}

Widget premiumtitle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wal",
        style: TextStyle(color: Colors.black87),
      ),
      Text(
        "Per",
        style: TextStyle(color: Colors.redAccent[700]),
      ),
      Container(
          height: 35,
          width: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/premium.gif'),
            ],
          ))
    ],
  );
}

Widget premiumCatgorytitle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wal",
        style: TextStyle(color: Colors.black87),
      ),
      Text(
        "Per",
        style: TextStyle(color: Colors.redAccent[700]),
      ),
      SizedBox(
        width: 5,
      ),
      Container(
        height: 25,
        width: 25,
        child: Image.asset("assets/crown.png"),
      )
    ],
  );
}

Ads advert = Ads();

Widget Wallpaperlist(List<Wallpapermodel> wallpapers, context) {
  int load = 1;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              if (isPurchased) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageView(
                              imgurl: wallpaper.src.portrait,
                            )));
              } else {
                if (load == 3) {
                  load = 0;
                  advert.showInter(context);
                }
                load = load + 1;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageView(
                              imgurl: wallpaper.src.portrait,
                            )));
              }
            },
            child: Hero(
              tag: wallpaper.src.portrait,
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FadeInImage(
                      image: wallpaper.src.portrait == null
                          ? AssetImage("assets/loadimg.jpg")
                          : NetworkImage(wallpaper.src.portrait),
                      fit: BoxFit.cover,
                      placeholder: AssetImage("assets/loadimg.jpg"),
                    )),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

bool adLoaded = false;
var adComplete;
var adSkipped;
dialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Premium wallpapers are special !"),
          content: Text("Open it by watching an ad"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                await UnityAds.load(
                    placementId: 'Rewarded_Android',
                    onComplete: (s) {
                      adLoaded = true;
                    });

                if (adLoaded == true) {
                  UnityAds.showVideoAd(
                      placementId: "Rewarded_Android",
                      onComplete: adComplete,
                      onSkipped: adSkipped);
                } else {
                  toastMsg();
                }
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
          ],
        );
      });
}

toastMsg() {
  return Fluttertoast.showToast(msg: 'Try Again');
}

//var adListner;

Widget PremiumList(List<Wallpapermodel> wallpapers, context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              isPurchased
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageView(
                                imgurl: wallpaper.src.portrait,
                              )))
                  : dialog(context);

              var complete = () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageView(
                              imgurl: wallpaper.src.portrait,
                            )));
              };

              var skip = () {
                Navigator.pop(context);
              };

              adComplete = complete;
              adSkipped = skip;
            },
            child: Hero(
              tag: wallpaper.src.portrait,
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FadeInImage(
                      image: wallpaper.src.portrait == null
                          ? AssetImage("assets/loadimg.jpg")
                          : NetworkImage(wallpaper.src.portrait),
                      fit: BoxFit.cover,
                      placeholder: AssetImage("assets/loadimg.jpg"),
                    )),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
