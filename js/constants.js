export const GRID_COLS = 22;
export const GRID_ROWS = 5;

export const SCRAMBLE_DURATION = 800;
export const FLIP_DURATION = 300;
export const STAGGER_DELAY = 25;
export const TOTAL_TRANSITION = 3800;
export const MESSAGE_INTERVAL = 4000;
export const RIDDLE_DELAY = 6000;

export const CHARSET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,-!?\'/: ';

export const SCRAMBLE_COLORS = [
  '#E8A840', '#D4735E', '#6BA3BE',
  '#7BA068', '#E8DCC8', '#9B8EC4'
];

export const ACCENT_COLORS = [
  '#E8A840', '#D4735E', '#6BA3BE',
  '#7BA068', '#9B8EC4'
];

// Weather API config for Berkeley, CA (Open-Meteo, no key needed)
export const WEATHER_CONFIG = {
  url: 'https://api.open-meteo.com/v1/forecast?latitude=37.87&longitude=-122.27&current=temperature_2m,weather_code&temperature_unit=fahrenheit',
  weatherCodes: {
    0: 'CLEAR',
    1: 'MOSTLY CLEAR',
    2: 'PARTLY CLOUDY',
    3: 'CLOUDY',
    45: 'FOGGY',
    48: 'FOGGY',
    51: 'DRIZZLE',
    53: 'DRIZZLE',
    55: 'DRIZZLE',
    61: 'RAINY',
    63: 'RAINY',
    65: 'HEAVY RAIN',
    71: 'SNOWY',
    73: 'SNOWY',
    75: 'HEAVY SNOW',
    80: 'RAIN SHOWERS',
    81: 'RAIN SHOWERS',
    82: 'HEAVY SHOWERS',
    95: 'STORMY',
    96: 'STORMY',
    99: 'STORMY'
  }
};

// --- MORNING SET (7:00-7:59am) ---

const MORNING_REMINDERS = [
  { type: 'reminder', lines: ['', '', 'BRUSH YOUR TEETH', '', ''] },
  { type: 'reminder', lines: ['', '', 'BRUSH YOUR HAIR', '', ''] },
  { type: 'reminder', lines: ['', '', 'PUT YOUR SOCKS ON', '', ''] },
  { type: 'reminder', lines: ['', '', 'BE NICE', '', ''] },
  { type: 'reminder', lines: ['', 'GET READY FOR A', 'BEAUTIFUL DAY', '', ''] }
];

// 5 breakfast/food/school themed jokes for morning
const MORNING_JOKES = [
  { type: 'joke', lines: ['', 'WHAT DO CATS EAT', 'FOR BREAKFAST?', 'MICE KRISPIES!', ''] },
  { type: 'joke', lines: ['', 'WHY DONT EGGS', 'TELL JOKES?', 'THEY MIGHT CRACK UP!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE KID', 'BRING A LADDER?', 'TO GO TO HIGH SCHOOL', ''] },
  { type: 'joke', lines: ['', 'WHAT DO ELVES', 'LEARN IN SCHOOL?', 'THE ELF-ABET!', ''] },
  { type: 'joke', lines: ['', 'WHY DID BACON', 'LAUGH?', 'THE EGG CRACKED ONE!', ''] }
];

// Interleave: reminder, joke, reminder, joke, ...
export const MORNING_MESSAGES = [];
for (let i = 0; i < 5; i++) {
  MORNING_MESSAGES.push(MORNING_REMINDERS[i]);
  MORNING_MESSAGES.push(MORNING_JOKES[i]);
}

// --- BEDTIME SET (7:30-8:30pm) ---

const BEDTIME_REMINDERS = [
  { type: 'reminder', lines: ['', '', 'BRUSH YOUR TEETH', '', ''] },
  { type: 'reminder', lines: ['', '', 'CHANGE YOUR CLOTHES', '', ''] },
  { type: 'reminder', lines: ['', '', 'PACK YOUR BACKPACK', '', ''] },
  { type: 'reminder', lines: ['', '', 'READ A BOOK', '', ''] },
  { type: 'reminder', lines: ['', '', 'DRINK SOME WATER', '', ''] },
  { type: 'reminder', lines: ['', '', 'SAY GOODNIGHT', '', ''] },
  { type: 'reminder', lines: ['', '', 'SWEET DREAMS', '', ''] },
  { type: 'reminder', lines: ['', '', 'YOU DID GREAT TODAY', '', ''] },
  { type: 'reminder', lines: ['', 'TOMORROW IS A', 'NEW ADVENTURE', '', ''] }
];

const BEDTIME_QUOTES = [
  { type: 'bedtime_quote', lines: ['', 'TO SLEEP PERCHANCE', 'TO DREAM', '- SHAKESPEARE', ''] },
  { type: 'bedtime_quote', lines: ['', 'TOMORROW IS A NEW DAY', 'WITH NO MISTAKES YET', '- ANNE SHIRLEY', ''] },
  { type: 'bedtime_quote', lines: ['', 'YOU ARE BRAVER THAN', 'YOU BELIEVE', '- WINNIE THE POOH', ''] },
  { type: 'bedtime_quote', lines: ['', 'THE MOON IS A FRIEND', 'FOR THE LONESOME', '- CARL SANDBURG', ''] },
  { type: 'bedtime_quote', lines: ['', 'SLEEP IS THE BEST', 'MEDITATION', '- DALAI LAMA', ''] },
  { type: 'bedtime_quote', lines: ['', 'EVERY SUNSET BRINGS', 'THE PROMISE OF', 'A NEW DAWN - EMERSON', ''] },
  { type: 'bedtime_quote', lines: ['', 'EVEN SUPERHEROES', 'NEED SLEEP', '', ''] },
  { type: 'bedtime_quote', lines: ['', 'THE NIGHT IS DARKEST', 'JUST BEFORE THE DAWN', '- THOMAS FULLER', ''] },
  { type: 'bedtime_quote', lines: ['', 'AND SO TO BED', '', '- SAMUEL PEPYS', ''] }
];

// Interleave: reminder, quote, reminder, quote, ...
export const BEDTIME_MESSAGES = [];
for (let i = 0; i < 9; i++) {
  BEDTIME_MESSAGES.push(BEDTIME_REMINDERS[i]);
  BEDTIME_MESSAGES.push(BEDTIME_QUOTES[i]);
}

// --- QUOTES (24) ---

const QUOTES = [
  { type: 'quote', lines: ['', 'DO OR DO NOT', 'THERE IS NO TRY', '- YODA', ''] },
  { type: 'quote', lines: ['', 'YOUR FOCUS', 'DETERMINES REALITY', '- QUI-GON JINN', ''] },
  { type: 'quote', lines: ['', 'THE FORCE WILL BE', 'WITH YOU ALWAYS', '- OBI-WAN KENOBI', ''] },
  { type: 'quote', lines: ['', 'THE GREATEST', 'TEACHER FAILURE IS', '- YODA', ''] },
  { type: 'quote', lines: ['', 'OUR CHOICES SHOW', 'WHAT WE TRULY ARE', '- DUMBLEDORE', ''] },
  { type: 'quote', lines: ['', 'HAPPINESS CAN BE', 'FOUND IN DARKEST', 'TIMES - DUMBLEDORE', ''] },
  { type: 'quote', lines: ['', 'IT TAKES COURAGE TO', 'STAND UP TO FRIENDS', '- DUMBLEDORE', ''] },
  { type: 'quote', lines: ['', 'WORDS ARE OUR MOST', 'INEXHAUSTIBLE', 'MAGIC - DUMBLEDORE', ''] },
  { type: 'quote', lines: ['', 'EVEN STRENGTH MUST', 'BOW TO WISDOM', '- ANNABETH CHASE', ''] },
  { type: 'quote', lines: ['', 'BEING A HERO DOESNT', 'MEAN INVINCIBLE', '- PERCY JACKSON', ''] },
  { type: 'quote', lines: ['', 'BRAVE DOESNT MEAN', 'YOURE NOT SCARED', '- PERCY JACKSON', ''] },
  { type: 'quote', lines: ['', 'THE RIGHT CHOICE IS', 'RARELY THE EASY ONE', '- PERCY JACKSON', ''] },
  // GREEK MYTHOLOGY (6)
  { type: 'quote', lines: ['', 'WISDOM IS THE', 'GREATEST STRENGTH', '- ATHENA', ''] },
  { type: 'quote', lines: ['', 'TRUE HEROES', 'HELP OTHERS', '- HERCULES', ''] },
  { type: 'quote', lines: ['', 'THE JOURNEY HOME IS', 'WORTH EVERY STEP', '- THE ODYSSEY', ''] },
  { type: 'quote', lines: ['', 'CLEVERNESS CAN', 'BEAT STRENGTH', '- ODYSSEUS', ''] },
  { type: 'quote', lines: ['', 'KNOW YOURSELF AND', 'YOU WILL KNOW THE', 'UNIVERSE - DELPHI', ''] },
  { type: 'quote', lines: ['', 'EVERY MAZE HAS', 'A WAY OUT', '- THESEUS', ''] },
  // NORSE MYTHOLOGY (6)
  { type: 'quote', lines: ['', 'BE STRONG LIKE THOR', 'WISE LIKE ODIN', '', ''] },
  { type: 'quote', lines: ['', 'EVEN THUNDER STARTS', 'AS A WHISPER', '', ''] },
  { type: 'quote', lines: ['', 'A KIND WORD NEED', 'NOT COST MUCH', '- ODIN', ''] },
  { type: 'quote', lines: ['', 'THE BRAVE LIVE', 'ON FOREVER', '', ''] },
  { type: 'quote', lines: ['', 'IN EVERY WINTER', 'SPRING HIDES', '', ''] },
  { type: 'quote', lines: ['', 'STAND TALL LIKE', 'A MIGHTY OAK', '- YGGDRASIL', ''] }
];

// --- JOKES (197) ---

