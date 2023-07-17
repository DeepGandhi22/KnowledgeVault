import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'models/Reward.dart';
import 'myrewards.dart';
import 'mycourses.dart';
import 'faq.dart';
import 'package:knowledgevault/redeemItem.dart';
import 'HomePage.dart';

class marketplace extends StatefulWidget {
  const marketplace({super.key});

  @override
  State<marketplace> createState() => _marketplaceState();
}

class _marketplaceState extends State<marketplace> {
  final DatabaseReference _rewardsRef =
      FirebaseDatabase.instance.reference().child('RewardList');
  List<Reward> rewardList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      DatabaseEvent event = await _rewardsRef.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        print('Retrieved data: $data');
        // print('Retrieved data: ${data.runtimeType}');
        List<Reward> fetchedRewards = [];
        data.forEach((key, value) {
          Reward reward = Reward.fromMap(value);
          fetchedRewards.add(reward);
        });

        setState(() {
          rewardList =
              fetchedRewards; // Update the rewardList with the fetched rewards
        });
      }
    } catch (error) {
      print('Error fetching rewards data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Rewards'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.business_center,
                      size: 20,
                      color: Color.fromRGBO(116, 85, 247, 1),
                    ),
                    Text(
                      "1000",
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(116, 85, 247, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GridView.builder(
                  itemCount: rewardList.length,
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio:
                        (MediaQuery.of(context).size.height) / (1 * 350),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromRGBO(116, 85, 247, 0.1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rewardList[index].name ?? '',
                              style: const TextStyle(
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              rewardList[index].description ?? '',
                              maxLines:
                                  1, // Specify the maximum number of lines to show
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontFamily: 'RobotoMono',
                                fontStyle: FontStyle.italic,
                                fontSize: 10,
                                color: Color.fromRGBO(131, 136, 139, 1),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // 'price:100',
                                  // 'Price:' + rewardList[index].points.toString(),
                                  'Price: ${rewardList[index].points}',
                                  style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    print('Name: ${rewardList[index].name}');
                                    print(
                                        'Description: ${rewardList[index].description}');
                                    print(
                                        'Points: ${rewardList[index].points}');
                                    print(
                                        'picture: ${rewardList[index].picture}');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => redeemItem(
                                                  name:
                                                      rewardList[index].name ??
                                                          '',
                                                  description: rewardList[index]
                                                          .description ??
                                                      '',
                                                  picture: rewardList[index]
                                                          .picture ??
                                                      '',
                                                  points: rewardList[index]
                                                          .points ??
                                                      0,
                                                )));
                                  },
                                  child: const Text('Redeem Now'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 20,
        showUnselectedLabels: true,
        selectedItemColor: const Color.fromRGBO(116, 85, 247, 1),
        selectedFontSize: 12,
        unselectedItemColor: const Color.fromRGBO(131, 136, 139, 1),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_sharp), label: 'My Rewards'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business_outlined), label: 'Marketplace'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined), label: 'My Courses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_answer_outlined), label: 'FAQs'),
        ],
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const myrewards()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const marketplace()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );

            // No action needed
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const mycourses()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const faq()),
            );
          }
        },
      ),
    );
  }
}

class Reward {
  String? description;
  String? name;
  int? points;
  String? picture;

  Reward({this.description, this.name, this.points, this.picture});

  factory Reward.fromMap(Map<dynamic, dynamic> map) {
    return Reward(
      name: map['name'],
      description: map['description'],
      points: map['points'],
      picture: map['picture'],
    );
  }
}
