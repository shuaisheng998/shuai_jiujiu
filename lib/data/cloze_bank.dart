import '../models/cloze_test.dart';

class ClozeBank {
  static List<ClozeTest> getAllTests() {
    return [
      // ===== 初中难度：励志学习 =====
      ClozeTest(
        id: 'junior_1',
        title: '努力学习的重要性',
        level: 'junior',
        translation: '汤姆过去不喜欢学校。他觉得功课很难。但是他的老师总是鼓励他。她说："不要放弃。一切都会慢慢变好。"汤姆开始每天多花时间学习。现在他的成绩好多了。他为自己感到骄傲。',
        passage: '''Tom didn't ___ school in the past. 
He thought the lessons were ___. 
But his teacher always ___ him. 
She said, "Don't give ___. 
Everything will get better step by ___." 
Tom started to spend ___ time studying every day. 
Now his grades are much ___. 
He is proud of ___.''',
        blanks: [
          ClozeBlank(
            index: 0,
            options: ['like', 'likes', 'liked', 'liking'],
            correctIndex: 0,
            explanation: 'didn\'t 后面要用动词原形（过去式的否定后面加原形），所以填 like。',
          ),
          ClozeBlank(
            index: 1,
            options: ['easy', 'difficult', 'interesting', 'boring'],
            correctIndex: 1,
            explanation: '根据上下文，"汤姆觉得功课很难"，所以选 difficult（困难的）。',
          ),
          ClozeBlank(
            index: 2,
            options: ['encouraged', 'encourages', 'encouraging', 'encourage'],
            correctIndex: 0,
            explanation: '整篇故事用过去时态，"总是鼓励他"是过去的事，所以用过去式 encouraged。',
          ),
          ClozeBlank(
            index: 3,
            options: ['in', 'out', 'up', 'away'],
            correctIndex: 2,
            explanation: 'give up 是固定短语，意思是"放弃"。',
          ),
          ClozeBlank(
            index: 4,
            options: ['one', 'time', 'day', 'step'],
            correctIndex: 3,
            explanation: 'step by step 是固定短语，意思是"一步一步地"。',
          ),
          ClozeBlank(
            index: 5,
            options: ['less', 'more', 'little', 'no'],
            correctIndex: 1,
            explanation: '根据上下文，"汤姆开始花更多时间学习"，所以选 more（更多的）。',
          ),
          ClozeBlank(
            index: 6,
            options: ['bad', 'well', 'better', 'good'],
            correctIndex: 2,
            explanation: 'much 可以用来修饰比较级，much better 意思是"好多了"。',
          ),
          ClozeBlank(
            index: 7,
            options: ['him', 'his', 'he', 'himself'],
            correctIndex: 3,
            explanation: 'be proud of oneself 是"为自己感到骄傲"，用反身代词 himself。',
          ),
        ],
      ),

      // ===== 初中难度：学习方法 =====
      ClozeTest(
        id: 'junior_2',
        title: '怎样学好英语',
        level: 'junior',
        translation: '学英语最好的方式是多练习。每天读一些英语书。听英语歌也很有帮助。不要害怕犯错。错误是学习的一部分。坚持练习，你会进步的！',
        passage: '''The best ___ to learn English is to practice a lot. 
___ some English books every day. 
Listening to English ___ is also helpful. 
Don't be afraid of making ___. 
Mistakes are part of ___. 
Keep ___ and you will improve!''',
        blanks: [
          ClozeBlank(
            index: 0,
            options: ['way', 'road', 'street', 'path'],
            correctIndex: 0,
            explanation: 'the best way to do sth. 是"做某事最好的方式"，way在这里是方法的意思。',
          ),
          ClozeBlank(
            index: 1,
            options: ['Read', 'Watch', 'Look', 'See'],
            correctIndex: 0,
            explanation: '"读书"用 read books，这里指阅读英语书。watch是观看，look是看（不及物）。',
          ),
          ClozeBlank(
            index: 2,
            options: ['songs', 'books', 'movies', 'news'],
            correctIndex: 0,
            explanation: '前面提到"听英语"，听英语歌是 listening to English songs。',
          ),
          ClozeBlank(
            index: 3,
            options: ['mistakes', 'friends', 'progress', 'sense'],
            correctIndex: 0,
            explanation: 'make mistakes 是固定短语，意思是"犯错误"。',
          ),
          ClozeBlank(
            index: 4,
            options: ['learning', 'playing', 'working', 'sleeping'],
            correctIndex: 0,
            explanation: 'part of learning 是"学习的一部分"，错误是学习过程中正常的。',
          ),
          ClozeBlank(
            index: 5,
            options: ['practicing', 'practice', 'to practice', 'practiced'],
            correctIndex: 0,
            explanation: 'keep doing sth. 是固定用法，表示"继续做某事"，所以用 practicing。',
          ),
        ],
      ),

      // ===== 初中难度：日常生活 =====
      ClozeTest(
        id: 'junior_3',
        title: '我的周末',
        level: 'junior',
        translation: '上个周末我过得很愉快。星期六早上我和朋友踢了足球。下午我们看了电影。星期天我待在家里做作业。晚上我帮妈妈做晚饭。我很累但是很开心。',
        passage: '''I had a great ___ last weekend.
On Saturday morning, I played ___ with my friends.
In the ___, we watched a movie.
On Sunday, I ___ at home and did my homework.
In the evening, I ___ my mother cook dinner.
I was tired ___ happy.''',
        blanks: [
          ClozeBlank(
            index: 0,
            options: ['time', 'day', 'weekend', 'night'],
            correctIndex: 0,
            explanation: 'have a great time 是固定短语，意思是"过得很愉快"。',
          ),
          ClozeBlank(
            index: 1,
            options: ['football', 'the football', 'a football', 'footballs'],
            correctIndex: 0,
            explanation: 'play football（踢足球），球类运动前面不加冠词 the。',
          ),
          ClozeBlank(
            index: 2,
            options: ['morning', 'afternoon', 'evening', 'night'],
            correctIndex: 1,
            explanation: '前面说"星期六早上踢球"，后面说"看了电影"，时间顺序是早上→下午，所以选 afternoon。',
          ),
          ClozeBlank(
            index: 3,
            options: ['stayed', 'stays', 'stay', 'staying'],
            correctIndex: 0,
            explanation: '整篇是过去时（had, played），所以用过去式 stayed。',
          ),
          ClozeBlank(
            index: 4,
            options: ['helped', 'help', 'helps', 'helping'],
            correctIndex: 0,
            explanation: '全文过去时，"帮妈妈做晚饭"用过去式 helped。help sb. do sth. 是"帮助某人做某事"。',
          ),
          ClozeBlank(
            index: 5,
            options: ['and', 'but', 'or', 'so'],
            correctIndex: 1,
            explanation: 'tired（累）和 happy（开心）是转折关系，"虽然累但是开心"，用 but。',
          ),
        ],
      ),

      // ===== 高中难度：坚持梦想 =====
      ClozeTest(
        id: 'senior_1',
        title: '坚持你的梦想',
        level: 'senior',
        translation: '每个人都有自己的梦想。但是实现梦想并不容易。在路上会遇到很多困难。重要的是不要放弃。一步一步地走，总有一天你会成功的。',
        passage: '''Everyone has their own ___. 
But it's not easy to ___ your dream come true. 
You will meet many ___ on the way. 
What's important is never to give ___. 
Take it step by step, and you will ___ one day.''',
        blanks: [
          ClozeBlank(
            index: 0,
            options: ['dreams', 'dream', 'ideas', 'thoughts'],
            correctIndex: 0,
            explanation: 'their own dreams，their后面接复数名词。而且"有自己的梦想"是固定说法。',
          ),
          ClozeBlank(
            index: 1,
            options: ['make', 'let', 'have', 'get'],
            correctIndex: 0,
            explanation: 'make your dream come true 是固定短语，意思是"实现你的梦想"。',
          ),
          ClozeBlank(
            index: 2,
            options: ['difficulties', 'friends', 'chances', 'choices'],
            correctIndex: 0,
            explanation: '根据上下文"会遇到很多困难"，选 difficulties（困难）。many后面接可数名词复数。',
          ),
          ClozeBlank(
            index: 3,
            options: ['up', 'in', 'out', 'off'],
            correctIndex: 0,
            explanation: 'give up 是"放弃"的意思，固定短语。',
          ),
          ClozeBlank(
            index: 4,
            options: ['succeed', 'success', 'successful', 'successfully'],
            correctIndex: 0,
            explanation: 'will 后面接动词原形，succeed 是动词"成功"，所以选 succeed。',
          ),
        ],
      ),

      // ===== 高中难度：友谊 =====
      ClozeTest(
        id: 'senior_2',
        title: '真正的朋友',
        level: 'senior',
        translation: '真正的朋友是在你需要的时候陪在你身边的人。他们耐心地听你说话，当你难过的时候让你开心起来。友谊需要双方都付出努力。珍惜你的朋友。',
        passage: '''A true friend is someone who ___ there when you need them. 
They listen to you ___. 
They cheer you ___ when you are sad. 
Friendship needs effort from both ___. 
Treasure your ___!''',
        blanks: [
          ClozeBlank(
            index: 0,
            options: ['is', 'are', 'was', 'were'],
            correctIndex: 0,
            explanation: 'who 指代 someone（某人），someone 是单数，所以用 is。',
          ),
          ClozeBlank(
            index: 1,
            options: ['patiently', 'patient', 'patience', 'impatient'],
            correctIndex: 0,
            explanation: '修饰动词 listen 要用副词，patiently 是"耐心地"。',
          ),
          ClozeBlank(
            index: 2,
            options: ['up', 'down', 'out', 'in'],
            correctIndex: 0,
            explanation: 'cheer up 是固定短语，意思是"使……开心起来"。',
          ),
          ClozeBlank(
            index: 3,
            options: ['sides', 'friends', 'people', 'persons'],
            correctIndex: 0,
            explanation: 'both sides 指"双方"，both 后面接可数名词复数。',
          ),
          ClozeBlank(
            index: 4,
            options: ['friends', 'family', 'parents', 'teachers'],
            correctIndex: 0,
            explanation: '前面一直在说朋友，所以"珍惜你的朋友"选 friends。',
          ),
        ],
      ),

      // ===== 高中难度：时间管理 =====
      ClozeTest(
        id: 'senior_3',
        title: '如何管理时间',
        level: 'senior',
        translation: '时间是宝贵的资源。很多学生觉得没有足够的时间做完所有事情。一个好的方法是列一个清单。先做最重要的事情。不要拖延。合理利用时间。',
        passage: '''Time is a ___ resource. 
Many students feel they don't have ___ time to do everything. 
A good way is to ___ a list. 
Do the most ___ things first. 
Don't put ___ tomorrow what can be done today.''',
        blanks: [
          ClozeBlank(
            index: 0,
            options: ['valuable', 'valuably', 'value', 'valued'],
            correctIndex: 0,
            explanation: '修饰名词resource要用形容词，valuable是"宝贵的"。',
          ),
          ClozeBlank(
            index: 1,
            options: ['enough', 'many', 'little', 'a lot'],
            correctIndex: 0,
            explanation: 'don\'t have enough time 是"没有足够的时间"，enough修饰名词放在前面。',
          ),
          ClozeBlank(
            index: 2,
            options: ['make', 'do', 'take', 'give'],
            correctIndex: 0,
            explanation: 'make a list 是"列清单"的固定搭配。',
          ),
          ClozeBlank(
            index: 3,
            options: ['important', 'difficult', 'easy', 'interesting'],
            correctIndex: 0,
            explanation: '"先把最重要的事情做完"，most important 是"最重要的"。',
          ),
          ClozeBlank(
            index: 4,
            options: ['off', 'up', 'down', 'away'],
            correctIndex: 0,
            explanation: 'put off 是固定短语，意思是"拖延"。"今日事今日毕"。',
          ),
        ],
      ),
      // ===== 追加：初中 =====
      ClozeTest(
        id: 'junior_4',
        title: '帮助他人',
        level: 'junior',
        translation: '玛丽是个善良的女孩。她总是帮助别人。上周她在路上发现了一个钱包。她把钱包交给了警察。警察找到了失主。失主非常感激。玛丽非常开心。',
        passage: '''Mary is a ___ girl.
She always ___ others.
Last week, she found a wallet ___ the street.
She gave ___ to the police.
The police found the ___.
The owner was very ___.
Mary was very happy.''',
        blanks: [
          ClozeBlank(index: 0, options: ['kind', 'kindly', 'kinder', 'kindness'], correctIndex: 0, explanation: '修饰名词girl用形容词kind，意思是"善良的"。'),
          ClozeBlank(index: 1, options: ['help', 'helps', 'helped', 'helping'], correctIndex: 1, explanation: 'She是第三人称单数，一般现在时加-s。'),
          ClozeBlank(index: 2, options: ['in', 'on', 'at', 'under'], correctIndex: 1, explanation: '"在路上"用on the street。'),
          ClozeBlank(index: 3, options: ['it', 'them', 'her', 'him'], correctIndex: 0, explanation: '指代前面的a wallet（钱包），单数用it。'),
          ClozeBlank(index: 4, options: ['owner', 'wallet', 'police', 'girl'], correctIndex: 0, explanation: '警察找到了失主，owner是"失主/主人"。'),
          ClozeBlank(index: 5, options: ['thankful', 'thank', 'thanking', 'thanks'], correctIndex: 0, explanation: 'was后面接形容词thankful，表示"感激的"。'),
        ],
      ),
      ClozeTest(
        id: 'junior_5',
        title: '健康饮食',
        level: 'junior',
        translation: '健康饮食对我们很重要。我们应该每天吃水果和蔬菜。不要吃太多垃圾食品。多喝水。多做运动。这样你就能保持健康。',
        passage: '''A healthy diet is very ___ for us.
We should eat ___ and vegetables every day.
Don't eat too much ___ food.
Drink ___ water.
Take more ___.
In this way, you can ___ healthy.''',
        blanks: [
          ClozeBlank(index: 0, options: ['important', 'easy', 'difficult', 'good'], correctIndex: 0, explanation: 'be important for 是"对...重要"的固定搭配。'),
          ClozeBlank(index: 1, options: ['fruit', 'fruit\'s', 'fruits', 'fruity'], correctIndex: 0, explanation: 'fruit作为"水果"总称时是不可数名词，和vegetables并列。'),
          ClozeBlank(index: 2, options: ['junk', 'healthy', 'good', 'nice'], correctIndex: 0, explanation: 'junk food 是"垃圾食品"的固定说法。'),
          ClozeBlank(index: 3, options: ['much', 'many', 'a lot', 'some'], correctIndex: 0, explanation: 'water不可数，用much修饰。Drink much water 多喝水。'),
          ClozeBlank(index: 4, options: ['exercise', 'exercises', 'exercising', 'exercised'], correctIndex: 0, explanation: 'take exercise 是"做运动"的固定搭配，exercise不可数。'),
          ClozeBlank(index: 5, options: ['stay', 'stays', 'staying', 'stayed'], correctIndex: 0, explanation: 'can后面接动词原形。stay healthy 保持健康。'),
        ],
      ),
      // ===== 追加：高中 =====
      ClozeTest(
        id: 'senior_4',
        title: '科技改变生活',
        level: 'senior',
        translation: '科技在我们的生活中扮演着重要的角色。智能手机改变了我们的交流方式。互联网让我们足不出户就能获取信息。但我们也需要明智地使用科技。',
        passage: '''Technology plays an ___ role in our lives.
Smartphones have changed the way we ___.
The Internet makes it possible for us to get ___ without leaving home.
But we also need to use technology ___.''',
        blanks: [
          ClozeBlank(index: 0, options: ['important', 'importantly', 'importance', 'more important'], correctIndex: 0, explanation: 'play an important role 是固定搭配，意思是"扮演重要角色"。an后面要用元音音素开头的词。'),
          ClozeBlank(index: 1, options: ['communicate', 'communication', 'communicative', 'communicating'], correctIndex: 0, explanation: 'we后面接动词原形，communicate是动词"交流"。'),
          ClozeBlank(index: 2, options: ['information', 'informations', 'informative', 'inform'], correctIndex: 0, explanation: 'information是不可数名词，没有复数形式。'),
          ClozeBlank(index: 3, options: ['wisely', 'wise', 'wisdom', 'wiser'], correctIndex: 0, explanation: '修饰动词use要用副词，wisely是"明智地"。'),
        ],
      ),
      ClozeTest(
        id: 'senior_5',
        title: '成功的秘诀',
        level: 'senior',
        translation: '成功没有捷径。努力工作是关键。设定明确的目标，然后一步一步地实现它们。不要害怕失败。从错误中学习，继续前进。',
        passage: '''There is no ___ way to success.
___ work is the key to success.
Set clear ___ and achieve them step by step.
Don't be afraid of ___.
Learn from your mistakes and move ___.''',
        blanks: [
          ClozeBlank(index: 0, options: ['easy', 'easily', 'easier', 'easiest'], correctIndex: 0, explanation: '修饰名词way用形容词。No easy way 没有容易的路。'),
          ClozeBlank(index: 1, options: ['Hard', 'Hardly', 'Harder', 'Hardest'], correctIndex: 0, explanation: 'Hard work 是"努力工作"的意思。Hardly是"几乎不"，意思完全不同。'),
          ClozeBlank(index: 2, options: ['goals', 'goal', 'goaling', 'goaled'], correctIndex: 0, explanation: 'set goals 设定目标。前面有"clear"修饰，且不止一个目标，用复数。'),
          ClozeBlank(index: 3, options: ['failure', 'fail', 'failing', 'failed'], correctIndex: 0, explanation: 'be afraid of后面接名词，failure是"失败"的名词形式。'),
          ClozeBlank(index: 4, options: ['on', 'in', 'out', 'up'], correctIndex: 0, explanation: 'move on 是固定短语，意思是"继续前进"。'),
        ],
      ),
    ];
  }
}
