import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
void main()
{
 runApp(TimerApp(storage: CounterStorage()));
}
class TimerApp extends StatefulWidget
{
  final CounterStorage storage;

  TimerApp({Key key, @required this.storage}) : super(key: key);
  @override
  State<StatefulWidget> createState() 
  {
    return new TimerAppState();
  }
}
//
class TimerAppState extends State<TimerApp> 
{
  static const duration = const Duration(seconds: 1);
  int secondsPassed = 28800;
  bool isActive = false;
  Timer timer;
  /*void handleTick() 
  {
    if(isActive) 
    {
      setState
      (() {
        secondsPassed = secondsPassed - 1;
      });
    }
  }*/


@override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        if(value==0)
        {
          secondsPassed = 28800;
        }
        else{
          secondsPassed = value;
        }
      });
    });
  }

  Future<File> handleTick() 
  {
    if(isActive) 
    {
      setState
      (() {
        secondsPassed = secondsPassed - 1;
      });
    }  
    // Write the variable as a string to the file.
    return widget.storage.writeCounter(secondsPassed);
  }


  @override
 Widget build(BuildContext context)
 {
    if (timer == null)
    timer = Timer.periodic
    (
      duration, (Timer t) 
      {
        handleTick();
      }
    );
  int seconds = secondsPassed % 60;   
  int hours = secondsPassed ~/ (60 * 60);
  int minutes = (secondsPassed ~/ 60)-(hours*60);
   return MaterialApp
   (
     home:Scaffold
     (
        appBar:AppBar
        (
         title:Text("Countdown Timer")
        ),
        body: DecoratedBox
	      (
          position: DecorationPosition.background,
          decoration: BoxDecoration
          (
            //color: Colors.red,
            image: DecorationImage
            (
              image: AssetImage('images/face.jpg'),
              fit: BoxFit.fitHeight
            ),
          ),
          child: Center
          (
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Container
                (
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      RaisedButton
                      (
                        child: Text('RESET(4)'),
                        color: Colors.blue,
                        elevation: 4.0,
                        splashColor: Colors.green,
                        onPressed: ()
                        {
                          setState(() 
                          {
                            secondsPassed=14400;
                            isActive = false;
                          });
                        },
                      ),
                      Text("    "),
                      RaisedButton
                      (
                        child: Text('RESET(8)'),
                        color: Colors.blue,
                        elevation: 4.0,
                        splashColor: Colors.yellow,
                        onPressed: ()
                        {
                          setState(() 
                          {
                            secondsPassed=28800;
                            isActive = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container
                (
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [                
                      TextContainer( label: 'HRS', value: hours.toString().padLeft(2, '0')),
                      colon,
                      TextContainer( label: 'MIN', value: minutes.toString().padLeft(2, '0')),
                      colon,
                      TextContainer( label: 'SEC', value: seconds.toString().padLeft(2, '0')),
                    ],
                  ),
                ),
                //Text("\n"),
                Container
                (
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    [
                      RaisedButton
                      (
                        child: Text(isActive ? 'PAUSE' : 'START'),
                        color: Colors.blue,
                        elevation: 4.0,
                        splashColor: Colors.yellow,
                        onPressed: ()
                        {
                          setState(() 
                          {
                            isActive = !isActive;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
	      )       
      ),
    );
  }
}
// This stateless widget takes parameters to display custom widgets
class TextContainer extends StatelessWidget 
{
  TextContainer({this.label, this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      child: Column
      (
        mainAxisSize: MainAxisSize.min,
        children:
        [
          Text
          (
            '$value',
            style:TextStyle
            (
              fontSize: 30,
              color: Colors.white.withOpacity(0.6),
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.w500
            ),
          ),
          Text
          (
            '$label',
            style:TextStyle
            (
              fontSize: 10,
              color: Colors.white.withOpacity(0.6),
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      )
    );
  }
}
Widget colon = Container
(
  child: Text
  (
    ':',
    style:TextStyle
    (
      fontSize: 30,
      color: Colors.white.withOpacity(0.6),
      fontFamily: 'Comfortaa',
      fontWeight: FontWeight.w500
    ),
  ),
);

class CounterStorage 
{
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    //return File('$path/counter.txt');
    return File('images/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      //print(e)
      return 28800;
    }
  }

  Future<File> writeCounter(int secondsPassed) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$secondsPassed');
  }
}