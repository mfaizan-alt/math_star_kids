import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/commonWidgets/ads/reward_ad.dart';
import '../../core/commonWidgets/premium_dialog.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/routes.dart';
import '../../core/services/premium_service.dart';
import '../../core/services/stars_service.dart';

class StoryModeController extends GetxController {
  final selectedType = 'math'.obs;
  static const int tier1Threshold = 60;
  static const int tier2Threshold = 100;

  final RxBool tier1Unlocked = false.obs;
  final RxBool tier2Unlocked = false.obs;


  final RxList<Map<String, dynamic>> stories = <Map<String, dynamic>>[

    // Story 1 Mango Orchard story (MATH)
    {
      "title": "The Mango Orchard Adventure",
      "description": "A boy collects mangoes in a sunny orchard.",
      "cover": "assets/images/mangoOrchard/mangoOrchardCover.jpeg",
      "type": "math",
      "subject": "×",
      "stars": 3,
      "scenes": [
        {
          "image": "assets/images/mangoOrchard/mangoOrchardScene1.jpeg",
          "bg": "green",
          "text":
          "Ali went to his grandfather's big farm. He saw a huge mango tree full of juicy mangoes!",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/mangoOrchard/mangoOrchardScene2.jpeg",
          "bg": "yellow",
          "text":
          "Ali got 4 big wooden boxes ready. He was going to fill each one carefully.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/mangoOrchard/mangoOrchardScene3.jpeg",
          "bg": "orange",
          "text":
          "Ali has 4 boxes and puts 3 mangoes in each box. How many mangoes does Ali have in total?",
          "hasQuestion": true,
          "options": [8, 10, 12, 14],
          "answer": 12,
        },
        {
          "image": "assets/images/mangoOrchard/mangoOrchardScene4.jpeg",
          "bg": "coral",
          "text":
          "Ali had 12 mangoes! He shared them with all his friends. Everyone was so happy!",
          "hasQuestion": false,
        },
      ],
    },

    // Cookies Story (MATH)
    {
      "title": "The Cookie Bakery",
      "description": "Sara bakes cookies for her family and learns to add them up.",
      "cover": "assets/images/cookieStory/cookieCover.jpeg",
      "type": "math",
      "subject": "+",
      "stars": 2,
      "scenes": [
        {
          "image": "assets/images/cookieStory/scene1.jpeg",
          "bg": "pink",
          "text": "Sara loves baking cookies. Today she is making a special batch for her whole family!",
          "hasQuestion": false
        },
        {
          "image": "assets/images/cookieStory/scene2.jpeg",
          "bg": "yellow",
          "text": "Sara baked 8 chocolate cookies and put them on a tray. Then she baked 6 more vanilla cookies.",
          "hasQuestion": false
        },
        {
          "image": "assets/images/cookieStory/scene3.jpeg",
          "bg": "orange",
          "text": "Sara has 8 chocolate cookies and 6 vanilla cookies. How many cookies does Sara have in total?",
          "hasQuestion": true,
          "options": [12, 14, 16, 18],
          "answer": 14
        },
        {
          "image": "assets/images/cookieStory/scene4.jpeg",
          "bg": "coral",
          "text": "Sara had 14 cookies! She packed them in a box and gave them to her family. Everyone loved them!",
          "hasQuestion": false
        }
      ]
    },

    // Fish Market Story (MATH)
    {
      "title": "The Busy Fish Market",
      "description": "Omar sells fish at the market and learns to subtract.",
      "cover": "assets/images/fishStory/fishCover.jpeg",
      "type": "math",
      "subject": "-",
      "stars": 2,
      "scenes": [
        {
          "image": "assets/images/fishStory/scene1.jpeg",
          "bg": "blue",
          "text": "Omar and his father go to the fish market early in the morning. Their basket is full of fresh fish!",
          "hasQuestion": false
        },
        {
          "image": "assets/images/fishStory/scene2.jpeg",
          "bg": "teal",
          "text": "They had 15 fish in their basket. Many customers came and bought fish one by one.",
          "hasQuestion": false
        },
        {
          "image": "assets/images/fishStory/scene3.jpeg",
          "bg": "cyan",
          "text": "Omar started with 15 fish. Customers bought 9 fish. How many fish are left in the basket?",
          "hasQuestion": true,
          "options": [4, 5, 6, 7],
          "answer": 6
        },
        {
          "image": "assets/images/fishStory/scene4.jpeg",
          "bg": "green",
          "text": "6 fish were left! Omar's father smiled and said Omar was getting very good at counting!",
          "hasQuestion": false
        }
      ]
    },

    // Balloon Story (MATH)
    {
      "title": "The Balloon Fair",
      "description": "Hana visits the fair and discovers the magic of multiplication.",
      "cover": "assets/images/balloonStory/balloonCover.jpeg",
      "type": "math",
      "subject": "×",
      "stars": 3,
      "scenes": [
        {
          "image": "assets/images/balloonStory/scene1.jpeg",
          "bg": "purple",
          "text": "Hana went to the big fair with her mother. There were colorful balloons everywhere!",
          "hasQuestion": false
        },
        {
          "image": "assets/images/balloonStory/scene2.jpeg",
          "bg": "pink",
          "text": "Hana saw 5 balloon sellers. Each seller was holding a bunch of balloons tied together.",
          "hasQuestion": false
        },
        {
          "image": "assets/images/balloonStory/scene3.jpeg",
          "bg": "blue",
          "text": "There are 5 balloon sellers. Each seller has 6 balloons. How many balloons are there in total?",
          "hasQuestion": true,
          "options": [25, 28, 30, 35],
          "answer": 30
        },
        {
          "image": "assets/images/balloonStory/scene4.jpeg",
          "bg": "yellow",
          "text": "30 balloons filled the sky! Hana clapped and said multiplication makes counting so much easier!",
          "hasQuestion": false
        }
      ]
    },

    // Story 2 a lost puppy story(LEARNING)
    {
      "title": "The Lost Little Puppy",
      "description": "A child helps a puppy find its way home.",
      "cover": "assets/images/lostDog/lostDogStoryCover.jpeg",
      "type": "reading",
      "stars": 2,
      "scenes": [
        {
          "image": "assets/images/lostDog/scene1.jpeg",
          "bg": "blue",
          "text":
          "One rainy day, a little puppy got lost in the park. He was cold, wet, and very sad. He could not find his home and sat under a tree, looking around..",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/lostDog/scene2.jpeg",
          "bg": "purple",
          "text":
          "Sara heard the puppy crying softly. She cared about him and decided to help. She looked around the park carefully to find where the sound was coming from.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/lostDog/scene3.jpeg",
          "bg": "pink",
          "text":
          "Sara found the puppy hiding under a big tree. She gently picked him up and gave him warmth. The puppy felt safe with her.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/lostDog/scene4.jpeg",
          "bg": "green",
          "text":
          "Sara helped the puppy find his home. His family was very happy to see him again. The puppy wagged his tail and everyone smiled!",
          "hasQuestion": false,
        },
      ],
    },

    // Story 3 Glowing Cave(LEARNING)
    {
      "title": "Anaya & Zain and the Glowing Cave",
      "description":
      "Two brave siblings discover a magical cave and rescue an injured baby bird.",
      "cover": "assets/images/glowingCave/cover.jpeg",
      "type": "reading",
      "stars": 2,
      "scenes": [
        {
          "image": "assets/images/glowingCave/scene1.jpeg",
          "bg": "blue",
          "text":
          "One sunny day, the whole family went for a picnic in the green hills. While eating, Anaya suddenly saw a strange glowing light coming from far away. 'Zain, look! What is that?' she whispered with big curious eyes.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/glowingCave/scene2.jpeg",
          "bg": "purple",
          "text":
          "They walked closer and found a dark cave with a soft glow coming from inside. Anaya and Zain held hands tightly — they were a little scared. But they took a deep breath and walked in together, brave and bold.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/glowingCave/scene3.jpeg",
          "bg": "pink",
          "text":
          "Inside the cave, they saw beautiful glowing mushrooms lighting up the walls like tiny stars. Then they heard a soft sound — cheep, cheep! A little baby bird was sitting on the ground with a hurt wing. Anaya gently picked it up and said, 'Don't worry little one, we will help you!",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/glowingCave/scene4.jpeg",
          "bg": "green",
          "text":
          "Outside in the warm sunshine, the family helped nurse the little bird back to health. Mama and Baba smiled with proud and happy hearts. And just then, a big beautiful rainbow appeared in the sky — as if nature itself was saying thank you!",
          "hasQuestion": false,
        },
      ],
    },

    // Story 3 Little Seed(LEARNING)
    {
      "title": "“The Little Seed That Never Gave Up”",
      "description":
      "Tiny seed struggles in the dark soil but slowly grows into a strong tree, teaching kids that patience and effort always lead to success.",
      "cover": "assets/images/littleSeed/seedCover.jpeg",
      "type": "reading",
      "stars": 2,
      "scenes": [
        {
          "image": "assets/images/littleSeed/scene1.jpeg",
          "bg": "blue",
          "text": "A tiny seed lay buried deep inside dark soil.It was cold, quiet, and heavy above it.“I feel forgotten… I will never grow,” the seed whispered softly. Above the ground, wind blew and rain tapped gently, but the seed could not see anything yet.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/littleSeed/scene2.jpeg",
          "bg": "purple",
          "text":
          "Days passed. The soil stayed wet after rain. The sun warmed the earth again and again.The seed felt pressure from all sides.It wanted to give up… but something inside it kept pushing.“I must try one more time,” it said quietly.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/littleSeed/scene3.jpeg",
          "bg" : "pink",
          "text" : "One morning, something amazing happened.A tiny green sprout broke through the soil and reached toward the light.It had never seen the sun before… it was bright and warm.The sprout felt strong for the first time.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/littleSeed/scene4.jpeg",
          "bg": "green",
          "text":
          "Weeks turned into months. The sprout grew into a strong tree with wide branches and bright red apples. Children came to sit under its shade, laugh, and enjoy the fruit.The tree remembered its hard days underground and smiled.“I almost gave up… but I kept going,” it whispered in the wind. \n“Keep growing — your time to shine will come.” ",
          "hasQuestion": false,
        },
      ],
    },

    //   Story 4 Train that goes noWhere(Learning)
    {
      "title": "“The Train That Goes Nowhere”",
      "description":
      "Tiny seed struggles in the dark soil but slowly grows into a strong tree, teaching kids that patience and effort always lead to success.",
      "cover": "assets/images/stoppedTrain/trainCover.jpeg",
      "type": "reading",
      "stars": 2,
      "scenes": [
        {
          "image": "assets/images/stoppedTrain/scene1.jpeg",
          "bg": "blue",
          "text": "On the edge of a small village stood an old rusty train. It never moved, never made sound, and looked forgotten by time.Children stayed away from it, whispering,“Don’t go near it… it’s haunted.” But Fatima often looked at it from a distance, curious instead of scared..",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/stoppedTrain/scene2.jpeg",
          "bg": "purple",
          "text":
          "One rainy afternoon, Fatima decided to find the truth.The train door creaked as she climbed inside slowly. Instead of ghosts, she saw something surprising—dusty seats, soft light through broken windows, and walls covered with old paintings. It didn’t feel scary… it felt forgotten..",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/stoppedTrain/scene3.jpeg",
          "bg" : "pink",
          "text" : "Inside one corner, Fatima found books stacked neatly and a small leather journal. It belonged to an old artist who once lived and traveled in the train, drawing everything he saw. His words were full of kindness, dreams, and love for stories. Fatima smiled, realizing the train was not empty—it was full of memories..",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/stoppedTrain/scene4.jpeg",
          "bg": "green",
          "text":
          "Fatima shared her discovery with the village. Together, the villagers cleaned the train, placed mats, and arranged books inside. Soon, children were reading, laughing, and learning inside the “moving library that never moves.”The scary train had become the happiest place in the village. “You can turn something forgotten into something beautiful.”",
          "hasQuestion": false,
        },
      ],
    },

    //   Story 5 Flying kite(Learning)
    {
      "title": "“The Flying Kite and the Kind Stranger”",
      "description":
      "Tiny seed struggles in the dark soil but slowly grows into a strong tree, teaching kids that patience and effort always lead to success.",
      "cover": "assets/images/kiteStory/kiteCover.jpeg",
      "type": "reading",
      "stars": 2,
      "minStars": 60, "isPremium": true,
      "scenes": [
        {
          "image": "assets/images/kiteStory/scene1.jpeg",
          "bg": "blue",
          "text": "Zara makes a beautiful kite using her late grandfather’s old cloth and feels very happy. On a windy day, the kite suddenly breaks free and flies high into the sky.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/kiteStory/scene2.jpeg",
          "bg": "purple",
          "text":
          "Zara runs after the kite through streets, bazaar, and over a small bridge. She keeps running because the kite is very special to her. People watch her, but she does not stop at all.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/kiteStory/scene3.jpeg",
          "bg" : "pink",
          "text" : "The kite gets stuck in a tall tree in an old quiet park, and Zara feels tired and worried. An old man is sitting nearby and looking at the kite calmly.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/kiteStory/scene4.jpeg",
          "bg": "green",
          "text":
          "The old man says the kite reminds him of his childhood, and Sara smiles as they talk and become friends under the tree. “Kindness can turn a moment into a lifelong memory.”",
          "hasQuestion": false,
        },
      ],
    },


    // Story 6 Lost Lantern(Learning)
    {
      "title": "The Lost Lantern",
      "description": "A young boy loses his grandfather's lantern on the night of Eid and learns that asking for help is a sign of bravery, not weakness.",
      "cover": "assets/images/lostLantern/lostLanternCover.jpeg",
      "type": "reading",
      "stars": 2,
      "minStars": 100, "isPremium": true,
      "scenes": [
        {
          "image": "assets/images/lostLantern/scene1.jpeg",
          "bg": "orange",
          "text": "On the eve of Eid, Bilal's grandfather gives him a beautiful old brass lantern to carry in the village parade. Bilal holds it carefully and feels very proud and happy.",
          "hasQuestion": false
        },
        {
          "image": "assets/images/lostLantern/scene2.jpeg",
          "bg": "teal",
          "text": "During the noisy parade, Bilal gets separated from his family. He looks left and right but cannot find them. The lantern is still in his hands but his heart is beating fast.",
          "hasQuestion": false
        },
        {
          "image": "assets/images/lostLantern/scene3.jpeg",
          "bg": "purple",
          "text": "Bilal feels scared but remembers what his grandfather always said — brave people ask for help. He walks up to a kind shopkeeper and tells her he is lost.",
          "hasQuestion": false
        },
        {
          "image": "assets/images/lostLantern/scene4.jpeg",
          "bg": "yellow",
          "text": "The shopkeeper helps Bilal find his family. His grandfather hugs him tight and says the lantern did its job — it guided Bilal back home through his bravery.",
          "hasQuestion": false
        }
      ]
    },

    // Star Jar Story MATH
    {
      "title": "The Star Jars",
      "description": "Zaid collects shiny stars and learns to share them equally.",
      "cover": "assets/images/starJar/starJarsCover.jpeg",
      "type": "math",
      "subject": "÷",
      "stars": 3,
      "minStars": 60, "isPremium": true,
      "scenes": [
        {
          "image": "assets/images/starJar/scene1.jpeg",
          "bg": "purple",
          "text": "Zaid loves collecting shiny little stars. He has a big jar full of golden stars on his shelf!",
          "hasQuestion": false
        },
        {
          "image": "assets/images/starJar/scene2.jpeg",
          "bg": "blue",
          "text": "Zaid wants to share his stars equally with his 4 friends. He gets 4 empty jars ready.",
          "hasQuestion": false
        },
        {
          "image": "assets/images/starJar/scene3.jpeg",
          "bg": "teal",
          "text": "Zaid has 20 stars and 4 jars. He wants each jar to have the same number. How many stars go in each jar?",
          "hasQuestion": true,
          "options": [3, 4, 5, 6],
          "answer": 5
        },
        {
          "image": "assets/images/starJar/scene4.jpeg",
          "bg": "yellow",
          "text": "5 stars in each jar! Zaid gave one jar to each friend. Sharing equally makes everyone smile!",
          "hasQuestion": false
        }
      ]
    },

    // ═══ PREMIUM STORIES (Unlocked at 40 stars) ═══

    // Premium Math Story 1 APPLE MARKET
    {
      "title": "The Market Adventure (Premium)",
      "description": "Zara helps at her father's market and learns advanced math.",
      "cover": "assets/images/appleMarket/AppleCover.jpeg",
      "type": "math",
      "subject": "÷",
      "stars": 3,
      "minStars": 100
      , "isPremium": true,
      "scenes": [
        {
          "image": "assets/images/appleMarket/scene1.jpeg",
          "bg": "orange",
          "text": "Zara's father runs a busy market. Today he has 24 apples to distribute equally among 6 baskets.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/appleMarket/scene2.jpeg",
          "bg": "yellow",
          "text": "Zara carefully counted the apples. She needs to put the same number in each basket.",
          "hasQuestion": false,
        },
        {
          "image": "assets/images/appleMarket/scene3.jpeg",
          "bg": "coral",
          "text": "If 24 apples go into 6 baskets equally, how many apples will be in each basket?",
          "hasQuestion": true,
          "options": [3, 4, 6, 8],
          "answer": 4,
        },
        {
          "image": "assets/images/appleMarket/scene4.jpeg",
          "bg": "green",
          "text": "Perfect! 4 apples in each basket. Customers were happy with the organized market!",
          "hasQuestion": false,
        },
      ],
    },


  ].obs;

