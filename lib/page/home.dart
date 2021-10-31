import 'package:election_exit_poll_07610577/page/calculate_page.dart';
import 'package:election_exit_poll_07610577/sevices/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatefulWidget {

  static const routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List> _candidateList;
  bool  _isLoading  = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      const SizedBox(
                        height: 30.0,
                      ),
                      Image.asset('assets/images/vote_hand.png', height: 100.0,),
                      Text('EXIT POLL', style: GoogleFonts.kanit(color: Colors.white, fontSize: 24),),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text('เลือกตั้ง อบต.', style: GoogleFonts.kanit(color: Colors.white, fontSize: 24),),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text('รายชื่อผู้รับสมัครเลือกตั้ง', style: GoogleFonts.kanit(color: Colors.white, fontSize: 18),),
                      Text('นายกองค์การบริหารส่วนตำบลเขาพระ', style: GoogleFonts.kanit(color: Colors.white, fontSize: 18),),
                      Text('อำเภอเมืองนครนายก จังหวัดนครนายก', style: GoogleFonts.kanit(color: Colors.white, fontSize: 18),),
                      const SizedBox(
                        height: 10.0,
                      ),
                      FutureBuilder<List>(
                        future: _candidateList,
                        builder: (context, snapshot){
                          if(snapshot.connectionState != ConnectionState.done){
                            return const CircularProgressIndicator();
                          }

                          if(snapshot.hasError){
                            return  Text("เกิดข้อผิดพลาด ${snapshot.error}");
                          }

                          if(snapshot.hasData){
                            var data = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  for(var i=0;i<snapshot.data!.length;++i)
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            _vote('${data[i]['number']}');
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 50.0,
                                              height: 50.0,
                                              color: Colors.green.withOpacity(0.95),
                                              child: Text('${data[i]['number']}', style: GoogleFonts.kanit(color: Colors.white, fontSize: 28), textAlign: TextAlign.center,),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 50.0,
                                                color: Colors.white.withOpacity(0.95),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('${data[i]['title']} ${data[i]['firstName']} ${data[i]['lastName']}', style: GoogleFonts.kanit(color: Colors.black, fontSize: 16)),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const Expanded(child: SizedBox.shrink(),),
                      ElevatedButton(onPressed: (){
                        Navigator.pushNamed(
                          context,
                          calculatepage.routeName,
                        );
                      },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 30), // double.infinity is the width and 30 is the height
                          ),
                          child: Text("ดูผล")
                      )
                    ],
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        ),
      );
  }
  @override
  void initState() {
    super.initState();
    _candidateList = _getCandidate();
  }
  Future<List> _getCandidate() async {
    return await Api().fetch('exit_poll');
  }

  void _vote(String number) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var data = (await Api().submit('exit_poll', {'candidateNumber': int.parse(number)})) as List;
      _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ $data');
    } catch (e) {
      print(e);
      _showMaterialDialog('ERROR', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}