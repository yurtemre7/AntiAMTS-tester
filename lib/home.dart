import 'package:amtstester/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final state = 0.obs; // 1 = anti amts aktiv test
  final isBlockedList = <bool>[].obs;
  final hadSomeErrors = false.obs;
  // 2 website tests
  // 3 error
  // 4 finished
  // dann neue seite

  testAMTSOn() async {
    var res = await httpClient.testUrl('http://dnstest.sierra-dev.de/');
    await Future.delayed(2.seconds);
    if (res) {
      state.value = 2;
      testUrls();
    } else {
      state.value = 3;
    }
  }

  testUrls() async {
    isBlockedList.value = await Future.wait<bool>([
      httpClient.testUrl('http://fecebook.com/'),
      httpClient.testUrl('http://fecebook.com/'),
      Future.value(false),
    ]);

    await Future.delayed(2.seconds);
    hadSomeErrors.value = isBlockedList.where((element) => !element).isNotEmpty;
    state.value = 4;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFF212121),
        body: Container(
          decoration: state.value == 4
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: hadSomeErrors.value
                        ? [
                            const Color(0xFF5E3702),
                            const Color(0xFF710003),
                            const Color(0xFF300043),
                          ]
                        : [
                            const Color(0xFF8D00F4),
                            const Color(0xFF000073),
                            const Color(0xFF2A0049),
                          ],
                  ),
                )
              : null,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Obx(
              () {
                int status = state.value;
                if (status == 4) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...isBlockedList.map((blocked) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                color: Colors.grey,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      blocked ? 'blocked' : 'not blocked',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: blocked
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.close),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: 3,
                        height: Get.size.height * 0.7,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: null,
                              icon: hadSomeErrors.value
                                  ? const Icon(Icons.warning_amber)
                                  : const Icon(Icons.check),
                              disabledColor: hadSomeErrors.value
                                  ? Colors.amber
                                  : Colors.green,
                              iconSize: 150,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${(isBlockedList.where((element) => element).length * 100 / isBlockedList.length).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 33,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Der Test war erfolgreich. Es sind keine weiteren Einwände notwendig, alles läuft wie gewöhnt.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                state.value = 0;
                              },
                              child: const Text('Neuer Test'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'AntiAMTS Tester',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    if (status == 0)
                      IconButton(
                        onPressed: () async {
                          state.value = 1;
                          testAMTSOn();
                        },
                        icon: const Icon(Icons.play_arrow_rounded),
                        iconSize: 80,
                      ),
                    if (status == 1 || status == 2)
                      const SizedBox(
                        height: 80,
                        width: 80,
                        child: CircularProgressIndicator(),
                      ),
                    if (status == 1)
                      Column(
                        children: const [
                          SizedBox(height: 30),
                          Text(
                            'Test läuft...',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Es wird überprüft, ob du AntiAMTS aktiv hast',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    if (status == 2)
                      Column(
                        children: const [
                          SizedBox(height: 30),
                          Text(
                            'Test läuft...',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'AntiAMTS wird getestet',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 50),
                          Text(
                            'Teste diverse gefährliche Websiten',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    if (status == 3)
                      Column(
                        children: const [
                          SizedBox(height: 30),
                          Text(
                            'Fehler',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Du hast den AntiAMTS Blocker nicht installiert.',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
