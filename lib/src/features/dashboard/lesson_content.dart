part of 'package:learnova/main.dart';

int _builtInContentLevel(int requestedLevelNumber) {
  if (requestedLevelNumber <= 1) {
    return 1;
  }
  if (requestedLevelNumber == 2) {
    return 2;
  }
  return 3;
}

List<_LectureSlide> _lessonSlides(
  _SubjectKind kind,
  String lessonTitle,
  List<List<String>> slideData,
) {
  final List<List<String>> parts = slideData
      .map((List<String> item) {
        final String title = item.isNotEmpty ? item[0].trim() : lessonTitle;
        final String body = item.length > 1 ? item[1].trim() : '';
        final String example = item.length > 2 ? item[2].trim() : '';
        return <String>[title.isEmpty ? lessonTitle : title, body, example];
      })
      .where((List<String> item) => item[0].trim().isNotEmpty)
      .toList();

  if (parts.isEmpty) {
    return <_LectureSlide>[
      _lessonSlide(
        kind,
        0,
        title: lessonTitle,
        body: 'Let us learn one easy idea at a time.',
        example: 'Listen, look, and try your best.',
      ),
    ];
  }

  while (parts.length < 3) {
    parts.add(List<String>.from(parts.last));
  }

  final List<String> topicTitles = parts
      .take(3)
      .map((List<String> item) => item[0])
      .toList();
  final List<String> examples = parts
      .take(3)
      .map((List<String> item) => item[2].isEmpty ? item[0] : item[2])
      .toList();

  return <_LectureSlide>[
    _lessonSlide(
      kind,
      0,
      title: 'Welcome to $lessonTitle',
      body:
          'Today we will learn ${_joinLessonTopics(topicTitles)}. We will go step by step and keep it easy.',
      example: 'Start with: ${examples[0]}',
    ),
    _lessonSlide(
      kind,
      1,
      title: parts[0][0],
      body: parts[0][1],
      example: parts[0][2],
    ),
    _lessonSlide(
      kind,
      2,
      title: 'Practice ${parts[0][0]}',
      body: _practiceBody(kind, parts[0][0]),
      example: 'Try: ${examples[0]}',
    ),
    _lessonSlide(
      kind,
      3,
      title: parts[1][0],
      body: parts[1][1],
      example: parts[1][2],
    ),
    _lessonSlide(
      kind,
      4,
      title: 'Try ${parts[1][0]}',
      body: _practiceBody(kind, parts[1][0]),
      example: 'Now do this one: ${examples[1]}',
    ),
    _lessonSlide(
      kind,
      5,
      title: parts[2][0],
      body: parts[2][1],
      example: parts[2][2],
    ),
    _lessonSlide(
      kind,
      6,
      title: 'Think About ${parts[2][0]}',
      body: _reflectionBody(kind, parts[2][0]),
      example: 'Say it again: ${examples[2]}',
    ),
    _lessonSlide(
      kind,
      7,
      title: 'Quick Review',
      body:
          'We learned ${topicTitles[0]}, ${topicTitles[1]}, and ${topicTitles[2]}. Let us say each one again before the quiz.',
      example: 'Review: ${examples.join(' | ')}',
    ),
    _lessonSlide(
      kind,
      8,
      title: 'Remember the Big Idea',
      body: _rememberBody(kind, lessonTitle, topicTitles),
      example: 'Key words: ${topicTitles.join(', ')}',
    ),
    _lessonSlide(
      kind,
      9,
      title: 'Ready for the Quiz',
      body:
          'Great work. The quiz will ask about $lessonTitle, so read carefully and choose your best answer.',
      example: 'Focus on: ${topicTitles.join(', ')}',
    ),
  ];
}

_LectureSlide _lessonSlide(
  _SubjectKind kind,
  int index, {
  required String title,
  required String body,
  required String example,
}) {
  return _LectureSlide(
    title: title,
    body: body,
    example: example,
    icon: _lessonSlideIcon(kind, index),
    accentColor: _lessonSlideColor(kind, index),
  );
}

IconData _lessonSlideIcon(_SubjectKind kind, int index) {
  final List<IconData> icons = switch (kind) {
    _SubjectKind.english => const <IconData>[
      Icons.menu_book_rounded,
      Icons.hearing_rounded,
      Icons.edit_note_rounded,
      Icons.rate_review_rounded,
      Icons.auto_stories_rounded,
    ],
    _SubjectKind.math => const <IconData>[
      Icons.calculate_rounded,
      Icons.pin_rounded,
      Icons.functions_rounded,
      Icons.looks_one_rounded,
      Icons.quiz_rounded,
    ],
    _SubjectKind.gk => const <IconData>[
      Icons.public_rounded,
      Icons.travel_explore_rounded,
      Icons.eco_rounded,
      Icons.lightbulb_rounded,
      Icons.groups_rounded,
    ],
  };
  return icons[index % icons.length];
}

Color _lessonSlideColor(_SubjectKind kind, int index) {
  final Color base = _adminSubjectColor(kind);
  const List<double> mixes = <double>[0.0, 0.08, 0.16, 0.24, 0.12];
  return Color.lerp(base, Colors.white, mixes[index % mixes.length]) ?? base;
}

String _joinLessonTopics(List<String> titles) {
  if (titles.isEmpty) {
    return 'new ideas';
  }
  if (titles.length == 1) {
    return titles.first;
  }
  if (titles.length == 2) {
    return '${titles[0]} and ${titles[1]}';
  }
  return '${titles[0]}, ${titles[1]}, and ${titles[2]}';
}

String _practiceBody(_SubjectKind kind, String topic) {
  return switch (kind) {
    _SubjectKind.english =>
      'Read $topic slowly, say the sounds or words clearly, and try the example on your own.',
    _SubjectKind.math =>
      'Look at $topic, count or solve step by step, and then say the answer with confidence.',
    _SubjectKind.gk =>
      'Think about $topic, say the fact clearly, and connect it to something you know in real life.',
  };
}

String _reflectionBody(_SubjectKind kind, String topic) {
  return switch (kind) {
    _SubjectKind.english =>
      'Tell what you noticed about $topic and read the example one more time.',
    _SubjectKind.math =>
      'Explain how you solved $topic and check the answer carefully.',
    _SubjectKind.gk => 'Talk about where you can see $topic in daily life.',
  };
}

String _rememberBody(
  _SubjectKind kind,
  String lessonTitle,
  List<String> topicTitles,
) {
  final String topics = topicTitles.join(', ');
  return switch (kind) {
    _SubjectKind.english =>
      '$lessonTitle helps you read and speak with confidence. Remember these ideas: $topics.',
    _SubjectKind.math =>
      '$lessonTitle helps you solve small problems carefully. Remember these ideas: $topics.',
    _SubjectKind.gk =>
      '$lessonTitle helps you understand the world around you. Remember these ideas: $topics.',
  };
}

List<_QuizQuestion> _lessonQuiz(List<List<Object>> quizData) {
  return quizData.map((List<Object> item) {
    return _QuizQuestion(
      prompt: item[0] as String,
      options: <String>[
        item[1] as String,
        item[2] as String,
        item[3] as String,
        item[4] as String,
      ],
      correctIndex: item[5] as int,
      explanation: item[6] as String,
    );
  }).toList();
}

_LectureModule _lessonModule({
  required int levelNumber,
  required int stageNumber,
  required _SubjectKind kind,
  required String title,
  required List<List<String>> slides,
  required List<List<Object>> quiz,
}) {
  return _LectureModule(
    levelNumber: levelNumber,
    stageNumber: stageNumber,
    title: title,
    slides: _lessonSlides(kind, title, slides),
    quizQuestions: _lessonQuiz(quiz),
  );
}

List<_LectureModule> _builtInLessonModules(
  _SubjectKind kind,
  int requestedLevelNumber,
) {
  final int levelNumber = _builtInContentLevel(requestedLevelNumber);
  switch (levelNumber) {
    case 1:
      return _levelOneModules(kind);
    case 2:
      return _levelTwoModules(kind);
    default:
      return _levelThreeModules(kind);
  }
}

List<_LectureModule> _levelOneModules(_SubjectKind kind) {
  switch (kind) {
    case _SubjectKind.english:
      return _levelOneEnglishModules();
    case _SubjectKind.math:
      return _levelOneMathModules();
    case _SubjectKind.gk:
      return _levelOneGkModules();
  }
}

List<_LectureModule> _levelTwoModules(_SubjectKind kind) {
  switch (kind) {
    case _SubjectKind.english:
      return _levelTwoEnglishModules();
    case _SubjectKind.math:
      return _levelTwoMathModules();
    case _SubjectKind.gk:
      return _levelTwoGkModules();
  }
}

List<_LectureModule> _levelThreeModules(_SubjectKind kind) {
  switch (kind) {
    case _SubjectKind.english:
      return _levelThreeEnglishModules();
    case _SubjectKind.math:
      return _levelThreeMathModules();
    case _SubjectKind.gk:
      return _levelThreeGkModules();
  }
}