const JOKES = [
  // ANIMALS (37)
  { type: 'joke', lines: ['', 'WHY DID THE COW', 'CROSS THE ROAD?', 'TO THE UDDER SIDE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A SLEEPING BULL?', 'A BULLDOZER!', ''] },
  { type: 'joke', lines: ['', 'WHY ARE FISH', 'SO SMART?', 'THEY LIVE IN SCHOOLS', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A BEAR WITH NO TEETH?', 'A GUMMY BEAR!', ''] },
  { type: 'joke', lines: ['', 'WHAT IS A CATS', 'FAVORITE COLOR?', 'PURR-PLE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A FLY WITH NO WINGS?', 'A WALK!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO COWS', 'READ?', 'MOO-SPAPERS!', ''] },
  { type: 'joke', lines: ['', 'WHY DONT LEOPARDS', 'PLAY HIDE AND SEEK?', 'ALWAYS SPOTTED!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A LAZY KANGAROO?', 'A POUCH POTATO!', ''] },
  { type: 'joke', lines: ['', 'WHAT SOUND DO', 'PORCUPINES MAKE?', 'OW OW OW!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'AN ALLIGATOR IN VEST?', 'INVESTIGATOR!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO DUCKS', 'GET AFTER THEY EAT?', 'A BILL!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A FISH WITHOUT EYES?', 'A FSH!', ''] },
  { type: 'joke', lines: ['', 'WHERE DO COWS', 'GO FOR FUN?', 'THE MOO-VIES!', ''] },
  { type: 'joke', lines: ['', 'WHY CANT YOU TELL', 'A SECRET ON A FARM?', 'THE CORN HAS EARS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A DOG MAGICIAN?', 'A LABRACADABRADOR!', ''] },
  { type: 'joke', lines: ['', 'WHY DO BEES HAVE', 'STICKY HAIR?', 'THEY USE HONEYCOMBS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO FROGS', 'ORDER AT A CAFE?', 'CROAK-A-COLA!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO SNAKES', 'STUDY IN SCHOOL?', 'HISS-TORY!', ''] },
  { type: 'joke', lines: ['', 'WHERE DO SHEEP', 'GO ON VACATION?', 'THE BAAAA-HAMAS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO CATS EAT', 'FOR BREAKFAST?', 'MICE KRISPIES!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE DUCK', 'GO TO THE DOCTOR?', 'IT WAS FEELING QUACK', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A COLD DOG?', 'A CHILI DOG!', ''] },
  { type: 'joke', lines: ['', 'HOW DO BEES', 'GET TO SCHOOL?', 'ON THE BUZZ!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A PENGUIN IN DESERT?', 'LOST!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU GIVE', 'A SICK BIRD?', 'TWEET-MENT!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE HORSE', 'GO BEHIND THE TREE?', 'TO CHANGE HIS JOCKY', ''] },
  { type: 'joke', lines: ['', 'WHAT DO ELEPHANTS', 'USE TO TALK?', 'ELEPHONES!', ''] },
  { type: 'joke', lines: ['', 'WHY DO FISH LIVE', 'IN SALT WATER?', 'PEPPER MAKES SNEEZE', ''] },
  { type: 'joke', lines: ['', 'WHAT DO TURTLES', 'DO ON BIRTHDAYS?', 'THEY SHELLEBRATE!', ''] },
  { type: 'joke', lines: ['', 'WHY ARE CATS', 'GOOD AT VIDEO GAMES?', 'THEY HAVE NINE LIVES', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A DINOSAUR THAT NAPS?', 'A DINO-SNORE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO OWLS SAY', 'ON HALLOWEEN?', 'HAPPY OWL-OWEEN!', ''] },
  { type: 'joke', lines: ['', 'WHY DO GIRAFFES', 'HAVE LONG NECKS?', 'THEIR FEET SMELL!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A FUNNY CHICKEN?', 'A COMEDI-HEN!', ''] },
  { type: 'joke', lines: ['', 'WHY ARE DOGS', 'BAD DANCERS?', 'TWO LEFT FEET!', ''] },
  // FOOD (35)
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'CHEESE THAT ISNT YOURS', 'NACHO CHEESE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'FAKE SPAGHETTI?', 'AN IMPASTA!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE TOMATO', 'TURN RED?', 'IT SAW THE DRESSING!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE BANANA', 'GO TO THE DOCTOR?', 'IT WASNT PEELING WELL', ''] },
  { type: 'joke', lines: ['', 'WHAT DO ELVES', 'MAKE SANDWICHES WITH?', 'SHORTBREAD!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE COOKIE', 'GO TO THE DOCTOR?', 'IT FELT CRUMMY!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE GRAPE', 'SAY WHEN STEPPED ON?', 'NOTHING JUST A WHINE', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE EGG', 'HIDE?', 'IT WAS A LITTLE CHICK', ''] },
  { type: 'joke', lines: ['', 'WHY DONT EGGS', 'TELL JOKES?', 'THEY MIGHT CRACK UP!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A SAD STRAWBERRY?', 'A BLUEBERRY!', ''] },
  { type: 'joke', lines: ['', 'HOW DO YOU FIX', 'A BROKEN PIZZA?', 'WITH TOMATO PASTE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE CAKE', 'SAY TO THE FORK?', 'WANT A PIECE OF ME?', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE', 'BREAD SAY TO BUTTER?', "YOU'RE ON A ROLL!", ''] },
  { type: 'joke', lines: ['', 'WHY DID THE LEMON', 'STOP ROLLING?', 'IT RAN OUT OF JUICE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO APPLES', 'AND ORANGES HAVE?', "THEY'RE BOTH FRUIT!", ''] },
  { type: 'joke', lines: ['', 'WHAT IS A PRETZELS', 'FAVORITE DAY?', 'TWISTS-DAY!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A SLEEPING PIZZA?', 'A PIZZZZZA!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE MELON', 'JUMP IN THE LAKE?', 'WANTED TO BE WATER', ''] },
  { type: 'joke', lines: ['', 'HOW DO YOU MAKE', 'A MILKSHAKE?', 'GIVE A COW A POGO!', ''] },
  { type: 'joke', lines: ['', 'WHAT KIND OF NUT', 'ALWAYS HAS A COLD?', 'CASHEW!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE HOT', 'DOG SAY TO THE BUN?', 'STOP LOAFING AROUND', ''] },
  { type: 'joke', lines: ['', 'WHY DID BACON', 'LAUGH?', 'THE EGG CRACKED ONE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DOES A NOSY', 'PEPPER DO?', 'GETS JALAPENO BIZ!', ''] },
  { type: 'joke', lines: ['', 'WHAT VEGETABLES', 'DO LIBRARIANS LIKE?', 'QUIET PEAS!', ''] },
  { type: 'joke', lines: ['', 'WHY WAS THE SOUP', 'SO GOOD AT BASEBALL?', 'IT HAD A GOOD STOCK!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID KETCHUP', 'SAY TO MUSTARD?', "YOU'RE THE WURST!", ''] },
  { type: 'joke', lines: ['', 'WHAT DID PEANUT', 'BUTTER SAY TO JELLY?', 'STUCK ON YOU!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A RICH ELF?', 'WELFY!', ''] },
  { type: 'joke', lines: ['', 'HOW DO TACOS', 'SAY GRACE?', 'LETTUCE PRAY!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE PEACH', 'GO TO THE DENTIST?', 'BAD FUZZ ON TEETH!', ''] },
  { type: 'joke', lines: ['', 'WHY DO MUSHROOMS', 'GET INVITED TO PARTY?', "THEY'RE FUN-GI!", ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A RUNNING TURKEY?', 'FAST FOOD!', ''] },
  { type: 'joke', lines: ['', 'HOW DO PICKLES', 'ENJOY A DAY OUT?', 'THEY RELISH IT!', ''] },
  // SCHOOL (30)
  { type: 'joke', lines: ['', 'WHY DID THE KID', 'BRING A LADDER?', 'TO GO TO HIGH SCHOOL', ''] },
  { type: 'joke', lines: ['', 'WHAT IS A WITCHS', 'FAVORITE SUBJECT?', 'SPELLING!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE BOOK', 'GO TO THE HOSPITAL?', 'IT HURT ITS SPINE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A TEACHER WHO FARTS?', 'A PRIVATE TUTOR!', ''] },
  { type: 'joke', lines: ['', 'WHY WAS THE MATH', 'BOOK ALWAYS SAD?', 'IT HAD PROBLEMS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE PEN', 'SAY TO THE PENCIL?', "YOU'RE POINTLESS!", ''] },
  { type: 'joke', lines: ['', 'WHY DO CALCULATORS', 'MAKE GREAT FRIENDS?', 'YOU CAN COUNT ON EM!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE ERASER', 'GO TO SCHOOL?', 'TO CORRECT MISTAKES!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO ELVES', 'LEARN IN SCHOOL?', 'THE ELF-ABET!', ''] },
  { type: 'joke', lines: ['', 'WHAT SCHOOL SUPPLY', 'IS KING OF THE CLASS?', 'THE RULER!', ''] },
  { type: 'joke', lines: ['', 'WHY WAS THE BROOM', 'LATE FOR SCHOOL?', 'IT OVERSWEPT!', ''] },
  { type: 'joke', lines: ['', 'WHY DO MAGICIANS', 'DO WELL IN SCHOOL?', 'GOOD AT TRICK TESTS!', ''] },
  { type: 'joke', lines: ['', 'WHATS A TEACHERS', 'FAVORITE NATION?', 'EXPLA-NATION!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE CLOCK', 'GET SENT TO OFFICE?', 'IT TOCKED TOO MUCH!', ''] },
  { type: 'joke', lines: ['', 'WHATS A PIRATES', 'FAVORITE LETTER?', 'YOU THINK ITS RRRR!', ''] },
  { type: 'joke', lines: ['', 'HOW DID THE MUSIC', 'TEACHER GET LOCKED OUT', 'SHE LOST HER KEYS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID ZERO SAY', 'TO EIGHT?', 'NICE BELT!', ''] },
  { type: 'joke', lines: ['', 'WHY DO WE NEVER', 'TELL SECRETS IN CLASS?', 'TOO MANY RULERS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO LIBRARIANS', 'TAKE FISHING?', 'BOOKWORMS!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE PENCIL', 'WIN THE AWARD?', 'IT WAS SHARP!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE PAPER', 'SAY TO THE PENCIL?', 'WRITE ON!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO MATH', 'TEACHERS EAT?', 'SQUARE MEALS!', ''] },
  { type: 'joke', lines: ['', 'WHY IS SIX AFRAID', 'OF SEVEN?', '7 ATE 9!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A NUMBER THAT MOVES?', 'A ROAMIN NUMERAL!', ''] },
  { type: 'joke', lines: ['', 'WHY IS HISTORY', 'LIKE A FRUIT CAKE?', 'FULL OF DATES!', ''] },
  { type: 'joke', lines: ['', 'WHATS THE SMARTEST', 'INSECT?', 'A SPELLING BEE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID SCIENCE', 'SAY TO ART?', 'YOU HAVE NO CLASS!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE GYM', 'TEACHER GO TO BEACH?', 'TO TEST THE WATERS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO COMPUTERS', 'SNACK ON?', 'MICRO CHIPS!', ''] },
  // SILLY/EVERYDAY (55)
  { type: 'joke', lines: ['', 'WHY DID THE BICYCLE', 'FALL OVER?', 'IT WAS TWO-TIRED!', ''] },
  { type: 'joke', lines: ['', 'WHATS BROWN', 'AND STICKY?', 'A STICK!', ''] },
  { type: 'joke', lines: ['', 'I DONT TRUST', 'STAIRS', 'ALWAYS UP TO STUFF!', ''] },
  { type: 'joke', lines: ['', 'WHY CANT YOUR NOSE', 'BE 12 INCHES LONG?', "THEN IT'D BE A FOOT!", ''] },
  { type: 'joke', lines: ['', 'WHAT HAS HANDS', 'BUT CANT CLAP?', 'A CLOCK!', ''] },
  { type: 'joke', lines: ['', 'WHAT HAS A HEAD', 'AND A TAIL BUT NO BODY', 'A COIN!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE GOLFER', 'BRING TWO PANTS?', 'HOLE IN ONE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A BOOMERANG THAT', 'WONT COME BACK? STICK', ''] },
  { type: 'joke', lines: ['', 'HOW DO YOU', 'ORGANIZE A SPACE PARTY', 'YOU PLANET!', ''] },
  { type: 'joke', lines: ['', 'HOW DOES THE MOON', 'CUT HIS HAIR?', 'ECLIPSE IT!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE PICTURE', 'GO TO JAIL?', 'IT WAS FRAMED!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO CLOUDS', 'WEAR UNDERNEATH?', 'THUNDERWEAR!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A FUNNY MOUNTAIN?', 'HILL-ARIOUS!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE BELT', 'GET ARRESTED?', 'HELD UP SOME PANTS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A SNOWMAN IN SUMMER?', 'A PUDDLE!', ''] },
  { type: 'joke', lines: ['', 'WHAT FALLS BUT', 'NEVER GETS HURT?', 'RAIN!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE SCARECROW', 'WIN AN AWARD?', 'OUTSTANDING IN FIELD', ''] },
  { type: 'joke', lines: ['', 'HOW DO MOUNTAINS', 'SEE?', 'THEY PEAK!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID ONE WALL', 'SAY TO THE OTHER?', 'MEET YOU AT CORNER!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID ONE HAT', 'SAY TO THE OTHER?', 'YOU WAIT HERE!', ''] },
  { type: 'joke', lines: ['', 'WHY DO BALLOONS', 'HATE GOING TO SCHOOL?', 'POP QUIZZES!', ''] },
  { type: 'joke', lines: ['', 'HOW DO YOU CATCH', 'A SQUIRREL?', 'ACT LIKE A NUT!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE OCEAN', 'SAY TO THE BEACH?', 'NOTHING IT WAVED!', ''] },
  { type: 'joke', lines: ['', 'WHY CANT YOU', 'GIVE ELSA A BALLOON?', "SHE'LL LET IT GO!", ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A TRAIN THAT SNEEZES?', 'ACHOO CHOO TRAIN!', ''] },
  { type: 'joke', lines: ['', 'WHAT ROOM HAS', 'NO DOORS OR WINDOWS?', 'A MUSHROOM!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE MATH', 'TEACHER GO OUTSIDE?', 'TO USE A PRO-TRACTOR', ''] },
  { type: 'joke', lines: ['', 'HOW DO TREES', 'GET ON THE INTERNET?', 'THEY LOG IN!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE TEDDY', 'BEAR SKIP DESSERT?', 'IT WAS STUFFED!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID ONE TOILET', 'SAY TO THE OTHER?', 'YOU LOOK FLUSHED!', ''] },
  { type: 'joke', lines: ['', 'WHY WAS THE ROBOT', 'SO TIRED?', 'HAD A HARD DRIVE!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE SHOE', 'GO TO THE DOCTOR?', 'IT HAD LOST ITS SOLE', ''] },
  { type: 'joke', lines: ['', 'WHAT DO DENTISTS', 'CALL THEIR X-RAYS?', 'TOOTH PICS!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE PHONE', 'WEAR GLASSES?', 'LOST ITS CONTACTS!', ''] },
  { type: 'joke', lines: ['', 'WHATS A VAMPIRES', 'FAVORITE FRUIT?', 'A BLOOD ORANGE!', ''] },
  { type: 'joke', lines: ['', 'WHY DO GHOSTS', 'MAKE BAD LIARS?', 'YOU SEE THROUGH EM!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO SKELETONS', 'ORDER AT A CAFE?', 'SPARE RIBS!', ''] },
  { type: 'joke', lines: ['', 'WHY CANT SKELETONS', 'FIGHT EACH OTHER?', 'NO GUTS!', ''] },
  { type: 'joke', lines: ['', 'WHY WAS THE', 'COMPUTER COLD?', 'LEFT ITS WINDOWS OPEN', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE LAMP', 'GO TO SCHOOL?', 'TO GET BRIGHTER!', ''] },
  { type: 'joke', lines: ['', 'HOW DOES A PENGUIN', 'BUILD ITS HOUSE?', 'IGLOOS IT TOGETHER!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE', 'STAMP SAY TO ENVELOPE', 'STICK WITH ME!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE TRAFFIC', 'LIGHT SAY TO THE CAR?', 'DONT LOOK I CHANGE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE LEFT', 'EYE SAY TO THE RIGHT?', 'BETWEEN US SOMETHING', ''] },
  { type: 'joke', lines: ['', 'HOW DOES A BARBER', 'WIN A RACE?', 'HE KNOWS A SHORTCUT', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'A CAN OPENER THATS', 'BROKEN? CANT OPENER', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE KID', 'BRING A CLOCK TO LUNCH', 'HE WANTED SECONDS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE JANITOR', 'SAY WHEN HE JUMPED OUT', 'SUPPLIES!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO ASTRONAUTS', 'EAT FOR DINNER?', 'LAUNCH!', ''] },
  { type: 'joke', lines: ['', 'WHY DO WE TELL', 'ACTORS TO BREAK A LEG?', 'EVERY PLAY HAS CAST!', ''] },
  // SCIENCE & NATURE (25)
  { type: 'joke', lines: ['', 'WHAT IS A TORNADOS', 'FAVORITE GAME?', 'TWISTER!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID EARTH SAY', 'TO THE OTHER PLANETS?', 'YOU HAVE NO LIFE!', ''] },
  { type: 'joke', lines: ['', 'WHY DOES THE MOON', 'NEED A LOAN?', 'ITS DOWN TO QUARTER!', ''] },
  { type: 'joke', lines: ['', 'WHY CANT FLOWERS', 'RIDE A BICYCLE?', 'NO PETALS! OH WAIT!', ''] },
  { type: 'joke', lines: ['', 'WHAT IS A ROCKS', 'FAVORITE MUSIC?', 'ROCK AND ROLL!', ''] },
  { type: 'joke', lines: ['', 'WHY DO VOLCANOES', 'GET INVITED OUT?', "THEY'RE A BLAST!", ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE BIG', 'FLOWER SAY TO SMALL?', 'HEY THERE BUD!', ''] },
  { type: 'joke', lines: ['', 'WHAT RUNS BUT', 'NEVER GETS TIRED?', 'WATER!', ''] },
  { type: 'joke', lines: ['', 'HOW MUCH DOES IT', 'COST TO GO TO SPACE?', 'A LOT OF BUCKS!', ''] },
  { type: 'joke', lines: ['', 'WHAT KIND OF MUSIC', 'DO PLANETS LISTEN TO?', 'NEPTUNES!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE LEAF', 'GO TO THE DOCTOR?', 'FEELING GREEN!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO CLOUDS DO', 'WHEN THEY GET RICH?', 'MAKE IT RAIN!', ''] },
  { type: 'joke', lines: ['', 'WHY IS THE GRASS', 'SO DANGEROUS?', 'FULL OF BLADES!', ''] },
  { type: 'joke', lines: ['', 'HOW DO SCIENTISTS', 'FRESHEN THEIR BREATH?', 'EXPERI-MINTS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU DO', 'WITH A SICK CHEMIST?', 'CANT HELIUM CANT', ''] },
  { type: 'joke', lines: ['', 'WHAT IS A LIGHT', 'YEARS FAVORITE SNACK?', 'MARS BARS!', ''] },
  { type: 'joke', lines: ['', 'WHY ARE ATOMS', 'ALWAYS LYING?', 'THEY MAKE EVERYTHING', ''] },
  { type: 'joke', lines: ['', 'WHAT DID MARS SAY', 'TO SATURN?', 'GIVE ME A RING!', ''] },
  { type: 'joke', lines: ['', 'HOW DO YOU KNOW', 'THE OCEAN IS FRIENDLY?', 'IT WAVES!', ''] },
  { type: 'joke', lines: ['', 'WHY DID THE TREE', 'GO TO THE DENTIST?', 'ROOT CANAL!', ''] },
  { type: 'joke', lines: ['', 'WHAT IS WINDS', 'FAVORITE COLOR?', 'BLEW!', ''] },
  { type: 'joke', lines: ['', 'WHY DO HURRICANES', 'HAVE NAMES?', "THEY'D GET LOST!", ''] },
  // POP CULTURE & MISC (25)
  { type: 'joke', lines: ['', 'WHY DID MARIO', 'GO TO THE DOCTOR?', 'MUSHROOM PROBLEMS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO MINIONS', 'CALL THEIR LEADER?', 'BANANA!', ''] },
  { type: 'joke', lines: ['', 'WHY DOES PETER PAN', 'ALWAYS FLY?', 'HE NEVERLANDS!', ''] },
  { type: 'joke', lines: ['', 'WHAT IS THORS', 'FAVORITE DAY?', 'THORS-DAY!', ''] },
  { type: 'joke', lines: ['', 'WHY WAS CINDERELLA', 'BAD AT SOCCER?', 'SHE RAN FROM BALL!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'SPIDERMAN ON A BREAK?', 'PETER PARKER!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'SHREK AT THE BEACH?', 'AN OGRE-TAN!', ''] },
  { type: 'joke', lines: ['', 'WHY DID YODA GO', 'TO THE BANK?', 'NEED A FORCE DEPOSIT', ''] },
  { type: 'joke', lines: ['', 'WHAT DOES IRONMAN', 'AND SILVER SURFER MAKE', 'ALLOYS!', ''] },
  { type: 'joke', lines: ['', 'HOW DOES DARTH', 'VADER LIKE HIS TOAST?', 'ON THE DARK SIDE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'ELSA WITH A SUNBURN?', 'MELTDOWN!', ''] },
  { type: 'joke', lines: ['', 'WHY IS GROOT', 'BAD AT TESTS?', 'HE ONLY KNOWS ONE!', ''] },
  { type: 'joke', lines: ['', 'WHAT DOES SONIC', 'EAT FOR BREAKFAST?', 'FAST FOOD!', ''] },
  { type: 'joke', lines: ['', 'HOW DOES PIKACHU', 'SAY HELLO?', 'WATTS UP!', ''] },
  { type: 'joke', lines: ['', 'WHY CANT HARRY', 'POTTER TELL JOKES?', 'RIDDIKULUS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DO YOU CALL', 'HOGWARTS WITHOUT MAGIC', 'BORING SCHOOL!', ''] },
  { type: 'joke', lines: ['', 'WHY DID SPONGEBOB', 'FAIL HIS TEST?', 'BELOW C LEVEL!', ''] },
  { type: 'joke', lines: ['', 'WHY WAS THE', 'MATH WIZARD SO COOL?', 'HAD TOO MANY FANS!', ''] },
  { type: 'joke', lines: ['', 'WHAT DID THE', 'POKEMON SAY AT EASTER?', 'PIKACHU EGGS!', ''] },
  { type: 'joke', lines: ['', 'WHAT CAR DOES', 'LUKE SKYWALKER DRIVE?', 'A TOY-YODA!', ''] },
  { type: 'joke', lines: ['', 'WHY DID GOLLUM', 'GO TO THERAPY?', 'RING ATTACHMENT ISSUE', ''] }
];

// --- RIDDLES (30) — type: 'riddle' with question/answer pairs ---

const RIDDLES = [
  { type: 'riddle', question: ['', 'I HAVE HANDS BUT', 'CANT CLAP', 'WHAT AM I?', ''], answer: ['', '', 'A CLOCK!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE A HEAD AND', 'A TAIL BUT NO BODY', 'WHAT AM I?', ''], answer: ['', '', 'A COIN!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS KEYS BUT', 'CANT OPEN LOCKS?', '', ''], answer: ['', '', 'A PIANO!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS LEGS BUT', 'DOESNT WALK?', '', ''], answer: ['', '', 'A TABLE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT CAN YOU CATCH', 'BUT NOT THROW?', '', ''], answer: ['', '', 'A COLD!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT GOES UP BUT', 'NEVER COMES DOWN?', '', ''], answer: ['', '', 'YOUR AGE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS WORDS BUT', 'NEVER SPEAKS?', '', ''], answer: ['', '', 'A BOOK!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS A NECK', 'BUT NO HEAD?', '', ''], answer: ['', '', 'A BOTTLE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS TEETH BUT', 'CANT EAT?', '', ''], answer: ['', '', 'A COMB!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT CAN TRAVEL', 'AROUND THE WORLD', 'STAYING IN A CORNER?', ''], answer: ['', '', 'A STAMP!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT GETS WETTER', 'THE MORE IT DRIES?', '', ''], answer: ['', '', 'A TOWEL!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS ONE EYE', 'BUT CANT SEE?', '', ''], answer: ['', '', 'A NEEDLE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT CAN FILL A', 'ROOM BUT TAKES', 'NO SPACE?', ''], answer: ['', '', 'LIGHT!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT INVENTION', 'LETS YOU LOOK RIGHT', 'THROUGH A WALL?', ''], answer: ['', '', 'A WINDOW!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS A THUMB', 'AND FOUR FINGERS', 'BUT IS NOT A HAND?', ''], answer: ['', '', 'A GLOVE!', '', ''] },
  { type: 'riddle', question: ['', 'I FOLLOW YOU ALL', 'DAY BUT DISAPPEAR', 'AT NIGHT WHAT AM I?', ''], answer: ['', '', 'YOUR SHADOW!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS CITIES', 'BUT NO HOUSES?', '', ''], answer: ['', '', 'A MAP!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT CAN YOU BREAK', 'WITHOUT TOUCHING IT?', '', ''], answer: ['', '', 'A PROMISE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT GOES THROUGH', 'TOWNS AND OVER HILLS', 'BUT DOESNT MOVE?', ''], answer: ['', '', 'A ROAD!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS BARK', 'BUT IS NOT A DOG?', '', ''], answer: ['', '', 'A TREE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT RUNS BUT', 'NEVER WALKS?', '', ''], answer: ['', '', 'WATER!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT BUILDING HAS', 'THE MOST STORIES?', '', ''], answer: ['', '', 'A LIBRARY!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS EARS', 'BUT CANNOT HEAR?', '', ''], answer: ['', '', 'CORN!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT CAN BE', 'CRACKED AND MADE', 'TOLD AND PLAYED?', ''], answer: ['', '', 'A JOKE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT HAS A RING', 'BUT NO FINGER?', '', ''], answer: ['', '', 'A PHONE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT TASTES BETTER', 'THAN IT SMELLS?', '', ''], answer: ['', '', 'YOUR TONGUE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT GETS BIGGER', 'THE MORE YOU TAKE AWAY', '', ''], answer: ['', '', 'A HOLE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT BELONGS TO', 'YOU BUT OTHERS USE', 'MORE THAN YOU?', ''], answer: ['', '', 'YOUR NAME!', '', ''] },
  { type: 'riddle', question: ['', 'THE MORE YOU HAVE', 'THE LESS YOU SEE', 'WHAT IS IT?', ''], answer: ['', '', 'DARKNESS!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT CAN RUN BUT', 'NEVER WALKS HAS A', 'MOUTH BUT NEVER TALKS?', ''], answer: ['', '', 'A RIVER!', '', ''] }
];

// --- KNOCK-KNOCK JOKES (15) ---

const KNOCK_KNOCKS = [
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'LETTUCE', ''], answer: ['', 'LETTUCE WHO?', 'LETTUCE IN ITS COLD!', '', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'BOO', ''], answer: ['', 'BOO WHO?', 'DONT CRY ITS JUST ME', '', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'ORANGE', ''], answer: ['', 'ORANGE WHO?', 'ORANGE YOU GLAD', 'I DIDNT SAY BANANA?', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'NOBEL', ''], answer: ['', 'NOBEL WHO?', 'NOBEL SO I KNOCKED!', '', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'TANK', ''], answer: ['', 'TANK WHO?', 'YOURE WELCOME!', '', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'ATCH', ''], answer: ['', 'ATCH WHO?', 'BLESS YOU!', '', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'WHO', ''], answer: ['', 'WHO WHO?', 'IS THERE AN OWL', 'IN HERE?', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'COW', ''], answer: ['', 'COW WHO?', 'NO A COW SAYS MOO!', '', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'DISHES', ''], answer: ['', 'DISHES WHO?', 'DISHES THE POLICE', 'OPEN UP!', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'HARRY', ''], answer: ['', 'HARRY WHO?', 'HARRY UP ITS COLD!', '', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'WOODEN SHOE', ''], answer: ['', 'WOODEN SHOE WHO?', 'WOODEN SHOE LIKE', 'TO HEAR A JOKE?', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'ICE CREAM', ''], answer: ['', 'ICE CREAM WHO?', 'ICE CREAM EVERY', 'TIME I SEE A BUG!', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'BANANA', ''], answer: ['', 'BANANA WHO?', 'KNOCK KNOCK', 'ORANGE YOU GLAD?', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'INTERRUPTING COW', ''], answer: ['', 'INTERRUPTING C--', 'MOOOOO!', '', ''] },
  { type: 'riddle', question: ['', 'KNOCK KNOCK', 'WHOS THERE?', 'BROCCOLI', ''], answer: ['', 'BROCCOLI WHO?', 'BROCCOLI DOESNT', 'HAVE A LAST NAME!', ''] }
];

// --- FUN FACTS (15) ---

const FUN_FACTS = [
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'A GROUP OF FLAMINGOS', 'IS A FLAMBOYANCE', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'HONEY NEVER', 'GOES BAD EVER!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'OCTOPUSES HAVE', 'THREE HEARTS!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'BANANAS ARE', 'ACTUALLY BERRIES!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'A SNAIL CAN SLEEP', 'FOR THREE YEARS!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'COWS HAVE', 'BEST FRIENDS!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'YOUR NOSE CAN SMELL', 'ONE TRILLION SCENTS', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'DOLPHINS SLEEP WITH', 'ONE EYE OPEN!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'A SHRIMP HAS ITS', 'HEART IN ITS HEAD!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'FROGS DRINK WATER', 'THROUGH THEIR SKIN!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'BUTTERFLIES TASTE', 'WITH THEIR FEET!', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'SEA OTTERS HOLD', 'HANDS WHEN SLEEPING', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'A BOLT OF LIGHTNING', 'IS FIVE TIMES HOTTER', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'YOUR BONES ARE', 'STRONGER THAN STEEL', ''] },
  { type: 'fact', lines: ['', 'DID YOU KNOW?', 'CATS SPEND 70 PERCENT', 'OF THEIR LIFE NAPPING', ''] }
];

// --- SPACE FACTS (15) ---

const SPACE_FACTS = [
  { type: 'fact', lines: ['', 'SPACE FACT!', 'JUPITER HAS', '95 MOONS', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'THE SUN IS A STAR', 'NOT A PLANET', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'ONE DAY ON VENUS', 'IS 243 EARTH DAYS', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'SATURN COULD FLOAT', 'IN A GIANT BATHTUB', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'THE MOON HAS', 'NO WIND AT ALL', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'MARS IS CALLED', 'THE RED PLANET', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'SPACE IS TOTALLY', 'SILENT', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'A YEAR ON MERCURY', 'IS JUST 88 DAYS', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'NEPTUNE HAS', 'SUPERSONIC WINDS', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'YOU WEIGH LESS', 'ON THE MOON', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'THE SUN IS 93', 'MILLION MILES AWAY', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'THERE ARE MORE STARS', 'THAN GRAINS OF SAND', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'FOOTPRINTS ON THE', 'MOON LAST FOREVER', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'EARTH SPINS AT', '1000 MILES PER HOUR', ''] },
  { type: 'fact', lines: ['', 'SPACE FACT!', 'ASTRONAUTS GROW', 'TALLER IN SPACE', ''] }
];

// --- VOCABULARY (15) ---

const VOCABULARY = [
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'COURAGEOUS', '', ''], answer: ['', 'COURAGEOUS MEANS', 'BRAVE AND NOT', 'AFRAID', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'ENORMOUS', '', ''], answer: ['', 'ENORMOUS MEANS', 'REALLY REALLY', 'BIG', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'PECULIAR', '', ''], answer: ['', 'PECULIAR MEANS', 'STRANGE OR', 'UNUSUAL', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'BRILLIANT', '', ''], answer: ['', 'BRILLIANT MEANS', 'VERY SMART OR', 'VERY BRIGHT', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'DETERMINED', '', ''], answer: ['', 'DETERMINED MEANS', 'YOU WONT GIVE UP', 'NO MATTER WHAT', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'FAMISHED', '', ''], answer: ['', 'FAMISHED MEANS', 'SUPER DUPER', 'HUNGRY', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'FRAGILE', '', ''], answer: ['', 'FRAGILE MEANS', 'EASY TO BREAK', 'HANDLE WITH CARE', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'FURIOUS', '', ''], answer: ['', 'FURIOUS MEANS', 'REALLY REALLY', 'ANGRY', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'GENEROUS', '', ''], answer: ['', 'GENEROUS MEANS', 'HAPPY TO SHARE', 'WITH OTHERS', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'ANCIENT', '', ''], answer: ['', 'ANCIENT MEANS', 'VERY VERY OLD', 'LIKE DINOSAUR OLD', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'HAZARDOUS', '', ''], answer: ['', 'HAZARDOUS MEANS', 'DANGEROUS OR', 'NOT SAFE', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'MAGNIFICENT', '', ''], answer: ['', 'MAGNIFICENT MEANS', 'AMAZING AND', 'WONDERFUL', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'EXHAUSTED', '', ''], answer: ['', 'EXHAUSTED MEANS', 'SO TIRED YOU', 'CANT MOVE', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'ABSURD', '', ''], answer: ['', 'ABSURD MEANS', 'SO SILLY IT MAKES', 'NO SENSE AT ALL', ''] },
  { type: 'riddle', question: ['', 'WORD OF THE DAY', 'TRIUMPHANT', '', ''], answer: ['', 'TRIUMPHANT MEANS', 'YOU WON AND YOU', 'FEEL GREAT', ''] }
];

// --- MATH PUZZLES (15) ---

const MATH_PUZZLES = [
  { type: 'riddle', question: ['', '', 'WHAT IS 7 x 8?', '', ''], answer: ['', '', '56!', '', ''] },
  { type: 'riddle', question: ['', '', 'WHAT IS 9 x 6?', '', ''], answer: ['', '', '54!', '', ''] },
  { type: 'riddle', question: ['', '', 'WHAT IS 8 x 8?', '', ''], answer: ['', '', '64!', '', ''] },
  { type: 'riddle', question: ['', '', 'WHAT IS 12 x 4?', '', ''], answer: ['', '', '48!', '', ''] },
  { type: 'riddle', question: ['', '', 'WHAT IS 25 + 37?', '', ''], answer: ['', '', '62!', '', ''] },
  { type: 'riddle', question: ['', '', 'WHAT IS 48 + 36?', '', ''], answer: ['', '', '84!', '', ''] },
  { type: 'riddle', question: ['', '', 'WHAT IS 99 - 47?', '', ''], answer: ['', '', '52!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COMES NEXT?', '10  20  30  ...', '', ''], answer: ['', '', '40!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COMES NEXT?', '2  4  8  16  ...', '', ''], answer: ['', '', '32!', '', ''] },
  { type: 'riddle', question: ['', 'IF YOU HAVE 3 BAGS', 'WITH 6 APPLES EACH', 'HOW MANY APPLES?', ''], answer: ['', '', '18 APPLES!', '', ''] },
  { type: 'riddle', question: ['', 'A PIZZA HAS 8', 'SLICES AND YOU EAT 3', 'HOW MANY ARE LEFT?', ''], answer: ['', '', '5 SLICES!', '', ''] },
  { type: 'riddle', question: ['', '', 'WHAT IS 6 x 7?', '', ''], answer: ['', '', '42!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COMES NEXT?', '5  10  15  20  ...', '', ''], answer: ['', '', '25!', '', ''] },
  { type: 'riddle', question: ['', 'YOU HAVE 4 BOXES', 'WITH 5 CRAYONS EACH', 'HOW MANY CRAYONS?', ''], answer: ['', '', '20 CRAYONS!', '', ''] },
  { type: 'riddle', question: ['', '', 'WHAT IS 11 x 11?', '', ''], answer: ['', '', '121!', '', ''] }
];

// --- GEOGRAPHY FACTS (15) ---

const GEOGRAPHY = [
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'THE PACIFIC IS THE', 'BIGGEST OCEAN', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'MT EVEREST IS THE', 'TALLEST MOUNTAIN', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'THERE ARE SEVEN', 'CONTINENTS ON EARTH', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'THE NILE IS THE', 'LONGEST RIVER', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'VATICAN CITY IS THE', 'SMALLEST COUNTRY', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'ANTARCTICA IS THE', 'COLDEST CONTINENT', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'SAHARA IS THE', 'LARGEST HOT DESERT', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'EARTH HAS FIVE', 'OCEANS', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'MARIANA TRENCH IS', 'THE DEEPEST POINT', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'AMAZON RAINFOREST', 'IS THE LARGEST', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'AUSTRALIA IS BOTH', 'COUNTRY AND CONTINENT', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'RUSSIA IS THE', 'BIGGEST COUNTRY', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'AFRICA HAS 54', 'COUNTRIES', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'THE DEAD SEA IS', 'THE LOWEST POINT', ''] },
  { type: 'fact', lines: ['', 'GEOGRAPHY FACT!', 'GREENLAND IS THE', 'BIGGEST ISLAND', ''] }
];

// --- SEASONAL FACTS (20) ---

const SEASONAL_FACTS = [
  { type: 'fact', lines: ['', 'SPRING FACT!', 'BABY ANIMALS ARE', 'BORN IN SPRING', ''] },
  { type: 'fact', lines: ['', 'SPRING FACT!', 'FLOWERS START TO', 'BLOOM IN SPRING', ''] },
  { type: 'fact', lines: ['', 'SPRING FACT!', 'DAYS GET LONGER', 'IN SPRINGTIME', ''] },
  { type: 'fact', lines: ['', 'SPRING FACT!', 'BUTTERFLIES COME', 'BACK IN SPRING', ''] },
  { type: 'fact', lines: ['', 'SPRING FACT!', 'APRIL SHOWERS BRING', 'MAY FLOWERS', ''] },
  { type: 'fact', lines: ['', 'SUMMER FACT!', 'JUNE 21 IS THE', 'LONGEST DAY', ''] },
  { type: 'fact', lines: ['', 'SUMMER FACT!', 'FIREFLIES GLOW TO', 'FIND THEIR FRIENDS', ''] },
  { type: 'fact', lines: ['', 'SUMMER FACT!', 'THE SUN DOESNT SET', 'IN PARTS OF ALASKA', ''] },
  { type: 'fact', lines: ['', 'SUMMER FACT!', 'ICE CREAM WAS', 'INVENTED IN CHINA', ''] },
  { type: 'fact', lines: ['', 'SUMMER FACT!', 'WATERMELONS ARE', '92 PERCENT WATER', ''] },
  { type: 'fact', lines: ['', 'FALL FACT!', 'LEAVES CHANGE COLOR', 'BECAUSE LESS SUNLIGHT', ''] },
  { type: 'fact', lines: ['', 'FALL FACT!', 'BIRDS FLY SOUTH', 'FOR THE WINTER', ''] },
  { type: 'fact', lines: ['', 'FALL FACT!', 'SQUIRRELS HIDE NUTS', 'FOR THE WINTER', ''] },
  { type: 'fact', lines: ['', 'FALL FACT!', 'FALL IS ALSO CALLED', 'AUTUMN', ''] },
  { type: 'fact', lines: ['', 'FALL FACT!', 'PUMPKINS ARE FRUIT', 'NOT VEGETABLES', ''] },
  { type: 'fact', lines: ['', 'WINTER FACT!', 'NO TWO SNOWFLAKES', 'ARE THE SAME', ''] },
  { type: 'fact', lines: ['', 'WINTER FACT!', 'BEARS HIBERNATE', 'ALL WINTER LONG', ''] },
  { type: 'fact', lines: ['', 'WINTER FACT!', 'DEC 21 IS THE', 'SHORTEST DAY', ''] },
  { type: 'fact', lines: ['', 'WINTER FACT!', 'AURORA BOREALIS IS', 'THE NORTHERN LIGHTS', ''] },
  { type: 'fact', lines: ['', 'WINTER FACT!', 'SOME LAKES FREEZE', 'SOLID IN WINTER', ''] }
];

// --- UNSCRAMBLE PUZZLES (15) ---

const UNSCRAMBLE = [
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'NCOEA', '', ''], answer: ['', '', 'OCEAN!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'LENPAT', '', ''], answer: ['', '', 'PLANET!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'TIRGUA', '', ''], answer: ['', '', 'GUITAR!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'KNYEMO', '', ''], answer: ['', '', 'MONKEY!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'GRAODN', '', ''], answer: ['', '', 'DRAGON!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'STACLE', '', ''], answer: ['', '', 'CASTLE!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'TRIPAE', '', ''], answer: ['', '', 'PIRATE!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'CKROTE', '', ''], answer: ['', '', 'ROCKET!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'GLNUJE', '', ''], answer: ['', '', 'JUNGLE!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'HPINDOL', '', ''], answer: ['', '', 'DOLPHIN!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'WBORANI', '', ''], answer: ['', '', 'RAINBOW!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'COLVANO', '', ''], answer: ['', '', 'VOLCANO!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'GUNEPIN', '', ''], answer: ['', '', 'PENGUIN!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'SAUNIROD', '', ''], answer: ['', '', 'DINOSAUR!', '', ''] },
  { type: 'riddle', question: ['', 'UNSCRAMBLE THIS!', 'SURTEARE', '', ''], answer: ['', '', 'TREASURE!', '', ''] }
];

// --- ROCK PAPER SCISSORS (3) ---
export const ROCK_PAPER_SCISSORS = [
  { type: 'riddle', question: ['', 'ROCK PAPER SCISSORS', 'SHOOT!', '', ''], answer: ['', '', 'ROCK!', '', ''] },
  { type: 'riddle', question: ['', 'ROCK PAPER SCISSORS', 'SHOOT!', '', ''], answer: ['', '', 'PAPER!', '', ''] },
  { type: 'riddle', question: ['', 'ROCK PAPER SCISSORS', 'SHOOT!', '', ''], answer: ['', '', 'SCISSORS!', '', ''] },
];

// --- COLOR MIXING (10) ---
const COLOR_MIXING = [
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'RED + YELLOW = ?', '', ''], answer: ['', '', 'ORANGE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'RED + BLUE = ?', '', ''], answer: ['', '', 'PURPLE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'BLUE + YELLOW = ?', '', ''], answer: ['', '', 'GREEN!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'RED + WHITE = ?', '', ''], answer: ['', '', 'PINK!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'BLACK + WHITE = ?', '', ''], answer: ['', '', 'GRAY!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'RED + GREEN = ?', '', ''], answer: ['', '', 'BROWN!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'BLUE + WHITE = ?', '', ''], answer: ['', '', 'LIGHT BLUE!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'YELLOW + WHITE = ?', '', ''], answer: ['', '', 'CREAM!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'RED + BLACK = ?', '', ''], answer: ['', '', 'MAROON!', '', ''] },
  { type: 'riddle', question: ['', 'WHAT COLOR DO YOU GET', 'BLUE + GREEN = ?', '', ''], answer: ['', '', 'TEAL!', '', ''] },
];

// --- HISTORY MODE CONTENT ---

const HISTORY_EVENTS = [
  { type: 'fact', lines: ['HISTORY FACT!', 'THE GREAT WALL TOOK', 'OVER 2000 YEARS', 'TO BUILD', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'ANCIENT EGYPT LASTED', 'OVER 3000 YEARS', '', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE ROMAN EMPIRE', 'LASTED OVER', '1000 YEARS', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'VIKINGS REACHED', 'NORTH AMERICA', 'BEFORE COLUMBUS', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE BLACK PLAGUE', 'KILLED 1/3 OF', 'EUROPE', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'CLEOPATRA LIVED', 'CLOSER TO THE MOON', 'LANDING THAN PYRAMIDS', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE RENAISSANCE', 'BEGAN IN ITALY', 'IN THE 1300S', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'WORLD WAR 1 LASTED', 'FOUR YEARS', '1914 TO 1918', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'WORLD WAR 2 ENDED', 'IN 1945', '', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE SPACE RACE', 'BEGAN IN 1957', '', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'HUMANS LANDED ON', 'THE MOON IN 1969', '', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE BERLIN WALL', 'FELL IN 1989', '', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE TITANIC SANK', 'ON ITS FIRST VOYAGE', 'IN 1912', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'POMPEII WAS BURIED', 'BY A VOLCANO', 'IN 79 AD', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE SILK ROAD', 'CONNECTED EAST', 'AND WEST FOR TRADE', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'DINOSAURS WENT', 'EXTINCT 65 MILLION', 'YEARS AGO', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE ICE AGE ENDED', 'ABOUT 11700', 'YEARS AGO', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'JULIUS CAESAR WAS', 'RULER OF ROME', 'OVER 2000 YEARS AGO', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'ANCIENT GREEKS', 'INVENTED THE', 'OLYMPIC GAMES', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE MAYANS HAD', 'ADVANCED MATH AND', 'ASTRONOMY', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'GENGHIS KHAN BUILT', 'THE LARGEST LAND', 'EMPIRE EVER', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE COLD WAR LASTED', 'FROM 1947 TO 1991', '', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'MACHU PICCHU WAS', 'BUILT IN THE 1400S', 'BY THE INCA', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE FRENCH', 'REVOLUTION BEGAN', 'IN 1789', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'STONEHENGE IS OVER', '5000 YEARS OLD', '', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'NAPOLEON WAS', 'EMPEROR OF FRANCE', 'IN THE 1800S', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE AZTEC EMPIRE', 'WAS IN MEXICO', 'IN THE 1400S', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'ALEXANDER THE GREAT', 'CONQUERED MUCH OF', 'THE KNOWN WORLD', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE OTTOMAN EMPIRE', 'LASTED OVER', '600 YEARS', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'ANCIENT CHINA', 'INVENTED PAPER', 'AROUND 100 AD', ''] },
];

const HISTORY_QUOTES = [
  { type: 'quote', lines: ['', 'I HAVE A DREAM', 'THAT ONE DAY...', '- MARTIN LUTHER KING', ''] },
  { type: 'quote', lines: ['', 'BE THE CHANGE YOU', 'WISH TO SEE', '- GANDHI', ''] },
  { type: 'quote', lines: ['', 'WE SHALL FIGHT ON', 'THE BEACHES', '- CHURCHILL', ''] },
  { type: 'quote', lines: ['', 'NEVER NEVER NEVER', 'GIVE UP', '- CHURCHILL', ''] },
  { type: 'quote', lines: ['', 'THE ONLY THING WE', 'HAVE TO FEAR IS', '- FDR', ''] },
  { type: 'quote', lines: ['', 'THAT IS ONE SMALL', 'STEP FOR MAN', '- NEIL ARMSTRONG', ''] },
  { type: 'quote', lines: ['', 'I THINK THEREFORE', 'I AM', '- DESCARTES', ''] },
  { type: 'quote', lines: ['', 'GIVE ME LIBERTY OR', 'GIVE ME DEATH', '- PATRICK HENRY', ''] },
  { type: 'quote', lines: ['', 'THE PEN IS MIGHTIER', 'THAN THE SWORD', '- BULWER-LYTTON', ''] },
  { type: 'quote', lines: ['', 'ADVENTURE IS', 'WORTHWHILE', '- AMELIA EARHART', ''] },
  { type: 'quote', lines: ['', 'NO ONE CAN MAKE YOU', 'FEEL INFERIOR', '- ELEANOR ROOSEVELT', ''] },
  { type: 'quote', lines: ['', 'STAND FOR SOMETHING', 'OR FALL FOR ANYTHING', '- ROSA PARKS', ''] },
  { type: 'quote', lines: ['', 'A HOUSE DIVIDED', 'CANNOT STAND', '- ABRAHAM LINCOLN', ''] },
  { type: 'quote', lines: ['', 'FOUR SCORE AND', 'SEVEN YEARS AGO', '- ABRAHAM LINCOLN', ''] },
  { type: 'quote', lines: ['', 'KNOWLEDGE IS POWER', '', '- FRANCIS BACON', ''] },
  { type: 'quote', lines: ['', 'VENI VIDI VICI', 'I CAME I SAW', '- JULIUS CAESAR', ''] },
  { type: 'quote', lines: ['', 'EUREKA!', 'I HAVE FOUND IT', '- ARCHIMEDES', ''] },
  { type: 'quote', lines: ['', 'INJUSTICE ANYWHERE', 'IS A THREAT', '- MARTIN LUTHER KING', ''] },
  { type: 'quote', lines: ['', 'AN EYE FOR AN EYE', 'MAKES THE WORLD', '- GANDHI', ''] },
  { type: 'quote', lines: ['', 'WE SHALL OVERCOME', '', '- CIVIL RIGHTS ERA', ''] },
  { type: 'quote', lines: ['', 'ASK NOT WHAT YOUR', 'COUNTRY CAN DO', '- JFK', ''] },
  { type: 'quote', lines: ['', 'THE FUTURE BELONGS', 'TO THOSE WHO BELIEVE', '- ELEANOR ROOSEVELT', ''] },
  { type: 'quote', lines: ['', 'IMAGINATION IS MORE', 'IMPORTANT THAN', '- EINSTEIN', ''] },
  { type: 'quote', lines: ['', 'I WILL FIND A WAY', 'OR MAKE ONE', '- HANNIBAL BARCA', ''] },
  { type: 'quote', lines: ['', 'IN THE MIDDLE OF', 'DIFFICULTY LIES', '- EINSTEIN', ''] },
  { type: 'quote', lines: ['', 'WELL BEHAVED WOMEN', 'SELDOM MAKE HISTORY', '- LAUREL ULRICH', ''] },
  { type: 'quote', lines: ['', 'NOT EVERYTHING THAT', 'COUNTS CAN BE', '- EINSTEIN', ''] },
  { type: 'quote', lines: ['', 'THE TRUTH WILL', 'SET YOU FREE', '- ANCIENT PROVERB', ''] },
  { type: 'quote', lines: ['', 'THOSE WHO DO NOT', 'LEARN FROM HISTORY', '- SANTAYANA', ''] },
  { type: 'quote', lines: ['', 'TO BE OR NOT TO BE', 'THAT IS THE QUESTION', '- SHAKESPEARE', ''] },
];

const HISTORY_MILESTONES = [
  { type: 'fact', lines: ['MILESTONE!', 'THE WHEEL INVENTED', 'AROUND 3500 BC', '', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'WRITING INVENTED', 'AROUND 3400 BC', 'IN MESOPOTAMIA', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'PRINTING PRESS', 'INVENTED IN 1440', 'BY GUTENBERG', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'DEMOCRACY BEGAN', 'IN ATHENS GREECE', 'AROUND 500 BC', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'AGRICULTURE BEGAN', 'ABOUT 10000', 'YEARS AGO', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'ELECTRICITY FIRST', 'HARNESSED IN THE', '1800S', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'THE COMPASS WAS', 'INVENTED IN CHINA', 'AROUND 200 BC', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'GUNPOWDER INVENTED', 'IN CHINA AROUND', '850 AD', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'THE TELEPHONE WAS', 'INVENTED IN 1876', 'BY BELL', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'THE LIGHT BULB', 'INVENTED 1879', 'BY EDISON', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'PENICILLIN WAS', 'DISCOVERED IN 1928', 'BY FLEMING', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'THE INTERNET BEGAN', 'IN 1969 AS ARPANET', '', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'IRON SMELTING', 'BEGAN AROUND', '1200 BC', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'THE STEAM ENGINE', 'STARTED THE', 'INDUSTRIAL AGE', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'PAPER MONEY FIRST', 'USED IN CHINA', 'AROUND 700 AD', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'GLASS WAS INVENTED', 'AROUND 3500 BC', 'IN MESOPOTAMIA', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'THE CALENDAR WAS', 'CREATED BY ANCIENT', 'EGYPTIANS', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'CONCRETE INVENTED', 'BY THE ROMANS', 'AROUND 300 BC', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'THE FIRST VACCINE', 'WAS GIVEN IN 1796', 'BY JENNER', ''] },
  { type: 'fact', lines: ['MILESTONE!', 'DNA STRUCTURE FOUND', 'IN 1953 BY WATSON', 'AND CRICK', ''] },
];

const HISTORY_FIRSTS = [
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST FLIGHT 1903', 'BY THE WRIGHT', 'BROTHERS', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST WOMAN IN', 'SPACE VALENTINA', 'TERESHKOVA 1963', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST PERSON IN', 'SPACE YURI GAGARIN', '1961', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST MOON LANDING', 'APOLLO 11 IN 1969', '', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST PHOTOGRAPH', 'TAKEN IN 1826', 'BY NIEPCE', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST EMAIL SENT', 'IN 1971', 'BY RAY TOMLINSON', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST CAR BUILT', 'IN 1886 BY', 'KARL BENZ', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST PHONE CALL', 'MADE IN 1876', 'BY ALEXANDER BELL', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST TV BROADCAST', 'IN 1928', 'IN LONDON', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST COMPUTER', 'BUILT IN 1945', 'CALLED ENIAC', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST SUBMARINE', 'TESTED IN 1620', '', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST OLYMPIC GAMES', 'HELD IN 776 BC', 'IN GREECE', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST WOMAN TO FLY', 'SOLO ACROSS THE', 'ATLANTIC - EARHART', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST BOOK PRINTED', 'IN 1455 THE', 'GUTENBERG BIBLE', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST SATELLITE', 'SPUTNIK LAUNCHED', '1957 BY USSR', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST HEART', 'TRANSPLANT 1967', 'BY DR BARNARD', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST NORTH POLE', 'REACHED IN 1909', 'BY PEARY', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST SOUTH POLE', 'REACHED IN 1911', 'BY AMUNDSEN', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST SUMMIT OF', 'EVEREST IN 1953', 'HILLARY + TENZING', ''] },
  { type: 'fact', lines: ['HISTORICAL FIRST!', 'FIRST ROVER ON MARS', 'SOJOURNER IN 1997', '', ''] },
];

const HISTORY_ON_THIS_DAY = [
  { type: 'fact', lines: ['ON THIS DAY', 'JAN 1 1863', 'EMANCIPATION', 'PROCLAMATION SIGNED', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'FEB 12 1809', 'ABRAHAM LINCOLN', 'WAS BORN', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'MAR 15 44 BC', 'JULIUS CAESAR WAS', 'ASSASSINATED', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'APR 15 1912', 'THE TITANIC SANK', 'IN THE ATLANTIC', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'MAY 29 1953', 'EVEREST WAS FIRST', 'CLIMBED', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'JUN 6 1944', 'D-DAY INVASION', 'OF NORMANDY', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'JUL 4 1776', 'DECLARATION OF', 'INDEPENDENCE SIGNED', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'JUL 20 1969', 'FIRST HUMANS', 'WALKED ON THE MOON', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'AUG 28 1963', 'MLK I HAVE A DREAM', 'SPEECH IN DC', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'SEP 1 1939', 'WORLD WAR 2 BEGAN', 'IN EUROPE', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'OCT 12 1492', 'COLUMBUS REACHED', 'THE AMERICAS', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'NOV 9 1989', 'THE BERLIN WALL', 'CAME DOWN', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'DEC 17 1903', 'THE WRIGHT BROTHERS', 'FIRST FLEW', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'APR 12 1961', 'YURI GAGARIN WENT', 'TO SPACE', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'NOV 11 1918', 'WORLD WAR 1', 'ENDED', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'OCT 29 1929', 'THE STOCK MARKET', 'CRASHED', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'JAN 30 1948', 'GANDHI BEGAN HIS', 'LEGACY OF PEACE', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'MAR 12 1930', 'GANDHI BEGAN THE', 'SALT MARCH', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'AUG 6 1945', 'FIRST ATOMIC BOMB', 'USED IN WAR', ''] },
  { type: 'fact', lines: ['ON THIS DAY', 'FEB 4 2004', 'FACEBOOK WAS', 'LAUNCHED', ''] },
];

const HISTORY_RIDDLES = [
  { type: 'riddle', question: ['', 'I WAS THE TALLEST', 'STRUCTURE FOR', '3800 YEARS', ''], answer: ['', '', 'GREAT PYRAMID!', '', ''] },
  { type: 'riddle', question: ['', 'I SANK ON MY', 'FIRST VOYAGE 1912', 'WHAT AM I?', ''], answer: ['', '', 'THE TITANIC!', '', ''] },
  { type: 'riddle', question: ['', 'I AM A WALL THAT', 'IS OVER 13000', 'MILES LONG', ''], answer: ['', '', 'THE GREAT WALL!', '', ''] },
  { type: 'riddle', question: ['', 'I ERUPTED AND', 'BURIED A ROMAN CITY', 'IN 79 AD', ''], answer: ['', '', 'MOUNT VESUVIUS!', '', ''] },
  { type: 'riddle', question: ['', 'I WAS A FAMOUS QUEEN', 'OF ANCIENT EGYPT', 'WHO AM I?', ''], answer: ['', '', 'CLEOPATRA!', '', ''] },
  { type: 'riddle', question: ['', 'I AM A STONE THAT', 'UNLOCKED ANCIENT', 'EGYPTIAN WRITING', ''], answer: ['', '', 'ROSETTA STONE!', '', ''] },
  { type: 'riddle', question: ['', 'I WAS A SHIP THAT', 'BROUGHT PILGRIMS', 'TO AMERICA 1620', ''], answer: ['', '', 'THE MAYFLOWER!', '', ''] },
  { type: 'riddle', question: ['', 'I AM AN ANCIENT', 'WONDER WITH A', 'SPHINX NEARBY', ''], answer: ['', '', 'THE PYRAMIDS!', '', ''] },
  { type: 'riddle', question: ['', 'I AM A TOWER IN', 'PARIS BUILT IN 1889', 'WHAT AM I?', ''], answer: ['', '', 'EIFFEL TOWER!', '', ''] },
  { type: 'riddle', question: ['', 'I AM A BELL THAT', 'CRACKED IN 1846', 'IN PHILADELPHIA', ''], answer: ['', '', 'THE LIBERTY BELL!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE FOUR FACES', 'CARVED IN A MOUNTAIN', 'IN SOUTH DAKOTA', ''], answer: ['', '', 'MOUNT RUSHMORE!', '', ''] },
  { type: 'riddle', question: ['', 'I AM A CANAL THAT', 'CONNECTS TWO OCEANS', 'OPENED IN 1914', ''], answer: ['', '', 'PANAMA CANAL!', '', ''] },
  { type: 'riddle', question: ['', 'I AM AN ARENA IN', 'ROME BUILT FOR', 'GLADIATOR FIGHTS', ''], answer: ['', '', 'THE COLOSSEUM!', '', ''] },
  { type: 'riddle', question: ['', 'I AM A GARDEN THAT', 'WAS AN ANCIENT', 'WONDER OF THE WORLD', ''], answer: ['', '', 'HANGING GARDENS!', '', ''] },
  { type: 'riddle', question: ['', 'I AM A DOCUMENT', 'SIGNED IN 1215 BY', 'KING JOHN', ''], answer: ['', '', 'MAGNA CARTA!', '', ''] },
];

const HISTORY_GEOGRAPHY = [
  { type: 'fact', lines: ['HISTORY FACT!', 'THE SILK ROAD WAS', '4000 MILES LONG', '', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE PANAMA CANAL', 'TOOK 10 YEARS', 'TO BUILD', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE ROMAN ROADS', 'STRETCHED 250000', 'MILES TOTAL', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'CONSTANTINOPLE WAS', 'RENAMED ISTANBUL', 'IN 1930', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE SUEZ CANAL', 'OPENED IN 1869', 'IN EGYPT', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'TENOCHTITLAN WAS', 'BUILT ON A LAKE', 'IN MEXICO', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'PETRA WAS CARVED', 'INTO ROCK IN', 'JORDAN', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'ANGKOR WAT IS THE', 'LARGEST RELIGIOUS', 'MONUMENT EVER BUILT', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'TIMBUKTU WAS A', 'CENTER OF LEARNING', 'IN AFRICA', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE NILE GAVE LIFE', 'TO ANCIENT EGYPT', 'FOR THOUSANDS YEARS', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'MESOPOTAMIA MEANS', 'LAND BETWEEN', 'TWO RIVERS', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE COLOSSEUM HELD', '50000 SPECTATORS', 'IN ANCIENT ROME', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE PARTHENON WAS', 'BUILT IN 447 BC', 'IN ATHENS', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'THE FORBIDDEN CITY', 'HAS 9999 ROOMS', 'IN BEIJING', ''] },
  { type: 'fact', lines: ['HISTORY FACT!', 'EASTER ISLAND HAS', '887 GIANT STONE', 'STATUES CALLED MOAI', ''] },
];

export const HISTORY_MESSAGES = [...HISTORY_EVENTS, ...HISTORY_QUOTES, ...HISTORY_MILESTONES, ...HISTORY_FIRSTS, ...HISTORY_ON_THIS_DAY, ...HISTORY_RIDDLES, ...HISTORY_GEOGRAPHY];

// --- INNOVATOR MODE: TECH HISTORY FACTS (30) ---
const INNOVATOR_TECH_HISTORY = [
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'APPLE FOUNDED 1976', 'IN A GARAGE', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST EMAIL SENT', 'IN 1971', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'GOOGLE STARTED IN A', 'DORM ROOM 1998', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST COMPUTER BUG', 'WAS A REAL MOTH', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'THE INTERNET BEGAN', 'IN 1969 AS ARPANET', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST WEBSITE MADE', 'IN 1991 BY TIM B-L', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'YOUTUBE STARTED AS', 'A DATING SITE', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST CELL PHONE', 'CALL MADE IN 1973', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'NINTENDO STARTED AS', 'A CARD COMPANY 1889', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST VIDEO GAME', 'MADE IN 1958', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'AMAZON STARTED BY', 'SELLING BOOKS ONLY', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'THE MOUSE INVENTED', 'IN 1964', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST IPHONE CAME', 'OUT IN 2007', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'WIFI INVENTED', 'IN AUSTRALIA 1992', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'GPS WAS MADE FOR', 'THE MILITARY FIRST', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST ROBOT BUILT', 'IN 1954', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'BLUETOOTH NAMED', 'AFTER A VIKING KING', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST EMOJI MADE', 'IN JAPAN 1999', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FACEBOOK STARTED', 'IN A DORM 2004', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'TESLA MOTORS NAMED', 'AFTER NIKOLA TESLA', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST COMPUTER EVER', 'WEIGHED 30 TONS', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'SPOTIFY LAUNCHED', 'IN SWEDEN 2008', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST DRONE FLIGHT', 'WAS IN 1907', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'PYTHON NAMED AFTER', 'MONTY PYTHON!', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'PIXAR STARTED AS A', 'HARDWARE COMPANY', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'FIRST AI PROGRAM', 'WRITTEN IN 1951', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'QR CODES INVENTED', 'IN JAPAN 1994', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'MINECRAFT CREATED', 'BY ONE PERSON', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'USB INVENTED 1996', 'BY AJAY BHATT', ''] },
  { type: 'fact', lines: ['', 'TECH HISTORY!', 'SPACEX FIRST ROCKET', 'LANDED IN 2015', ''] },
];

// --- INNOVATOR MODE: INVENTOR/FOUNDER QUOTES (30) ---
const INNOVATOR_QUOTES = [
  { type: 'quote', lines: ['', 'STAY HUNGRY', 'STAY FOOLISH', '- STEVE JOBS', ''] },
  { type: 'quote', lines: ['', 'THINK DIFFERENT', '', '- STEVE JOBS', ''] },
  { type: 'quote', lines: ['', 'INNOVATION IS WHAT', 'DISTINGUISHES A', 'LEADER - S. JOBS', ''] },
  { type: 'quote', lines: ['', 'THE COMPUTER WAS', 'BORN TO SOLVE', 'PROBLEMS - HOPPER', ''] },
  { type: 'quote', lines: ['', 'THE MOST DANGEROUS', 'PHRASE IS WE ALWAYS', 'DID IT - G. HOPPER', ''] },
  { type: 'quote', lines: ['', 'THAT BRAIN OF MINE', 'IS MORE THAN MERELY', 'MORTAL - LOVELACE', ''] },
  { type: 'quote', lines: ['', 'IMAGINATION IS MORE', 'IMPORTANT THAN', 'KNOWLEDGE -EINSTEIN', ''] },
  { type: 'quote', lines: ['', 'LIFE IS LIKE RIDING', 'A BICYCLE KEEP', 'MOVING - EINSTEIN', ''] },
  { type: 'quote', lines: ['', 'THE PRESENT IS', 'THEIRS THE FUTURE', 'IS MINE - N. TESLA', ''] },
  { type: 'quote', lines: ['', 'BE ALONE THAT IS', 'WHEN IDEAS ARE BORN', '- NIKOLA TESLA', ''] },
  { type: 'quote', lines: ['', 'NOTHING IN LIFE IS', 'TO BE FEARED ONLY', 'UNDERSTOOD - CURIE', ''] },
  { type: 'quote', lines: ['', 'BE LESS CURIOUS', 'ABOUT PEOPLE MORE', 'ABOUT IDEAS - CURIE', ''] },
  { type: 'quote', lines: ['', 'WHEN SOMETHING IS', 'IMPORTANT ENOUGH', 'YOU DO IT - E. MUSK', ''] },
  { type: 'quote', lines: ['', 'FAILURE IS AN OPTION', 'IF NOT FAILING', 'NOT TRYING - E. MUSK', ''] },
  { type: 'quote', lines: ['', 'YOUR TIME IS LIMITED', 'DONT WASTE IT', '- STEVE JOBS', ''] },
  { type: 'quote', lines: ['', 'GENIUS IS ONE', 'PERCENT INSPIRATION', '99 WORK - EDISON', ''] },
  { type: 'quote', lines: ['', 'I HAVE NOT FAILED', 'I FOUND 10000 WAYS', 'THAT WONT - EDISON', ''] },
  { type: 'quote', lines: ['', 'THE BEST WAY TO', 'PREDICT THE FUTURE', 'IS INVENT IT - KAY', ''] },
  { type: 'quote', lines: ['', 'MOVE FAST AND BREAK', 'THINGS', '- M. ZUCKERBERG', ''] },
  { type: 'quote', lines: ['', 'SIMPLICITY IS THE', 'ULTIMATE FORM OF', 'SOPHISTICATION', ''] },
  { type: 'quote', lines: ['', 'IDEAS ARE EASY', 'EXECUTION IS', 'EVERYTHING', ''] },
  { type: 'quote', lines: ['', 'ANY SUFFICIENTLY', 'ADVANCED TECH', 'IS MAGIC - CLARKE', ''] },
  { type: 'quote', lines: ['', 'THE ONLY WAY TO DO', 'GREAT WORK IS TO', 'LOVE IT - S. JOBS', ''] },
  { type: 'quote', lines: ['', 'EVERYONE SHOULD', 'LEARN TO CODE', '- STEVE JOBS', ''] },
  { type: 'quote', lines: ['', 'WE CAN ONLY SEE', 'A SHORT DISTANCE', 'AHEAD - A. TURING', ''] },
  { type: 'quote', lines: ['', 'MACHINES TAKE ME', 'BY SURPRISE OFTEN', '- ALAN TURING', ''] },
  { type: 'quote', lines: ['', 'THE SCIENCE OF', 'TODAY IS TOMORROWS', 'TECH - E. TELLER', ''] },
  { type: 'quote', lines: ['', 'I THINK THEREFORE', 'I AM', '- DESCARTES', ''] },
  { type: 'quote', lines: ['', 'MEASURE WHAT IS', 'MEASURABLE MAKE', 'MEASURABLE - GALILEO', ''] },
  { type: 'quote', lines: ['', 'IF I HAVE SEEN FAR', 'IT IS BY STANDING', 'ON GIANTS - NEWTON', ''] },
];

// --- INNOVATOR MODE: SCIENCE BREAKTHROUGHS (20) ---
const INNOVATOR_SCIENCE = [
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'DNA DISCOVERED', 'IN 1953', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'HUMANS LANDED ON', 'THE MOON IN 1969', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'ELECTRICITY WAS', 'HARNESSED IN 1879', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'PENICILLIN FOUND', 'BY ACCIDENT IN 1928', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'FIRST VACCINE MADE', 'IN 1796 FOR SMALLPOX', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'X-RAYS DISCOVERED', 'IN 1895', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'GRAVITY DISCOVERED', 'BY ISAAC NEWTON', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'THE SPEED OF LIGHT', 'IS 186000 MILES/SEC', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'ATOMS ARE 99.9', 'PERCENT EMPTY SPACE', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'WATER IS H2O TWO', 'HYDROGEN ONE OXYGEN', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'THE SUN IS A GIANT', 'BALL OF HOT GAS', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'DINOSAURS WENT', 'EXTINCT 65M YRS AGO', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'EARTH IS 4.5', 'BILLION YEARS OLD', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'SOUND CANT TRAVEL', 'THROUGH SPACE', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'LIGHT TAKES 8 MIN', 'TO REACH EARTH', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'HUMAN BODY HAS 206', 'BONES', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'VENUS IS THE', 'HOTTEST PLANET', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'TELESCOPE INVENTED', 'IN 1608', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'PERIODIC TABLE HAS', '118 ELEMENTS', ''] },
  { type: 'fact', lines: ['', 'SCIENCE FACT!', 'MARIE CURIE WON', 'TWO NOBEL PRIZES', ''] },
];

// --- INNOVATOR MODE: STARTUP WISDOM (20) ---
const INNOVATOR_WISDOM = [
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'MOVE FAST AND LEARN', '', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'DONE IS BETTER', 'THAN PERFECT', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'FAIL FAST', 'LEARN FASTER', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'SHIP IT TODAY', 'FIX IT TOMORROW', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'SOLVE A PROBLEM', 'PEOPLE ACTUALLY HAVE', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'MAKE SOMETHING', 'PEOPLE WANT', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'START SMALL', 'DREAM BIG', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'TALK TO YOUR USERS', '', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'BUILD MEASURE LEARN', 'REPEAT', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'STAY CURIOUS', 'ALWAYS', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'YOUR IDEA IS WORTH', 'NOTHING WITHOUT WORK', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'DO THINGS THAT', 'DONT SCALE AT FIRST', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'FOCUS ON ONE THING', 'AND DO IT WELL', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'THE BEST CODE IS', 'NO CODE AT ALL', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'ITERATE ITERATE', 'ITERATE', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'LAUNCH BEFORE', 'YOURE READY', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'DATA BEATS', 'OPINIONS', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'KEEP IT SIMPLE', '', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'THINK BIG START', 'SMALL ACT FAST', ''] },
  { type: 'quote', lines: ['', 'STARTUP WISDOM', 'CULTURE EATS', 'STRATEGY', ''] },
];

// --- INNOVATOR MODE: ON THIS DAY IN TECH (20) ---
const INNOVATOR_ON_THIS_DAY = [
  { type: 'fact', lines: ['', 'ON THIS DAY', 'JAN 1 1983', 'THE INTERNET IS BORN', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'FEB 4 2004', 'FACEBOOK LAUNCHES', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'MAR 21 2006', 'TWITTER IS FOUNDED', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'APR 1 1976', 'APPLE IS FOUNDED', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'MAY 14 1973', 'SKYLAB LAUNCHES', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'JUN 29 2007', 'FIRST IPHONE SOLD', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'JUL 20 1969', 'MOON LANDING!', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'AUG 6 1991', 'FIRST WEBSITE EVER', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'SEP 4 1998', 'GOOGLE IS FOUNDED', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'OCT 29 1969', 'FIRST ARPANET MSG', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'NOV 10 1983', 'WINDOWS 1.0 RELEASED', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'DEC 25 1990', 'FIRST WEB BROWSER', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'JAN 9 2007', 'JOBS UNVEILS IPHONE', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'FEB 14 2005', 'YOUTUBE IS CREATED', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'MAR 10 2000', 'DOT COM BUBBLE POPS', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'APR 12 1961', 'FIRST HUMAN IN SPACE', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'MAY 11 1997', 'DEEP BLUE BEATS', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'JUL 5 1994', 'AMAZON IS FOUNDED', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'AUG 12 1981', 'IBM PC IS RELEASED', ''] },
  { type: 'fact', lines: ['', 'ON THIS DAY', 'OCT 1 2001', 'FIRST IPOD REVEALED', ''] },
];

// --- INNOVATOR MODE: TECH RIDDLES (15) ---
const INNOVATOR_RIDDLES = [
  { type: 'riddle', question: ['', 'I HAVE A MOUSE', 'BUT NO CAT', 'WHAT AM I?', ''], answer: ['', '', 'A COMPUTER!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE KEYS BUT', 'NO LOCKS', 'WHAT AM I?', ''], answer: ['', '', 'A KEYBOARD!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE A WEB BUT', 'IM NOT A SPIDER', 'WHAT AM I?', ''], answer: ['', '', 'THE INTERNET!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE PAGES BUT', 'IM NOT A BOOK', 'WHAT AM I?', ''], answer: ['', '', 'A WEBSITE!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE CHIPS BUT', 'YOU CANT EAT ME', 'WHAT AM I?', ''], answer: ['', '', 'A MOTHERBOARD!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE A CLOUD BUT', 'NO RAIN', 'WHAT AM I?', ''], answer: ['', '', 'CLOUD STORAGE!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE WINDOWS BUT', 'NO GLASS', 'WHAT AM I?', ''], answer: ['', '', 'A PC!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE A DRIVE BUT', 'NO STEERING WHEEL', 'WHAT AM I?', ''], answer: ['', '', 'A HARD DRIVE!', '', ''] },
  { type: 'riddle', question: ['', 'I TAKE SCREENSHOTS', 'BUT HAVE NO CAMERA', 'WHAT AM I?', ''], answer: ['', '', 'A COMPUTER!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE MEMORY BUT', 'NO BRAIN', 'WHAT AM I?', ''], answer: ['', '', 'A USB STICK!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE A TABLET', 'BUT NO MEDICINE', 'WHAT AM I?', ''], answer: ['', '', 'AN IPAD!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE BARS BUT', 'IM NOT A PRISON', 'WHAT AM I?', ''], answer: ['', '', 'A PHONE SIGNAL!', '', ''] },
  { type: 'riddle', question: ['', 'I STREAM BUT', 'IM NOT A RIVER', 'WHAT AM I?', ''], answer: ['', '', 'NETFLIX!', '', ''] },
  { type: 'riddle', question: ['', 'I HAVE FOLLOWERS', 'BUT IM NOT A LEADER', 'WHAT AM I?', ''], answer: ['', '', 'SOCIAL MEDIA!', '', ''] },
  { type: 'riddle', question: ['', 'I CRASH BUT', 'IM NOT A CAR', 'WHAT AM I?', ''], answer: ['', '', 'A COMPUTER!', '', ''] },
];

// --- INNOVATOR MODE: MOTIVATIONAL/BUILDER (15) ---
const INNOVATOR_MOTIVATIONAL = [
  { type: 'quote', lines: ['', '', 'BUILD SOMETHING', 'PEOPLE LOVE', ''] },
  { type: 'quote', lines: ['', 'EVERY EXPERT WAS', 'ONCE A BEGINNER', '', ''] },
  { type: 'quote', lines: ['', 'THE FUTURE BELONGS', 'TO THE CURIOUS', '', ''] },
  { type: 'quote', lines: ['', 'DREAM IT BUILD IT', 'SHIP IT', '', ''] },
  { type: 'quote', lines: ['', 'CODE IS POETRY', '', '', ''] },
  { type: 'quote', lines: ['', 'CREATE THE THINGS', 'YOU WISH EXISTED', '', ''] },
  { type: 'quote', lines: ['', 'NEVER STOP LEARNING', 'NEVER STOP GROWING', '', ''] },
  { type: 'quote', lines: ['', 'TODAY IS A GREAT', 'DAY TO BUILD', 'SOMETHING NEW', ''] },
  { type: 'quote', lines: ['', 'YOU ARE CAPABLE OF', 'AMAZING THINGS', '', ''] },
  { type: 'quote', lines: ['', 'GREAT THINGS NEVER', 'CAME FROM COMFORT', 'ZONES', ''] },
  { type: 'quote', lines: ['', 'MAKE IT WORK', 'MAKE IT RIGHT', 'MAKE IT FAST', ''] },
  { type: 'quote', lines: ['', 'THE ONLY LIMIT IS', 'YOUR IMAGINATION', '', ''] },
  { type: 'quote', lines: ['', 'SMALL STEPS LEAD TO', 'BIG CHANGES', '', ''] },
  { type: 'quote', lines: ['', 'BE THE CHANGE YOU', 'WANT TO SEE', 'IN THE WORLD', ''] },
  { type: 'quote', lines: ['', 'INVENT THE FUTURE', 'DONT WAIT FOR IT', '', ''] },
];

export const DEFAULT_MESSAGES = [...QUOTES, ...JOKES, ...RIDDLES, ...KNOCK_KNOCKS, ...FUN_FACTS, ...SPACE_FACTS, ...VOCABULARY, ...MATH_PUZZLES, ...GEOGRAPHY, ...SEASONAL_FACTS, ...UNSCRAMBLE, ...COLOR_MIXING];

// Innovator mode — combined from all innovator content arrays
export const INNOVATOR_MESSAGES = [...INNOVATOR_TECH_HISTORY, ...INNOVATOR_QUOTES, ...INNOVATOR_SCIENCE, ...INNOVATOR_WISDOM, ...INNOVATOR_ON_THIS_DAY, ...INNOVATOR_RIDDLES, ...INNOVATOR_MOTIVATIONAL];

export const TIME_SLOTS = [
  { startHour: 7, endHour: 8, messages: MORNING_MESSAGES },
  { startHour: 19.5, endHour: 20.5, messages: BEDTIME_MESSAGES }
];