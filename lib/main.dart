import 'dart:convert'; //For Json decode
import 'package:flutter/material.dart';
import 'my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Homepage(),
      theme: ThemeData(
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  MyColors myClr = MyColors();
  //visibility, feels like, wind
  dynamic _temp;
  dynamic feelsLike;
  dynamic vis; //visibility
  dynamic windSpeed;
  String _city = "Boston";
  TextEditingController controller = TextEditingController();

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=$_city&units=metric&appid=f1e598ceb9d414791eb3f1972697c43e"));
    var results = jsonDecode(response.body);
    setState(() {
      _temp = results['main']['temp'];
      feelsLike = results['main']['feels_like'];
      vis = results['visibility'];
      windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  Text bodyText(String txt,
      {double fSize = 25.0, FontWeight fWeight = FontWeight.bold}) {
    //fSize= font size
    return Text(
      txt,
      //textAlign: TextAlign.left,
      style: TextStyle(
        color: myClr.clrWhiteLight,
        fontSize: fSize,
        fontWeight: fWeight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myClr.clrBlueDarker,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                color: myClr.clrWhiteLight,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  child: Text(
                    _city,
                    style: TextStyle(
                      color: myClr.clrBlueDarker,
                      fontSize: 46.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: double.maxFinite),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bodyText("Temperature"),
                      bodyText(_temp.toString() + " °C"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bodyText("Feels Like"),
                      bodyText(feelsLike.toString() + "°C"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bodyText("Visibility"),
                      bodyText((vis / 1000).toString() + " Km"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bodyText("Wind speed"),
                      bodyText(windSpeed.toString() + " Km"),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 15.0,
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (String value) {
                  setState(() {
                    _city = value;
                    getWeather();
                  });
                },
                keyboardType: TextInputType.streetAddress,
                style: TextStyle(
                  color: myClr.clrBlueDarker,
                  fontSize: 18.0,
                  //fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  fillColor: myClr.clrWhiteLight,
                  filled: true,
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search_rounded),
                    color: myClr.clrBlueDarker,
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        _city = controller.text;
                        getWeather();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'e.g. Boston',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