List<_LectureModule> _levelOneEnglishModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 1,
      stageNumber: 1,
      kind: _SubjectKind.english,
      title: 'Letters and Sounds',
      slides: const <List<String>>[
        <String>[
          'Meet A, B, and C',
          'A says a in apple. B says b in ball. C says c in cat.',
          'Say: apple, ball, cat',
        ],
        <String>[
          'Meet M, S, and T',
          'M says m in moon. S says s in sun. T says t in top.',
          'Say: moon, sun, top',
        ],
        <String>[
          'Listen to First Sounds',
          'The first sound helps us hear how a word begins.',
          'Which sound starts map? m',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word starts with A?',
          'apple',
          'sun',
          'top',
          'pen',
          0,
          'Apple starts with the A sound.',
        ],
        <Object>[
          'Which letter starts ball?',
          'C',
          'B',
          'T',
          'M',
          1,
          'Ball starts with B.',
        ],
        <Object>[
          'Which word starts with S?',
          'cat',
          'moon',
          'sun',
          'top',
          2,
          'Sun starts with S.',
        ],
        <Object>[
          'Which letter starts top?',
          'T',
          'A',
          'B',
          'C',
          0,
          'Top starts with T.',
        ],
        <Object>[
          'Which word starts with M?',
          'apple',
          'moon',
          'sun',
          'cat',
          1,
          'Moon starts with M.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 2,
      kind: _SubjectKind.english,
      title: 'Read Simple Words',
      slides: const <List<String>>[
        <String>[
          'Blend the Sounds',
          'Blend each sound together slowly to read a short word.',
          'c a t = cat',
        ],
        <String>[
          'Read CVC Words',
          'CVC words have a consonant, a vowel, and a consonant.',
          'sun, pen, map',
        ],
        <String>[
          'Say and Read',
          'Read the word, then say it in a clear voice.',
          'I can read: cat',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Blend c a t. Which word do you get?',
          'cat',
          'cot',
          'cup',
          'cap',
          0,
          'The sounds c a t blend to make cat.',
        ],
        <Object>[
          'Which word can you read here?',
          'sun',
          'runny',
          'stone',
          'school',
          0,
          'Sun is a short word from this lesson.',
        ],
        <Object>[
          'Which word has three sounds?',
          'map',
          'apple',
          'train',
          'yellow',
          0,
          'Map has m, a, and p.',
        ],
        <Object>[
          'Which word starts with p?',
          'sun',
          'pen',
          'cat',
          'top',
          1,
          'Pen starts with p.',
        ],
        <Object>[
          'Which short word ends with n?',
          'sun',
          'map',
          'cat',
          'top',
          0,
          'Sun ends with n.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 3,
      kind: _SubjectKind.english,
      title: 'Build Short Sentences',
      slides: const <List<String>>[
        <String>[
          'Start with a Capital',
          'A sentence starts with a capital letter.',
          'I can hop.',
        ],
        <String>[
          'Use a Full Stop',
          'A full stop shows the sentence has ended.',
          'Sam can run.',
        ],
        <String>[
          'Read a Full Sentence',
          'Read the whole sentence from start to end.',
          'I see the sun.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which sentence starts correctly?',
          'i can hop.',
          'I can hop.',
          'i Can hop.',
          'I Can Hop.',
          1,
          'A sentence starts with a capital I.',
        ],
        <Object>[
          'Which mark ends a telling sentence?',
          'Full stop',
          'Question mark',
          'Comma',
          'Colon',
          0,
          'A telling sentence ends with a full stop.',
        ],
        <Object>[
          'Which is a full sentence?',
          'sun',
          'run fast',
          'I see the sun.',
          'the cat',
          2,
          'I see the sun. is a complete sentence.',
        ],
        <Object>[
          'What comes first in a sentence?',
          'A number',
          'A capital letter',
          'A question mark',
          'A dash',
          1,
          'Sentences begin with a capital letter.',
        ],
        <Object>[
          'Which sentence has a full stop?',
          'I can read',
          'Can you jump?',
          'I can read.',
          'wow!',
          2,
          'I can read. ends with a full stop.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 4,
      kind: _SubjectKind.english,
      title: 'Short Vowel Sounds',
      slides: const <List<String>>[
        <String>[
          'Meet Short A and E',
          'Short a sounds like a in cat. Short e sounds like e in bed.',
          'cat, bed',
        ],
        <String>[
          'Meet Short I, O, and U',
          'Short i sounds like i in pig. Short o sounds like o in hot. Short u sounds like u in sun.',
          'pig, hot, sun',
        ],
        <String>[
          'Hear the Middle Sound',
          'The vowel sound is often in the middle of a short word.',
          'c-a-t, p-i-g, s-u-n',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word has the short a sound?',
          'cat',
          'bed',
          'pig',
          'sun',
          0,
          'Cat has the short a sound.',
        ],
        <Object>[
          'Which word has the short e sound?',
          'dog',
          'bed',
          'cup',
          'fish',
          1,
          'Bed has the short e sound.',
        ],
        <Object>[
          'Which word has the short i sound?',
          'pig',
          'boat',
          'rain',
          'moon',
          0,
          'Pig has the short i sound.',
        ],
        <Object>[
          'Which word has the short o sound?',
          'top',
          'seed',
          'cube',
          'kite',
          0,
          'Top has the short o sound.',
        ],
        <Object>[
          'Which word has the short u sound?',
          'sun',
          'cake',
          'tree',
          'goat',
          0,
          'Sun has the short u sound.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 5,
      kind: _SubjectKind.english,
      title: 'Word Families',
      slides: const <List<String>>[
        <String>[
          'Meet the -at Family',
          'Words in one family have the same ending sound.',
          'cat, hat, mat',
        ],
        <String>[
          'Meet the -an Family',
          'When the ending stays the same, only the first sound changes.',
          'can, fan, man',
        ],
        <String>[
          'Read Family Words Fast',
          'Reading by family helps you read new words more easily.',
          'hat and fan',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word belongs to the -at family?',
          'cat',
          'sun',
          'pen',
          'dog',
          0,
          'Cat ends with -at.',
        ],
        <Object>[
          'Which word belongs to the -an family?',
          'fan',
          'sit',
          'bed',
          'hop',
          0,
          'Fan ends with -an.',
        ],
        <Object>[
          'Which word rhymes with hat?',
          'mat',
          'pig',
          'bus',
          'ten',
          0,
          'Hat and mat are in the same family.',
        ],
        <Object>[
          'What ending do cat and mat share?',
          '-at',
          '-en',
          '-ig',
          '-op',
          0,
          'Both words end with -at.',
        ],
        <Object>[
          'Which family word can you read?',
          'man',
          'train',
          'school',
          'yellow',
          0,
          'Man is a simple -an family word.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 6,
      kind: _SubjectKind.english,
      title: 'Sight Words I Know',
      slides: const <List<String>>[
        <String>[
          'Read I, a, and the',
          'Some small words appear again and again in books.',
          'I, a, the',
        ],
        <String>[
          'Read see, can, and is',
          'We learn these words by seeing them many times.',
          'see, can, is',
        ],
        <String>[
          'Use Sight Words in Sentences',
          'Sight words help us read easy sentences smoothly.',
          'I can see the sun.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which one is a sight word from this lesson?',
          'the',
          'elephant',
          'blanket',
          'garden',
          0,
          'The is one of the sight words we practiced.',
        ],
        <Object>[
          'Which sentence uses sight words correctly?',
          'I can see the sun.',
          'Sun the can I.',
          'Can the sun I see.',
          'the I can sun.',
          0,
          'I can see the sun. reads correctly.',
        ],
        <Object>[
          'Which word comes in this lesson?',
          'see',
          'rocket',
          'purple',
          'winter',
          0,
          'See is one of the target sight words.',
        ],
        <Object>[
          'Which short word tells about one person speaking?',
          'I',
          'tree',
          'jump',
          'blue',
          0,
          'I is the word we use for ourselves.',
        ],
        <Object>[
          'Which word can finish the sentence: I can ___?',
          'see',
          'banana',
          'window',
          'purple',
          0,
          'I can see is a simple sentence from the lesson.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 7,
      kind: _SubjectKind.english,
      title: 'Names and Capital Letters',
      slides: const <List<String>>[
        <String>[
          'Capital Letters Start Names',
          'A person name begins with a capital letter.',
          'Ali, Sara, Dino',
        ],
        <String>[
          'Places Can Use Capitals Too',
          'A city or country name also begins with a capital letter.',
          'Lahore, Pakistan',
        ],
        <String>[
          'Check the First Letter',
          'When you read or write a name, check the first letter carefully.',
          'sara -> Sara',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which name starts correctly?',
          'ali',
          'Sara',
          'dino',
          'school',
          1,
          'Sara starts with a capital S.',
        ],
        <Object>[
          'What kind of letter starts a name?',
          'Small letter',
          'Capital letter',
          'Number',
          'Comma',
          1,
          'Names begin with capital letters.',
        ],
        <Object>[
          'Which one is written correctly?',
          'pakistan',
          'Pakistan',
          'pAkistan',
          'pakIstan',
          1,
          'Pakistan starts with a capital P.',
        ],
        <Object>[
          'How should you write dino as a name?',
          'dino',
          'Dino',
          'diNo',
          'DINo',
          1,
          'As a name, Dino starts with a capital D.',
        ],
        <Object>[
          'Which word is a person name?',
          'table',
          'Sara',
          'ball',
          'apple',
          1,
          'Sara is a person name.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 8,
      kind: _SubjectKind.english,
      title: 'Rhyming Words',
      slides: const <List<String>>[
        <String>[
          'Words That Sound Alike',
          'Rhyming words end with the same sound.',
          'cat, hat',
        ],
        <String>[
          'Listen to the Ending Sound',
          'When the ending sound matches, the words rhyme.',
          'sun, run',
        ],
        <String>[
          'Find the Rhyme',
          'Say each word slowly and listen to the last part.',
          'pig, wig',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word rhymes with cat?',
          'hat',
          'sun',
          'pen',
          'dog',
          0,
          'Hat and cat have the same ending sound.',
        ],
        <Object>[
          'Which word rhymes with sun?',
          'bag',
          'run',
          'bed',
          'fish',
          1,
          'Sun and run rhyme.',
        ],
        <Object>[
          'Which pair rhymes?',
          'pig and wig',
          'cat and bus',
          'ten and top',
          'moon and map',
          0,
          'Pig and wig share the same ending sound.',
        ],
        <Object>[
          'Which word does not rhyme with hat?',
          'mat',
          'bat',
          'sun',
          'cat',
          2,
          'Sun has a different ending sound.',
        ],
        <Object>[
          'Which word rhymes with pen?',
          'hen',
          'cup',
          'log',
          'sit',
          0,
          'Pen and hen rhyme.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 9,
      kind: _SubjectKind.english,
      title: 'Describing Words',
      slides: const <List<String>>[
        <String>[
          'Words Can Tell More',
          'Describing words tell us what someone or something is like.',
          'big ball, red apple',
        ],
        <String>[
          'See Size and Color',
          'Some words tell size and some words tell color.',
          'small cat, blue bag',
        ],
        <String>[
          'Use a Describing Word',
          'A good describing word helps the reader picture it clearly.',
          'The kite is red.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word tells color?',
          'red',
          'jump',
          'run',
          'sing',
          0,
          'Red tells us the color.',
        ],
        <Object>[
          'Which word tells size?',
          'small',
          'play',
          'look',
          'read',
          0,
          'Small tells us the size.',
        ],
        <Object>[
          'Which phrase has a describing word?',
          'red ball',
          'can run',
          'I see',
          'the sun',
          0,
          'Red describes the ball.',
        ],
        <Object>[
          'In "blue bag", which word is the describing word?',
          'blue',
          'bag',
          'both',
          'none',
          0,
          'Blue tells us more about the bag.',
        ],
        <Object>[
          'Which sentence tells more clearly?',
          'I have a ball.',
          'I have a big ball.',
          'I have.',
          'Ball I have.',
          1,
          'Big gives more information about the ball.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 10,
      kind: _SubjectKind.english,
      title: 'Read a Tiny Story',
      slides: const <List<String>>[
        <String>[
          'Meet a Tiny Story',
          'A tiny story has a beginning, a middle, and an ending.',
          'Ali has a red cap.',
        ],
        <String>[
          'Read One Line at a Time',
          'Read slowly and think about what is happening.',
          'He sees a cat.',
        ],
        <String>[
          'Tell the Main Idea',
          'After reading, say the big idea in your own words.',
          'Ali sees a cat while wearing his cap.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Who has a red cap in the story?',
          'Ali',
          'Sara',
          'Dino',
          'A teacher',
          0,
          'Ali is the one with the red cap.',
        ],
        <Object>[
          'What does Ali see?',
          'A bus',
          'A cat',
          'A kite',
          'A fish',
          1,
          'Ali sees a cat.',
        ],
        <Object>[
          'What color is the cap?',
          'Blue',
          'Green',
          'Red',
          'Yellow',
          2,
          'The story says the cap is red.',
        ],
        <Object>[
          'How should you read a tiny story?',
          'Very fast',
          'One line at a time',
          'Backwards',
          'Without looking',
          1,
          'Reading one line at a time helps you understand.',
        ],
        <Object>[
          'Which sentence matches the story?',
          'Ali has a red cap and sees a cat.',
          'Ali has a blue cap and sees a dog.',
          'Sara sees a cat.',
          'A cat has a cap.',
          0,
          'That sentence tells the same idea as the story.',
        ],
      ],
    ),
  ];
}

List<_LectureModule> _levelOneMathModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 1,
      stageNumber: 1,
      kind: _SubjectKind.math,
      title: 'Count to 10',
      slides: const <List<String>>[
        <String>[
          'Count 1 to 5',
          'Touch each object one time as you count.',
          '1, 2, 3, 4, 5',
        ],
        <String>[
          'Count 6 to 10',
          'Keep your count in order and do not skip a number.',
          '6, 7, 8, 9, 10',
        ],
        <String>[
          'Match Number to Count',
          'The number tells how many objects you have.',
          '3 apples means three apples',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which number comes after 4?',
          '3',
          '5',
          '6',
          '7',
          1,
          'Five comes after four.',
        ],
        <Object>[
          'How many fingers on one hand?',
          '4',
          '5',
          '6',
          '7',
          1,
          'One hand has five fingers.',
        ],
        <Object>[
          'Which number is bigger than 8?',
          '6',
          '7',
          '9',
          '5',
          2,
          'Nine is bigger than eight.',
        ],
        <Object>[
          'What number do you say first when counting?',
          '1',
          '2',
          '3',
          '4',
          0,
          'We start with one.',
        ],
        <Object>[
          'Which group has 3?',
          '1, 2, 3',
          '1, 2',
          '1, 2, 3, 4',
          '1',
          0,
          '1, 2, 3 shows three items.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 2,
      kind: _SubjectKind.math,
      title: 'Add Small Numbers',
      slides: const <List<String>>[
        <String>[
          'Addition Means Put Together',
          'When we add, we join groups to make a bigger group.',
          '2 + 1 = 3',
        ],
        <String>[
          'Use Fingers and Dots',
          'Count all the fingers or dots to find the answer.',
          '1 dot and 2 dots make 3 dots',
        ],
        <String>[
          'One More',
          'Adding one means the next number in counting order.',
          '4 and 1 more is 5',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What is 2 + 1?',
          '2',
          '3',
          '4',
          '5',
          1,
          'Two and one more make three.',
        ],
        <Object>[
          'What is 1 + 1?',
          '1',
          '2',
          '3',
          '4',
          1,
          'One plus one is two.',
        ],
        <Object>[
          'What is 3 + 1?',
          '3',
          '4',
          '5',
          '6',
          1,
          'Three and one more make four.',
        ],
        <Object>[
          'Which sum makes 5?',
          '2 + 1',
          '3 + 1',
          '4 + 1',
          '1 + 1',
          2,
          'Four plus one equals five.',
        ],
        <Object>[
          'If you have 2 balls and get 2 more, how many?',
          '2',
          '3',
          '4',
          '5',
          2,
          'Two and two make four.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 3,
      kind: _SubjectKind.math,
      title: 'Shapes and Patterns',
      slides: const <List<String>>[
        <String>[
          'Meet Basic Shapes',
          'A circle is round, a square has four equal sides, and a triangle has three sides.',
          'circle, square, triangle',
        ],
        <String>[
          'Big and Small',
          'We can compare shapes by size.',
          'big circle, small circle',
        ],
        <String>[
          'Make a Pattern',
          'A pattern repeats in the same order.',
          'circle, square, circle, square',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which shape is round?',
          'Circle',
          'Square',
          'Triangle',
          'Rectangle',
          0,
          'A circle is round.',
        ],
        <Object>[
          'How many sides does a triangle have?',
          '2',
          '3',
          '4',
          '5',
          1,
          'A triangle has three sides.',
        ],
        <Object>[
          'Which word tells size?',
          'small',
          'jump',
          'blue',
          'count',
          0,
          'Small tells us about size.',
        ],
        <Object>[
          'What comes next? circle, square, circle, ...',
          'triangle',
          'circle',
          'square',
          'star',
          2,
          'The pattern repeats with square.',
        ],
        <Object>[
          'Which shape has four equal sides?',
          'Square',
          'Circle',
          'Triangle',
          'Oval',
          0,
          'A square has four equal sides.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 4,
      kind: _SubjectKind.math,
      title: 'Count to 20',
      slides: const <List<String>>[
        <String>[
          'Count 11 to 15',
          'After 10, we keep counting in order one number at a time.',
          '11, 12, 13, 14, 15',
        ],
        <String>[
          'Count 16 to 20',
          'Keep your counting voice steady and do not skip any number.',
          '16, 17, 18, 19, 20',
        ],
        <String>[
          'Match Count and Number',
          'A number name and a group of objects should match.',
          '20 stars means twenty stars',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which number comes after 15?',
          '14',
          '16',
          '17',
          '18',
          1,
          'Sixteen comes right after fifteen.',
        ],
        <Object>[
          'Which number comes before 20?',
          '18',
          '17',
          '19',
          '16',
          2,
          'Nineteen comes before twenty.',
        ],
        <Object>[
          'Which number is bigger than 18?',
          '12',
          '16',
          '19',
          '14',
          2,
          'Nineteen is bigger than eighteen.',
        ],
        <Object>[
          'What number do you say after 11?',
          '10',
          '12',
          '13',
          '14',
          1,
          'Twelve comes after eleven.',
        ],
        <Object>[
          'Which group shows twenty?',
          '20',
          '15',
          '12',
          '9',
          0,
          'The number 20 means twenty.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 5,
      kind: _SubjectKind.math,
      title: 'Before, After, and Between',
      slides: const <List<String>>[
        <String>[
          'Before Means Earlier',
          'The number before comes just one step earlier in counting.',
          'Before 5 is 4',
        ],
        <String>[
          'After Means Next',
          'The number after comes just one step later.',
          'After 7 is 8',
        ],
        <String>[
          'Between Means In the Middle',
          'A number between sits in the middle of two numbers.',
          '6 is between 5 and 7',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What number comes before 6?',
          '5',
          '7',
          '8',
          '4',
          0,
          'Five comes before six.',
        ],
        <Object>[
          'What number comes after 8?',
          '6',
          '7',
          '9',
          '10',
          2,
          'Nine comes after eight.',
        ],
        <Object>[
          'Which number is between 2 and 4?',
          '1',
          '3',
          '5',
          '6',
          1,
          'Three is between two and four.',
        ],
        <Object>[
          'What comes before 10?',
          '8',
          '9',
          '11',
          '12',
          1,
          'Nine comes before ten.',
        ],
        <Object>[
          'What comes after 12?',
          '11',
          '13',
          '14',
          '10',
          1,
          'Thirteen comes after twelve.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 6,
      kind: _SubjectKind.math,
      title: 'Subtract Small Numbers',
      slides: const <List<String>>[
        <String>[
          'Take Away Means Subtract',
          'When we subtract, some objects go away from the group.',
          '5 - 1 = 4',
        ],
        <String>[
          'Count Back Carefully',
          'You can count back one step at a time to find the answer.',
          '6, 5, 4',
        ],
        <String>[
          'See What Is Left',
          'Look at how many objects are left after taking some away.',
          '3 apples, take 1, left 2',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What is 5 - 1?',
          '3',
          '4',
          '5',
          '6',
          1,
          'Five take away one equals four.',
        ],
        <Object>[
          'What is 4 - 2?',
          '1',
          '2',
          '3',
          '4',
          1,
          'Four take away two equals two.',
        ],
        <Object>[
          'If you have 3 balls and lose 1, how many are left?',
          '1',
          '2',
          '3',
          '4',
          1,
          'Three take away one leaves two.',
        ],
        <Object>[
          'What is 6 - 1?',
          '5',
          '4',
          '3',
          '2',
          0,
          'Six take away one equals five.',
        ],
        <Object>[
          'What does subtract mean?',
          'Put together',
          'Take away',
          'Color it',
          'Make it bigger',
          1,
          'Subtract means take away.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 7,
      kind: _SubjectKind.math,
      title: 'More, Less, and Same',
      slides: const <List<String>>[
        <String>[
          'More Means Bigger Group',
          'A group with more has a larger number of objects.',
          '5 apples is more than 3 apples',
        ],
        <String>[
          'Less Means Smaller Group',
          'A group with less has fewer objects.',
          '2 balls is less than 4 balls',
        ],
        <String>[
          'Same Means Equal Count',
          'If two groups match exactly, they are the same.',
          '3 stars and 3 stars',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which group has more?',
          '2 apples',
          '5 apples',
          '1 apple',
          '3 apples',
          1,
          'Five apples is the bigger group.',
        ],
        <Object>[
          'Which group has less?',
          '6 blocks',
          '4 blocks',
          '7 blocks',
          '8 blocks',
          1,
          'Four blocks is less than six, seven, and eight.',
        ],
        <Object>[
          'Which two groups are the same?',
          '3 balls and 2 balls',
          '4 stars and 4 stars',
          '5 books and 3 books',
          '2 pens and 1 pen',
          1,
          'Both groups have four stars.',
        ],
        <Object>[
          'Which number is less than 5?',
          '6',
          '7',
          '4',
          '8',
          2,
          'Four is less than five.',
        ],
        <Object>[
          'Which number is more than 3?',
          '2',
          '1',
          '3',
          '4',
          3,
          'Four is more than three.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 8,
      kind: _SubjectKind.math,
      title: 'Number Bonds to 10',
      slides: const <List<String>>[
        <String>[
          'Two Parts Can Make 10',
          'Some pairs join together to make ten.',
          '5 and 5 make 10',
        ],
        <String>[
          'Try Other Pairs',
          'Different pairs can still make the same whole number.',
          '6 and 4, 7 and 3',
        ],
        <String>[
          'Think Part and Whole',
          'If you know one part, you can find the missing part.',
          '8 and ? make 10',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which pair makes 10?',
          '5 and 5',
          '4 and 3',
          '2 and 1',
          '6 and 1',
          0,
          'Five and five make ten.',
        ],
        <Object>[
          'What goes with 6 to make 10?',
          '2',
          '3',
          '4',
          '5',
          2,
          'Six and four make ten.',
        ],
        <Object>[
          'What goes with 7 to make 10?',
          '1',
          '2',
          '3',
          '4',
          2,
          'Seven and three make ten.',
        ],
        <Object>[
          'What goes with 8 to make 10?',
          '1',
          '2',
          '3',
          '4',
          1,
          'Eight and two make ten.',
        ],
        <Object>[
          'What goes with 9 to make 10?',
          '1',
          '2',
          '3',
          '4',
          0,
          'Nine and one make ten.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 9,
      kind: _SubjectKind.math,
      title: 'Position and Size',
      slides: const <List<String>>[
        <String>[
          'Learn Position Words',
          'We can say where something is by using words like on, under, and next to.',
          'Book on table',
        ],
        <String>[
          'Compare Big and Small',
          'We also compare objects by size and length.',
          'big box, small box',
        ],
        <String>[
          'Look and Describe',
          'Math words help us describe where objects are and how they look.',
          'Ball under chair',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word tells position?',
          'under',
          'blue',
          'happy',
          'soft',
          0,
          'Under tells where something is.',
        ],
        <Object>[
          'Which word tells size?',
          'big',
          'jump',
          'count',
          'write',
          0,
          'Big tells the size.',
        ],
        <Object>[
          'If the ball is under the table, where is it?',
          'On the table',
          'Under the table',
          'In the sky',
          'Beside the moon',
          1,
          'Under the table is the correct position.',
        ],
        <Object>[
          'Which box is larger?',
          'Big box',
          'Small box',
          'Tiny box',
          'Short box',
          0,
          'Big means larger.',
        ],
        <Object>[
          'Which sentence uses a position word?',
          'The cat is under the chair.',
          'The cat is fluffy.',
          'The cat is sleepy.',
          'The cat is orange.',
          0,
          'Under is the position word.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 10,
      kind: _SubjectKind.math,
      title: 'Easy Word Problems',
      slides: const <List<String>>[
        <String>[
          'Listen to the Story',
          'A word problem is a small math story with numbers.',
          'Ali has 2 apples.',
        ],
        <String>[
          'Choose Add or Take Away',
          'Think carefully about whether the story is joining or taking away.',
          '2 apples and 1 more',
        ],
        <String>[
          'Find the Answer',
          'Use counting, fingers, or pictures to solve the story.',
          '2 + 1 = 3',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Ali has 2 apples and gets 1 more. How many now?',
          '2',
          '3',
          '4',
          '5',
          1,
          'Two and one more make three.',
        ],
        <Object>[
          'Sara has 4 balloons. One flies away. How many are left?',
          '2',
          '3',
          '4',
          '5',
          1,
          'Four take away one leaves three.',
        ],
        <Object>[
          'There are 3 birds on a tree. 2 more come. How many birds are there?',
          '4',
          '5',
          '6',
          '3',
          1,
          'Three plus two equals five.',
        ],
        <Object>[
          'You have 5 pencils. You give 2 away. How many remain?',
          '2',
          '3',
          '4',
          '5',
          1,
          'Five minus two equals three.',
        ],
        <Object>[
          'What should you do first in a word problem?',
          'Guess fast',
          'Read the story carefully',
          'Close your eyes',
          'Skip the numbers',
          1,
          'Read the story carefully first.',
        ],
      ],
    ),
  ];
}

List<_LectureModule> _levelOneGkModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 1,
      stageNumber: 1,
      kind: _SubjectKind.gk,
      title: 'My Body and Senses',
      slides: const <List<String>>[
        <String>[
          'Body Parts',
          'Your eyes, ears, nose, hands, and feet help you every day.',
          'I see with my eyes.',
        ],
        <String>[
          'Five Senses',
          'We see, hear, smell, taste, and touch to learn about the world.',
          'I hear with my ears.',
        ],
        <String>[
          'Keep Clean',
          'Wash hands and brush teeth to keep your body healthy.',
          'Wash hands before eating.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which body part helps you see?',
          'Eyes',
          'Nose',
          'Hands',
          'Feet',
          0,
          'We see with our eyes.',
        ],
        <Object>[
          'Which body part helps you hear?',
          'Ears',
          'Teeth',
          'Hair',
          'Elbow',
          0,
          'We hear with our ears.',
        ],
        <Object>[
          'Which sense uses your nose?',
          'Smell',
          'Touch',
          'Taste',
          'See',
          0,
          'Your nose helps you smell.',
        ],
        <Object>[
          'What should you do before eating?',
          'Wash hands',
          'Run outside',
          'Jump high',
          'Sleep',
          0,
          'Clean hands help keep you healthy.',
        ],
        <Object>[
          'Which body part helps you walk?',
          'Feet',
          'Eyes',
          'Ears',
          'Nose',
          0,
          'We walk with our feet.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 2,
      kind: _SubjectKind.gk,
      title: 'Family and Helpers',
      slides: const <List<String>>[
        <String>[
          'People in a Family',
          'Families can have parents, grandparents, brothers, and sisters.',
          'My family helps me.',
        ],
        <String>[
          'Community Helpers',
          'A doctor helps us stay healthy and a teacher helps us learn.',
          'A teacher works in school.',
        ],
        <String>[
          'Kind Actions',
          'Kind words and helping hands make family and school happy.',
          'I share my toys.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Who helps you learn in school?',
          'Teacher',
          'Chef',
          'Driver',
          'Farmer',
          0,
          'A teacher helps children learn.',
        ],
        <Object>[
          'Who helps when you are sick?',
          'Doctor',
          'Pilot',
          'Tailor',
          'Painter',
          0,
          'A doctor helps when we are sick.',
        ],
        <Object>[
          'Which is a kind action?',
          'Sharing',
          'Shouting',
          'Pushing',
          'Breaking',
          0,
          'Sharing is a kind action.',
        ],
        <Object>[
          'Where does a teacher work?',
          'School',
          'Beach',
          'Farm',
          'Zoo',
          0,
          'Teachers work in school.',
        ],
        <Object>[
          'A family helps us feel...',
          'safe',
          'lost',
          'empty',
          'tiny',
          0,
          'Family helps us feel safe and loved.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 3,
      kind: _SubjectKind.gk,
      title: 'Animals and Homes',
      slides: const <List<String>>[
        <String>[
          'Farm and Wild Animals',
          'Some animals live on farms and some live in forests or seas.',
          'Cow on a farm, lion in a forest',
        ],
        <String>[
          'Animal Homes',
          'Birds live in nests and bees live in hives.',
          'bird -> nest',
        ],
        <String>[
          'Care for Animals',
          'Animals need food, water, shelter, and care.',
          'Give clean water to a pet.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Where does a bird live?',
          'Nest',
          'Den',
          'Cave',
          'School',
          0,
          'A bird lives in a nest.',
        ],
        <Object>[
          'Which animal can live on a farm?',
          'Cow',
          'Shark',
          'Whale',
          'Octopus',
          0,
          'A cow can live on a farm.',
        ],
        <Object>[
          'What do animals need?',
          'Food and water',
          'Phones',
          'Shoes',
          'Books only',
          0,
          'Animals need food, water, and shelter.',
        ],
        <Object>[
          'Where do bees live?',
          'Hive',
          'Nest',
          'Pond',
          'Bag',
          0,
          'Bees live in a hive.',
        ],
        <Object>[
          'Which is a wild animal?',
          'Lion',
          'Cow',
          'Goat',
          'Hen',
          0,
          'A lion is a wild animal.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 4,
      kind: _SubjectKind.gk,
      title: 'Healthy Food and Water',
      slides: const <List<String>>[
        <String>[
          'Foods That Help Us Grow',
          'Fruits, vegetables, milk, and eggs help our bodies grow strong.',
          'apple, carrot, milk',
        ],
        <String>[
          'Drink Clean Water',
          'Water helps our body stay fresh and active.',
          'Drink water after play.',
        ],
        <String>[
          'Choose Healthy Snacks',
          'Healthy food gives us energy to study and play.',
          'banana instead of too much candy',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which food is healthy?',
          'Apple',
          'Stone',
          'Toy',
          'Pencil',
          0,
          'Apple is a healthy food.',
        ],
        <Object>[
          'What should we drink every day?',
          'Water',
          'Paint',
          'Juice only',
          'Soap',
          0,
          'Water helps keep us healthy.',
        ],
        <Object>[
          'Which one is a vegetable?',
          'Carrot',
          'Ball',
          'Chair',
          'Clock',
          0,
          'Carrot is a vegetable.',
        ],
        <Object>[
          'Why do we eat healthy food?',
          'To feel sleepy',
          'To grow strong',
          'To lose our books',
          'To break toys',
          1,
          'Healthy food helps us grow strong.',
        ],
        <Object>[
          'When is water a good choice?',
          'After play',
          'Instead of washing hands',
          'Only once a week',
          'Never',
          0,
          'Water is a good drink after play.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 5,
      kind: _SubjectKind.gk,
      title: 'Home and School Places',
      slides: const <List<String>>[
        <String>[
          'Rooms at Home',
          'A home can have a bedroom, kitchen, and living room.',
          'I sleep in the bedroom.',
        ],
        <String>[
          'Places in School',
          'A school can have a classroom, library, and playground.',
          'I read in the library.',
        ],
        <String>[
          'Use Each Place Well',
          'Different places help us do different jobs.',
          'I play in the playground.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Where do you sleep at home?',
          'Bedroom',
          'Playground',
          'Library',
          'Road',
          0,
          'We usually sleep in the bedroom.',
        ],
        <Object>[
          'Where do children read books in school?',
          'Kitchen',
          'Library',
          'Bus stop',
          'Garden',
          1,
          'The library is for reading books.',
        ],
        <Object>[
          'Where do children play in school?',
          'Playground',
          'Bathroom',
          'Bedroom',
          'Kitchen',
          0,
          'Children play in the playground.',
        ],
        <Object>[
          'Which place is in a home?',
          'Bedroom',
          'Classroom only',
          'Bus stand',
          'Traffic light',
          0,
          'Bedroom is a room at home.',
        ],
        <Object>[
          'Which place is in a school?',
          'Library',
          'Garage',
          'Kitchen garden only',
          'Pond',
          0,
          'A library can be part of a school.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 6,
      kind: _SubjectKind.gk,
      title: 'Plants Around Us',
      slides: const <List<String>>[
        <String>[
          'Plants Need Care',
          'Plants need water, sunlight, air, and soil to grow.',
          'Water the plant gently.',
        ],
        <String>[
          'Parts of a Plant',
          'Many plants have roots, stems, leaves, and flowers.',
          'leaf, stem, flower',
        ],
        <String>[
          'Why Plants Matter',
          'Plants give us beauty, shade, fruits, and fresh air.',
          'Trees give shade.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What do plants need to grow?',
          'Water and sunlight',
          'Shoes and bags',
          'Phones and toys',
          'Only paint',
          0,
          'Plants need water and sunlight.',
        ],
        <Object>[
          'Which is a part of a plant?',
          'Leaf',
          'Wheel',
          'Book',
          'Spoon',
          0,
          'A leaf is part of a plant.',
        ],
        <Object>[
          'Which plant part can be a flower?',
          'Flower',
          'Window',
          'Plate',
          'Pillow',
          0,
          'Flower is one part of a plant.',
        ],
        <Object>[
          'What can trees give us?',
          'Shade',
          'Traffic lights',
          'Shoes',
          'Television',
          0,
          'Trees can give us cool shade.',
        ],
        <Object>[
          'What should we do for plants?',
          'Care for them',
          'Pull all leaves off',
          'Hide them',
          'Throw them away',
          0,
          'Plants need care to stay healthy.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 7,
      kind: _SubjectKind.gk,
      title: 'Weather and Clothes',
      slides: const <List<String>>[
        <String>[
          'Sunny, Rainy, and Windy',
          'Weather can change from day to day.',
          'sunny day, rainy day',
        ],
        <String>[
          'Choose the Right Clothes',
          'We wear clothes that match the weather.',
          'raincoat in rain, sweater in cold weather',
        ],
        <String>[
          'Look Outside and Decide',
          'When we notice the weather, we can prepare well.',
          'Use an umbrella in rain.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which weather may need an umbrella?',
          'Rainy',
          'Sunny',
          'Cloudless night',
          'Windy only',
          0,
          'An umbrella helps in rainy weather.',
        ],
        <Object>[
          'What can you wear on a cold day?',
          'Sweater',
          'Swimsuit',
          'Rain boots only',
          'School bag',
          0,
          'A sweater helps keep us warm.',
        ],
        <Object>[
          'Which weather word fits a bright sun?',
          'Sunny',
          'Rainy',
          'Snowy',
          'Stormy',
          0,
          'A bright sun means sunny weather.',
        ],
        <Object>[
          'What should you use in rain?',
          'Umbrella',
          'Pillow',
          'Brush',
          'Plate',
          0,
          'An umbrella helps keep us dry.',
        ],
        <Object>[
          'Why do we check the weather?',
          'To choose well',
          'To forget our clothes',
          'To lose time',
          'To skip school forever',
          0,
          'Weather helps us decide what to wear and do.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 8,
      kind: _SubjectKind.gk,
      title: 'Transport Around Us',
      slides: const <List<String>>[
        <String>[
          'Road, Air, and Water Transport',
          'We travel in different ways on land, in air, and on water.',
          'car, plane, boat',
        ],
        <String>[
          'Each Vehicle Has a Job',
          'Some vehicles are for short trips and some for long trips.',
          'bus for road travel',
        ],
        <String>[
          'Travel Safely',
          'We travel safely by listening to adults and following simple rules.',
          'Sit properly in the bus.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which vehicle flies in the air?',
          'Plane',
          'Boat',
          'Bus',
          'Bicycle',
          0,
          'A plane travels in the air.',
        ],
        <Object>[
          'Which vehicle travels on water?',
          'Boat',
          'Train',
          'Car',
          'Van',
          0,
          'A boat moves on water.',
        ],
        <Object>[
          'Which vehicle travels on the road?',
          'Bus',
          'Boat',
          'Plane',
          'Ship',
          0,
          'A bus travels on the road.',
        ],
        <Object>[
          'Which is a land transport?',
          'Car',
          'Ship',
          'Plane',
          'Submarine',
          0,
          'A car is land transport.',
        ],
        <Object>[
          'What should children do while traveling?',
          'Sit safely',
          'Jump around',
          'Open every door',
          'Stand on seats',
          0,
          'Sitting safely is the correct choice.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 9,
      kind: _SubjectKind.gk,
      title: 'Good Habits and Safety',
      slides: const <List<String>>[
        <String>[
          'Good Habits Every Day',
          'Good habits include brushing teeth, washing hands, and speaking kindly.',
          'Brush in the morning and at night.',
        ],
        <String>[
          'Safety at Home and Outside',
          'Simple rules help us stay safe at home, school, and on the road.',
          'Do not touch hot things.',
        ],
        <String>[
          'Ask for Help',
          'If something feels unsafe, tell a trusted adult right away.',
          'Tell a parent or teacher.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which is a good habit?',
          'Washing hands',
          'Throwing books',
          'Shouting at friends',
          'Running on wet floors',
          0,
          'Washing hands is a good habit.',
        ],
        <Object>[
          'What should you do with hot things?',
          'Touch them quickly',
          'Stay careful and ask an adult',
          'Throw water at once',
          'Hide them',
          1,
          'Hot things can hurt, so ask an adult.',
        ],
        <Object>[
          'Who can help when something feels unsafe?',
          'A trusted adult',
          'Only a toy',
          'Nobody',
          'A pillow',
          0,
          'A trusted adult can help keep you safe.',
        ],
        <Object>[
          'When should you wash hands?',
          'Before eating',
          'Only once a month',
          'Never',
          'After hiding',
          0,
          'We wash hands before eating.',
        ],
        <Object>[
          'Which action is safe?',
          'Walking carefully',
          'Pushing on stairs',
          'Playing with fire',
          'Touching sharp tools',
          0,
          'Walking carefully is a safe action.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 1,
      stageNumber: 10,
      kind: _SubjectKind.gk,
      title: 'Day and Night',
      slides: const <List<String>>[
        <String>[
          'Day Is Bright',
          'In the day we often see the sun and do many activities.',
          'We go to school in the day.',
        ],
        <String>[
          'Night Is Darker',
          'At night we often see the moon and stars in the sky.',
          'We sleep at night.',
        ],
        <String>[
          'Our Day Has Both',
          'Day and night come again and again as time passes.',
          'sun for day, moon for night',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What do we often see in the day sky?',
          'Sun',
          'Moon only',
          'Stars only',
          'Fireworks only',
          0,
          'The sun is usually seen in the day.',
        ],
        <Object>[
          'What do we often see at night?',
          'Moon',
          'School bus only',
          'Sun',
          'Rainbow',
          0,
          'The moon is often seen at night.',
        ],
        <Object>[
          'When do many children sleep?',
          'At night',
          'At lunch only',
          'In the playground',
          'Only in the morning',
          0,
          'Night is the usual sleep time.',
        ],
        <Object>[
          'Which word matches the sun?',
          'Day',
          'Night',
          'Bed',
          'Raincoat',
          0,
          'The sun matches day.',
        ],
        <Object>[
          'Which pair is correct?',
          'Sun-day, moon-night',
          'Sun-night, moon-day',
          'Moon-school, sun-bed',
          'Day-moon only',
          0,
          'Sun is linked with day and moon with night.',
        ],
      ],
    ),
  ];
}

List<_LectureModule> _levelTwoEnglishModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 2,
      stageNumber: 1,
      kind: _SubjectKind.english,
      title: 'Vowels and Word Families',
      slides: const <List<String>>[
        <String>[
          'Short Vowel Sounds',
          'Short vowels help us read many small words.',
          'a in cat, e in bed',
        ],
        <String>[
          'Word Families',
          'Words in the same family share the same ending pattern.',
          'cat, hat, mat',
        ],
        <String>[
          'Change the First Sound',
          'Change the first sound to make a new word.',
          'cat -> bat',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word is in the -at family?',
          'mat',
          'sun',
          'pen',
          'dog',
          0,
          'Mat is in the -at family.',
        ],
        <Object>[
          'Which vowel do you hear in bed?',
          'a',
          'e',
          'i',
          'o',
          1,
          'Bed uses the short e sound.',
        ],
        <Object>[
          'Change c in cat to h. What new word do you get?',
          'hat',
          'hot',
          'hit',
          'hut',
          0,
          'Cat becomes hat.',
        ],
        <Object>[
          'Which word shares the same ending as hat?',
          'mat',
          'hen',
          'run',
          'sun',
          0,
          'Hat and mat share the ending -at.',
        ],
        <Object>[
          'Which word has the short i sound?',
          'pig',
          'boat',
          'cake',
          'cube',
          0,
          'Pig has the short i sound.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 2,
      stageNumber: 2,
      kind: _SubjectKind.english,
      title: 'Describing and Asking',
      slides: const <List<String>>[
        <String>[
          'Describing Words',
          'Describing words tell how something looks, feels, or sounds.',
          'a big red kite',
        ],
        <String>[
          'Question Words',
          'Who, what, and where help us ask clear questions.',
          'Where is the ball?',
        ],
        <String>[
          'Answer in a Full Sentence',
          'A full sentence gives a clear answer.',
          'The ball is on the table.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word describes the ball in "a red ball"?',
          'red',
          'ball',
          'a',
          'is',
          0,
          'Red describes the ball.',
        ],
        <Object>[
          'Which question word asks about a place?',
          'Who',
          'What',
          'Where',
          'When',
          2,
          'Where asks about a place.',
        ],
        <Object>[
          'Which is a full answer?',
          'table',
          'On the table.',
          'The ball is on the table.',
          'Where?',
          2,
          'The ball is on the table. is a full sentence.',
        ],
        <Object>[
          'Which word describes size?',
          'big',
          'run',
          'table',
          'where',
          0,
          'Big tells size.',
        ],
        <Object>[
          'Which question is correct?',
          'Where is your bag?',
          'Bag where your is?',
          'Is where bag your?',
          'Your bag where is',
          0,
          'Where is your bag? is the correct question.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 2,
      stageNumber: 3,
      kind: _SubjectKind.english,
      title: 'Reading Order and Story Parts',
      slides: const <List<String>>[
        <String>[
          'First, Next, Last',
          'Sequence words tell the order of events.',
          'First wash, next dry, last fold',
        ],
        <String>[
          'Beginning, Middle, End',
          'Stories have a start, something happens, and then an ending.',
          'beginning -> middle -> end',
        ],
        <String>[
          'Main Idea',
          'The main idea tells what the reading is mostly about.',
          'Main idea: We should share.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word tells the first step?',
          'next',
          'last',
          'first',
          'after',
          2,
          'First tells the first step.',
        ],
        <Object>[
          'A story has a beginning, middle, and ...',
          'question',
          'end',
          'number',
          'sound',
          1,
          'Stories have a beginning, middle, and end.',
        ],
        <Object>[
          'What does the main idea tell you?',
          'What the reading is mostly about',
          'Only one hard word',
          'The color of the page',
          'The page number',
          0,
          'The main idea tells the big message.',
        ],
        <Object>[
          'Which word tells the final step?',
          'first',
          'last',
          'next',
          'who',
          1,
          'Last tells the final step.',
        ],
        <Object>[
          'Which order is correct?',
          'middle, beginning, end',
          'beginning, end, middle',
          'beginning, middle, end',
          'end, first, next',
          2,
          'Stories follow beginning, middle, end.',
        ],
      ],
    ),
  ];
}

List<_LectureModule> _levelTwoMathModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 2,
      stageNumber: 1,
      kind: _SubjectKind.math,
      title: 'Numbers to 50',
      slides: const <List<String>>[
        <String>[
          'Tens and Ones',
          'A two-digit number has tens and ones.',
          '23 = 2 tens and 3 ones',
        ],
        <String>[
          'Before and After',
          'Look at the number before and after to keep order.',
          '19, 20, 21',
        ],
        <String>[
          'Read Number Names',
          'Read numbers clearly using tens and ones together.',
          '34 is thirty-four',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'How many tens in 23?',
          '1',
          '2',
          '3',
          '4',
          1,
          '23 has 2 tens.',
        ],
        <Object>[
          'What number comes after 29?',
          '28',
          '30',
          '31',
          '39',
          1,
          'Thirty comes after twenty-nine.',
        ],
        <Object>[
          'How many ones in 45?',
          '4',
          '5',
          '6',
          '9',
          1,
          '45 has 5 ones.',
        ],
        <Object>[
          'Which number is bigger?',
          '18',
          '24',
          '12',
          '19',
          1,
          '24 is bigger than the other numbers listed.',
        ],
        <Object>[
          'What is 34 called?',
          'forty-three',
          'thirty-four',
          'thirteen-four',
          'three-four',
          1,
          '34 is read as thirty-four.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 2,
      stageNumber: 2,
      kind: _SubjectKind.math,
      title: 'Subtract and Compare',
      slides: const <List<String>>[
        <String>[
          'Take Away',
          'Subtraction means taking away from a group.',
          '7 - 2 = 5',
        ],
        <String>[
          'Count Back',
          'Count back one step at a time to subtract.',
          '9, 8, 7',
        ],
        <String>[
          'More and Less',
          'Compare numbers to tell which is more or less.',
          '9 is more than 6',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What is 7 - 2?',
          '4',
          '5',
          '6',
          '7',
          1,
          'Seven take away two equals five.',
        ],
        <Object>[
          'What is 10 - 1?',
          '8',
          '9',
          '10',
          '11',
          1,
          'Ten take away one equals nine.',
        ],
        <Object>[
          'Which number is less?',
          '12',
          '15',
          '9',
          '14',
          2,
          '9 is less than the others.',
        ],
        <Object>[
          'Count back from 8 by one step. What number do you say?',
          '9',
          '7',
          '6',
          '5',
          1,
          'One step back from 8 is 7.',
        ],
        <Object>[
          'Which is more?',
          '6',
          '4',
          '2',
          '1',
          0,
          '6 is more than the other numbers listed.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 2,
      stageNumber: 3,
      kind: _SubjectKind.math,
      title: 'Time, Money, and Patterns',
      slides: const <List<String>>[
        <String>[
          'Read O Clock Time',
          'When the minute hand is at 12, we read an o clock time.',
          '3:00 is three o clock',
        ],
        <String>[
          'Know Simple Coins',
          'A 5-value coin and a 10-value coin help us count money.',
          '5 + 5 = 10',
        ],
        <String>[
          'Growing Patterns',
          'A pattern can repeat or grow by adding more each time.',
          '2, 4, 6, 8',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What time is 4:00?',
          'four o clock',
          'five o clock',
          'six o clock',
          'seven o clock',
          0,
          '4:00 is four o clock.',
        ],
        <Object>[
          'Two 5-value coins make...',
          '5',
          '8',
          '10',
          '15',
          2,
          'Five and five make ten.',
        ],
        <Object>[
          'What comes next? 2, 4, 6, ...',
          '7',
          '8',
          '9',
          '10',
          1,
          'The pattern grows by 2, so 8 comes next.',
        ],
        <Object>[
          'Which clock time is an o clock time?',
          '3:00',
          '3:30',
          '3:15',
          '3:45',
          0,
          '3:00 is an o clock time.',
        ],
        <Object>[
          'Which number pattern is correct?',
          '1, 3, 5, 7',
          '1, 3, 4, 7',
          '2, 3, 5, 6',
          '4, 4, 5, 7',
          0,
          '1, 3, 5, 7 grows by 2 each time.',
        ],
      ],
    ),
  ];
}

List<_LectureModule> _levelTwoGkModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 2,
      stageNumber: 1,
      kind: _SubjectKind.gk,
      title: 'Plants and Weather',
      slides: const <List<String>>[
        <String>[
          'What Plants Need',
          'Plants need water, sunlight, air, and soil to grow.',
          'Water the plant every day.',
        ],
        <String>[
          'Sunny, Rainy, Windy',
          'Weather changes from day to day.',
          'Sunny day, rainy day',
        ],
        <String>[
          'Dress for Weather',
          'We choose clothes that match the weather.',
          'Raincoat on a rainy day',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What does a plant need to grow?',
          'Water',
          'Candy',
          'Plastic',
          'Dust only',
          0,
          'Plants need water to grow.',
        ],
        <Object>[
          'Which weather brings rain?',
          'Rainy',
          'Sunny',
          'Dry',
          'Quiet',
          0,
          'Rainy weather brings rain.',
        ],
        <Object>[
          'What should you wear on a rainy day?',
          'Raincoat',
          'Swimsuit',
          'Sandals only',
          'Sunhat only',
          0,
          'A raincoat helps keep you dry.',
        ],
        <Object>[
          'Which helps a plant make food?',
          'Sunlight',
          'Television',
          'Shoes',
          'Pillow',
          0,
          'Plants need sunlight.',
        ],
        <Object>[
          'Which weather word matches a bright sky?',
          'Sunny',
          'Rainy',
          'Stormy',
          'Cloudy and dark',
          0,
          'A bright sky is sunny.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 2,
      stageNumber: 2,
      kind: _SubjectKind.gk,
      title: 'Home, School, and Community',
      slides: const <List<String>>[
        <String>[
          'Places at Home',
          'Each room has a use, like sleeping, cooking, or eating.',
          'Kitchen for cooking',
        ],
        <String>[
          'Places at School',
          'The classroom, library, and playground help us learn and play.',
          'We read in the library.',
        ],
        <String>[
          'Helpers in Town',
          'Police officers, firefighters, and nurses help the community.',
          'A firefighter keeps us safe.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Where do we cook food at home?',
          'Kitchen',
          'Bedroom',
          'Garage',
          'Roof',
          0,
          'We cook in the kitchen.',
        ],
        <Object>[
          'Where do we read many books in school?',
          'Library',
          'Playground',
          'Gate',
          'Bus stop',
          0,
          'We read books in the library.',
        ],
        <Object>[
          'Who helps during a fire?',
          'Firefighter',
          'Pilot',
          'Tailor',
          'Singer',
          0,
          'A firefighter helps during a fire.',
        ],
        <Object>[
          'Where do students learn lessons?',
          'Classroom',
          'Bathroom',
          'Garden',
          'Market',
          0,
          'Students learn in the classroom.',
        ],
        <Object>[
          'Who helps keep roads safe?',
          'Police officer',
          'Painter',
          'Farmer',
          'Chef',
          0,
          'Police officers help keep roads and people safe.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 2,
      stageNumber: 3,
      kind: _SubjectKind.gk,
      title: 'Safety and Healthy Habits',
      slides: const <List<String>>[
        <String>[
          'Road Safety',
          'Look left and right before crossing a road.',
          'Cross with an adult.',
        ],
        <String>[
          'Good Food and Water',
          'Healthy food and clean water help our bodies grow strong.',
          'Drink clean water every day.',
        ],
        <String>[
          'Daily Healthy Routine',
          'Sleep on time, brush teeth, and wash hands daily.',
          'Brush in the morning and at night.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What should you do before crossing a road?',
          'Look left and right',
          'Run fast',
          'Close your eyes',
          'Jump high',
          0,
          'We should look left and right first.',
        ],
        <Object>[
          'What helps your body stay healthy?',
          'Clean water',
          'Only candy',
          'Skipping sleep',
          'No breakfast',
          0,
          'Clean water helps the body stay healthy.',
        ],
        <Object>[
          'When should you brush your teeth?',
          'Morning and night',
          'Once a week',
          'Only after lunch',
          'Never',
          0,
          'Brushing morning and night is a healthy habit.',
        ],
        <Object>[
          'Who should help young children cross the road?',
          'An adult',
          'No one',
          'A toy',
          'A pet',
          0,
          'An adult should help children cross safely.',
        ],
        <Object>[
          'Which food choice is healthy?',
          'Fruit',
          'Only chips',
          'Only soda',
          'Only candy',
          0,
          'Fruit is a healthy food choice.',
        ],
      ],
    ),
  ];
}

List<_LectureModule> _levelThreeEnglishModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 3,
      stageNumber: 1,
      kind: _SubjectKind.english,
      title: 'Sentence Types and Punctuation',
      slides: const <List<String>>[
        <String>[
          'Tell, Ask, Exclaim',
          'A sentence can tell, ask, or show strong feeling.',
          'I can read. Can you read? Wow!',
        ],
        <String>[
          'Use the Right Mark',
          'A full stop, question mark, or exclamation mark matches the sentence type.',
          'Do you like books?',
        ],
        <String>[
          'Names Need Capitals',
          'Names of people and places start with capital letters.',
          'Sara lives in Lahore.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which mark ends a question?',
          'Full stop',
          'Question mark',
          'Comma',
          'Dash',
          1,
          'A question mark ends a question.',
        ],
        <Object>[
          'Which sentence shows excitement?',
          'I like books.',
          'Do you like books?',
          'I won!',
          'Books are fun',
          2,
          'I won! shows excitement.',
        ],
        <Object>[
          'Which name starts correctly?',
          'sara',
          'Sara',
          'sAra',
          'saRa',
          1,
          'Names begin with capital letters.',
        ],
        <Object>[
          'Which is a telling sentence?',
          'Do you run?',
          'I run.',
          'Run!',
          'Where are you?',
          1,
          'I run. tells something.',
        ],
        <Object>[
          'What mark fits "What a fun day"',
          'Question mark',
          'Exclamation mark',
          'Comma',
          'Colon',
          1,
          'This sentence shows strong feeling, so it needs an exclamation mark.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 3,
      stageNumber: 2,
      kind: _SubjectKind.english,
      title: 'Tenses and Sequence',
      slides: const <List<String>>[
        <String>[
          'Now, Yesterday, Tomorrow',
          'Present is now, past is yesterday, and future is tomorrow.',
          'I play. I played. I will play.',
        ],
        <String>[
          'Sequence Words',
          'First, next, then, and last tell the order of steps.',
          'First mix, next bake, last eat.',
        ],
        <String>[
          'Choose the Best Verb',
          'The verb changes to match the time of the action.',
          'Yesterday I walked.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which sentence is in the past?',
          'I play now.',
          'I played yesterday.',
          'I will play tomorrow.',
          'I can play.',
          1,
          'Played tells us it already happened.',
        ],
        <Object>[
          'Which word tells the first step?',
          'then',
          'last',
          'first',
          'after',
          2,
          'First tells the first step.',
        ],
        <Object>[
          'Which sentence is in the future?',
          'I read now.',
          'I read yesterday.',
          'I will read tomorrow.',
          'I am reading.',
          2,
          'Will read tells us it will happen later.',
        ],
        <Object>[
          'Which word can come after first?',
          'next',
          'yesterday',
          'quietly',
          'blue',
          0,
          'Next follows first in a sequence.',
        ],
        <Object>[
          'Choose the best verb for yesterday.',
          'jump',
          'jumps',
          'jumped',
          'jumping',
          2,
          'Jumped matches yesterday.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 3,
      stageNumber: 3,
      kind: _SubjectKind.english,
      title: 'Main Idea and Response',
      slides: const <List<String>>[
        <String>[
          'Find the Main Idea',
          'The main idea is the big thing the reading wants to tell you.',
          'Big idea: Sharing helps everyone.',
        ],
        <String>[
          'Look for Helpful Details',
          'Details support the main idea with small facts.',
          'Ali shares his crayons and books.',
        ],
        <String>[
          'Respond with Your Own Sentence',
          'After reading, write one sentence about the big idea.',
          'Sharing makes friends happy.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What is the main idea?',
          'The big message of the reading',
          'Only one small word',
          'The page color',
          'The writer name only',
          0,
          'The main idea is the big message.',
        ],
        <Object>[
          'What do details do?',
          'Support the main idea',
          'Hide the reading',
          'Change every word',
          'End the story',
          0,
          'Details support the main idea.',
        ],
        <Object>[
          'Which sentence fits the big idea "Sharing helps everyone"?',
          'I hide all my toys.',
          'Sharing makes work easier.',
          'Blue is my favorite color.',
          'I run very fast.',
          1,
          'Sharing makes work easier matches the big idea.',
        ],
        <Object>[
          'Which is a detail?',
          'Ali shares his crayons.',
          'Kindness matters.',
          'Main idea',
          'Big message',
          0,
          'Ali shares his crayons. is a detail.',
        ],
        <Object>[
          'What should you do after reading?',
          'Write one response sentence',
          'Close the book forever',
          'Skip the idea',
          'Change the title only',
          0,
          'A response sentence shows what you understood.',
        ],
      ],
    ),
  ];
}

List<_LectureModule> _levelThreeMathModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 3,
      stageNumber: 1,
      kind: _SubjectKind.math,
      title: 'Add and Subtract within 100',
      slides: const <List<String>>[
        <String>[
          'Use Tens and Ones',
          'Break numbers into tens and ones to solve more easily.',
          '36 = 3 tens and 6 ones',
        ],
        <String>[
          'Add Step by Step',
          'Add tens first, then add ones.',
          '20 + 13 = 33',
        ],
        <String>[
          'Find Missing Numbers',
          'A missing number question asks you to think backward.',
          '25 + ? = 30',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What is 20 + 13?',
          '23',
          '33',
          '43',
          '53',
          1,
          '20 and 13 make 33.',
        ],
        <Object>[
          'What is 45 - 5?',
          '35',
          '40',
          '45',
          '50',
          1,
          '45 take away 5 equals 40.',
        ],
        <Object>[
          'What number makes 25 + ? = 30?',
          '3',
          '4',
          '5',
          '6',
          2,
          '25 needs 5 more to reach 30.',
        ],
        <Object>[
          'How many tens in 62?',
          '2',
          '4',
          '6',
          '8',
          2,
          '62 has 6 tens.',
        ],
        <Object>[
          'Which is correct?',
          '50 - 10 = 30',
          '50 - 10 = 40',
          '50 - 10 = 60',
          '50 - 10 = 70',
          1,
          '50 take away 10 equals 40.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 3,
      stageNumber: 2,
      kind: _SubjectKind.math,
      title: 'Equal Groups and Multiplication',
      slides: const <List<String>>[
        <String>[
          'Equal Groups',
          'Equal groups have the same number in each group.',
          '2 groups of 3',
        ],
        <String>[
          'Repeated Addition',
          'Multiplication can be shown by adding the same number again and again.',
          '3 + 3 = 6',
        ],
        <String>[
          'Arrays Help Us See',
          'Rows and columns can show equal groups clearly.',
          '2 rows of 4',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'How many in 2 groups of 3?',
          '5',
          '6',
          '7',
          '8',
          1,
          '2 groups of 3 make 6.',
        ],
        <Object>[
          'Which repeated addition shows 3 groups of 2?',
          '2 + 2 + 2',
          '3 + 3',
          '2 + 3',
          '4 + 2',
          0,
          'Three groups of two is 2 + 2 + 2.',
        ],
        <Object>['What is 4 + 4?', '6', '7', '8', '9', 2, '4 + 4 = 8.'],
        <Object>[
          'Which picture idea shows equal groups?',
          '2 bowls with 3 apples each',
          'One bowl with 5 and one with 1',
          'A line of mixed objects',
          'A clock',
          0,
          'Equal groups have the same amount in each group.',
        ],
        <Object>[
          'How many in 2 rows of 4?',
          '6',
          '7',
          '8',
          '9',
          2,
          '2 rows of 4 make 8.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 3,
      stageNumber: 3,
      kind: _SubjectKind.math,
      title: 'Measure and Use Money',
      slides: const <List<String>>[
        <String>[
          'Length and Height',
          'We compare things to tell which is longer, shorter, taller, or shorter.',
          'The pencil is longer.',
        ],
        <String>[
          'Weight',
          'Some objects are heavier and some are lighter.',
          'A rock is heavier than a leaf.',
        ],
        <String>[
          'Add Coin Values',
          'Add coin values together to find the total.',
          '5 + 10 = 15',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'Which word compares length?',
          'longer',
          'louder',
          'sweeter',
          'older',
          0,
          'Longer compares length.',
        ],
        <Object>[
          'Which is heavier?',
          'leaf',
          'rock',
          'feather',
          'paper',
          1,
          'A rock is heavier than a leaf.',
        ],
        <Object>[
          'What is 5 + 10?',
          '10',
          '15',
          '20',
          '25',
          1,
          'Five and ten make fifteen.',
        ],
        <Object>[
          'Which object is shorter?',
          'a tiny crayon',
          'a long ruler',
          'a tall tree',
          'a wide table',
          0,
          'A tiny crayon is shorter.',
        ],
        <Object>[
          'Which coin total is correct?',
          '10 + 10 = 15',
          '5 + 5 = 12',
          '5 + 10 = 15',
          '10 + 5 = 20',
          2,
          '5 + 10 equals 15.',
        ],
      ],
    ),
  ];
}

List<_LectureModule> _levelThreeGkModules() {
  return <_LectureModule>[
    _lessonModule(
      levelNumber: 3,
      stageNumber: 1,
      kind: _SubjectKind.gk,
      title: 'Earth and Maps',
      slides: const <List<String>>[
        <String>[
          'Earth Has Land and Water',
          'Our Earth has land to live on and water in oceans, rivers, and lakes.',
          'Blue can show water on a map.',
        ],
        <String>[
          'Globe and Map',
          'A globe is round like Earth. A map is a flat drawing of a place.',
          'Globe = round, map = flat',
        ],
        <String>[
          'Find Places',
          'Maps help us find schools, parks, roads, and homes.',
          'Look for the park on the map.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What does a globe show?',
          'The Earth',
          'Only one room',
          'A toy box',
          'A sandwich',
          0,
          'A globe shows the Earth.',
        ],
        <Object>[
          'Which is flat?',
          'Map',
          'Globe',
          'Ball',
          'Orange',
          0,
          'A map is flat.',
        ],
        <Object>[
          'What color often shows water on a map?',
          'Blue',
          'Brown',
          'Black',
          'Pink',
          0,
          'Blue often shows water on maps.',
        ],
        <Object>[
          'What can a map help you find?',
          'A park',
          'Only your homework',
          'Only a toy',
          'Only a song',
          0,
          'Maps help us find places like parks.',
        ],
        <Object>[
          'Earth has land and ...',
          'water',
          'glass',
          'paper',
          'string',
          0,
          'Earth has both land and water.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 3,
      stageNumber: 2,
      kind: _SubjectKind.gk,
      title: 'Matter and Weather Changes',
      slides: const <List<String>>[
        <String>[
          'Solid, Liquid, Gas',
          'Matter can be solid, liquid, or gas.',
          'Ice, water, steam',
        ],
        <String>[
          'Weather Can Change',
          'The sky and air can change from sunny to cloudy or rainy.',
          'Clouds may bring rain.',
        ],
        <String>[
          'Warm and Cold',
          'Temperature tells us if something is warm or cold.',
          'Ice is cold, soup is warm.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What is water?',
          'Solid',
          'Liquid',
          'Gas',
          'Rock',
          1,
          'Water is a liquid.',
        ],
        <Object>[
          'What can ice turn into when it melts?',
          'Steam',
          'Water',
          'Stone',
          'Sand',
          1,
          'Ice melts into water.',
        ],
        <Object>[
          'Which weather may bring rain?',
          'Cloudy',
          'Sunny',
          'Dry',
          'Calm',
          0,
          'Cloudy skies may bring rain.',
        ],
        <Object>[
          'Which is a gas?',
          'Steam',
          'Ice',
          'Juice',
          'Wood',
          0,
          'Steam is a gas.',
        ],
        <Object>[
          'Which feels cold?',
          'Ice',
          'Soup',
          'Tea',
          'Sun',
          0,
          'Ice feels cold.',
        ],
      ],
    ),
    _lessonModule(
      levelNumber: 3,
      stageNumber: 3,
      kind: _SubjectKind.gk,
      title: 'Care for Nature and Safety',
      slides: const <List<String>>[
        <String>[
          'Reuse and Recycle',
          'We can reduce waste by reusing and recycling useful things.',
          'Use both sides of paper.',
        ],
        <String>[
          'Save Water and Energy',
          'Turn off taps and lights when you do not need them.',
          'Close the tap after washing.',
        ],
        <String>[
          'Stay Safe in Emergencies',
          'Stay calm, call an adult, and move to a safe place.',
          'Tell a trusted adult quickly.',
        ],
      ],
      quiz: const <List<Object>>[
        <Object>[
          'What should you do after using water?',
          'Leave the tap on',
          'Close the tap',
          'Throw the tap',
          'Run away',
          1,
          'Closing the tap saves water.',
        ],
        <Object>[
          'Which action helps nature?',
          'Reuse paper',
          'Waste clean water',
          'Leave lights on all day',
          'Throw bottles anywhere',
          0,
          'Reusing paper helps nature.',
        ],
        <Object>[
          'Who should you tell in an emergency?',
          'A trusted adult',
          'No one',
          'Only a toy',
          'A cloud',
          0,
          'A trusted adult can help quickly.',
        ],
        <Object>[
          'What should you do with lights when leaving a room?',
          'Turn them off',
          'Turn on more',
          'Cover them',
          'Hide from them',
          0,
          'Turning lights off saves energy.',
        ],
        <Object>[
          'Which item can often be recycled?',
          'Paper',
          'Smoke',
          'Sunshine',
          'Rain',
          0,
          'Paper can often be recycled.',
        ],
      ],
    ),
  ];
}