  final _box = GetStorage();

  /// Story titles unlocked for today only via a rewarded ad ("day pass").
  final RxSet<String> dayPassStories = <String>{}.obs;

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<StarsService>()) {
      ever(StarsService.to.totalStars, (_) => stories.refresh());
    }
    if (Get.isRegistered<PremiumService>()) {
      ever(PremiumService.to.isPremium, (_) => stories.refresh());
    }
    _loadDayPasses();
    // Preload so the "watch to read it today" button is ready when a locked
    // story is tapped.
    RewardedAdService.instance.loadAd();
  }

  void _loadDayPasses() {
    final saved = _box.read('storyDayPass');
    if (saved is Map && saved['date'] == _todayKey) {
      dayPassStories.addAll(List<String>.from(saved['stories'] ?? []));
    }
  }

  void _grantDayPass(Map<String, dynamic> story) {
    dayPassStories.add(story['title'] as String);
    _box.write('storyDayPass', {
      'date': _todayKey,
      'stories': dayPassStories.toList(),
    });
    stories.refresh();
  }

  List<Map<String, dynamic>> get filteredStories {
    return stories.where((story) {
      return story["type"] == selectedType.value;
    }).toList();
  }

  bool get isUnlocked {
    if (!Get.isRegistered<StarsService>()) return false;
    return StarsService.to.premiumStoriesUnlocked.value;
  }

  bool isStoryLocked(Map<String, dynamic> story) {
    if (story["isPremium"] != true) return false;
    if (PremiumService.active) return false;
    if (dayPassStories.contains(story["title"])) return false;
    final minStars = story["minStars"] as int? ?? 100;
    final currentStars = Get.isRegistered<StarsService>()
        ? StarsService.to.totalStars.value
        : 0;
    return currentStars < minStars;
  }

  void changeTab(String type) {
    selectedType.value = type;
  }

  void openStory(Map<String, dynamic> story) {
    if (isStoryLocked(story)) {
      _showLockedStoryDialog(story);
      return;
    }
    Get.toNamed(Routes.storyDetail, arguments: story);
  }

  void _showLockedStoryDialog(Map<String, dynamic> story) {
    final minStars = story["minStars"] as int? ?? 100;
    final currentStars = Get.isRegistered<StarsService>()
        ? StarsService.to.totalStars.value
        : 0;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔒', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 10),
              Text(
                story["title"] as String? ?? 'Locked Story',
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                    fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Earn $minStars ⭐ to unlock it forever.\nYou have $currentStars ⭐ — keep going!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 18),
              Obx(() {
                if (!RewardedAdService.instance.isLoadedRx.value) {
                  return const SizedBox.shrink();
                }
                return _lockedDialogButton(
                  // Must say "Ad" — "watch a video" hides that this launches an
                  // advertisement (Play Families ad-format requirement).
                  icon: Icons.play_circle_outline_rounded,
                  label: AppStrings.watchAdReadToday,
                  color: const Color(0xFF546E7A),
                  onTap: () {
                    Get.back();
                    RewardedAdService.instance.showAd(() {
                      _grantDayPass(story);
                      Get.toNamed(Routes.storyDetail, arguments: story);
                    });
                  },
                );
              }),
              const SizedBox(height: 8),
              _lockedDialogButton(
                icon: Icons.workspace_premium_rounded,
                label: 'Unlock everything (parents)',
                color: const Color(0xFF7B2FBE),
                onTap: () {
                  Get.back();
                  PremiumDialog.show();
                },
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: Get.back,
                child: Text(
                  'Not now',
                  style: GoogleFonts.nunito(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lockedDialogButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.aBeeZee(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}









// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../core/routes/routes.dart';
// import '../../core/services/stars_service.dart';
//
// class StoryModeController extends GetxController {
//   final selectedType = 'math'.obs;
//
//   final RxList<Map<String, dynamic>> stories = <Map<String, dynamic>>[
//     // your stories here
//   ].obs;
//
//   List<Map<String, dynamic>> get filteredStories {
//     return stories.where((story) {
//       if (story["type"] != selectedType.value) return false;
//       if (story["isPremium"] == true) {
//         return isStoryUnlocked();
//       }
//       return true;
//     }).toList();
//   }
//
//   bool isStoryUnlocked() {
//     if (Get.isRegistered<StarsService>()) {
//       return StarsService.to.arePremiumStoriesUnlocked();
//     }
//     return false;
//   }
//
//   void changeTab(String type) {
//     selectedType.value = type;
//   }
//
//   void openStory(Map<String, dynamic> story) {
//     if (story["isPremium"] == true && !isStoryUnlocked()) {
//       Get.snackbar(
//         '🔒 Story Locked',
//         'Complete 40 ⭐ stars to unlock this premium story!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: const Color(0xFF2C3E50),
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//       return;
//     }
//
//     Get.toNamed(Routes.storyDetail, arguments: story);
//   }
// }