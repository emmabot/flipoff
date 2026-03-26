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
  ['', '', 'BRUSH YOUR TEETH', '', ''],
  ['', '', 'BRUSH YOUR HAIR', '', ''],
  ['', '', 'PUT YOUR SOCKS ON', '', ''],
  ['', '', 'BE NICE', '', ''],
  ['', 'GET READY FOR A', 'BEAUTIFUL DAY', '', '']
];

// 5 breakfast/food/school themed jokes for morning
const MORNING_JOKES = [
  ['', 'WHAT DO CATS EAT', 'FOR BREAKFAST?', 'MICE KRISPIES!', ''],
  ['', 'WHY DONT EGGS', 'TELL JOKES?', 'THEY MIGHT CRACK UP!', ''],
  ['', 'WHY DID THE KID', 'BRING A LADDER?', 'TO GO TO HIGH SCHOOL', ''],
  ['', 'WHAT DO ELVES', 'LEARN IN SCHOOL?', 'THE ELF-ABET!', ''],
  ['', 'WHY DID BACON', 'LAUGH?', 'THE EGG CRACKED ONE!', '']
];

// Interleave: reminder, joke, reminder, joke, ...
export const MORNING_MESSAGES = [];
for (let i = 0; i < 5; i++) {
  MORNING_MESSAGES.push(MORNING_REMINDERS[i]);
  MORNING_MESSAGES.push(MORNING_JOKES[i]);
}

// --- BEDTIME SET (7:30-8:30pm) ---

const BEDTIME_REMINDERS = [
  ['', '', 'BRUSH YOUR TEETH', '', ''],
  ['', '', 'CHANGE YOUR CLOTHES', '', ''],
  ['', '', 'PACK YOUR BACKPACK', '', ''],
  ['', '', 'READ A BOOK', '', ''],
  ['', '', 'DRINK SOME WATER', '', ''],
  ['', '', 'SAY GOODNIGHT', '', ''],
  ['', '', 'SWEET DREAMS', '', ''],
  ['', '', 'YOU DID GREAT TODAY', '', ''],
  ['', 'TOMORROW IS A', 'NEW ADVENTURE', '', '']
];

const BEDTIME_QUOTES = [
  ['', 'TO SLEEP PERCHANCE', 'TO DREAM', '- SHAKESPEARE', ''],
  ['', 'TOMORROW IS A NEW DAY', 'WITH NO MISTAKES YET', '- ANNE SHIRLEY', ''],
  ['', 'YOU ARE BRAVER THAN', 'YOU BELIEVE', '- WINNIE THE POOH', ''],
  ['', 'THE MOON IS A FRIEND', 'FOR THE LONESOME', '- CARL SANDBURG', ''],
  ['', 'SLEEP IS THE BEST', 'MEDITATION', '- DALAI LAMA', ''],
  ['', 'EVERY SUNSET BRINGS', 'THE PROMISE OF', 'A NEW DAWN - EMERSON', ''],
  ['', 'EVEN SUPERHEROES', 'NEED SLEEP', '', ''],
  ['', 'THE NIGHT IS DARKEST', 'JUST BEFORE THE DAWN', '- THOMAS FULLER', ''],
  ['', 'AND SO TO BED', '', '- SAMUEL PEPYS', '']
];

// Interleave: reminder, quote, reminder, quote, ...
export const BEDTIME_MESSAGES = [];
for (let i = 0; i < 9; i++) {
  BEDTIME_MESSAGES.push(BEDTIME_REMINDERS[i]);
  BEDTIME_MESSAGES.push(BEDTIME_QUOTES[i]);
}

// --- QUOTES (24) ---

const QUOTES = [
  ['', 'DO OR DO NOT', 'THERE IS NO TRY', '- YODA', ''],
  ['', 'YOUR FOCUS', 'DETERMINES REALITY', '- QUI-GON JINN', ''],
  ['', 'THE FORCE WILL BE', 'WITH YOU ALWAYS', '- OBI-WAN KENOBI', ''],
  ['', 'THE GREATEST', 'TEACHER FAILURE IS', '- YODA', ''],
  ['', 'OUR CHOICES SHOW', 'WHAT WE TRULY ARE', '- DUMBLEDORE', ''],
  ['', 'HAPPINESS CAN BE', 'FOUND IN DARKEST', 'TIMES - DUMBLEDORE', ''],
  ['', 'IT TAKES COURAGE TO', 'STAND UP TO FRIENDS', '- DUMBLEDORE', ''],
  ['', 'WORDS ARE OUR MOST', 'INEXHAUSTIBLE', 'MAGIC - DUMBLEDORE', ''],
  ['', 'EVEN STRENGTH MUST', 'BOW TO WISDOM', '- ANNABETH CHASE', ''],
  ['', 'BEING A HERO DOESNT', 'MEAN INVINCIBLE', '- PERCY JACKSON', ''],
  ['', 'BRAVE DOESNT MEAN', 'YOURE NOT SCARED', '- PERCY JACKSON', ''],
  ['', 'THE RIGHT CHOICE IS', 'RARELY THE EASY ONE', '- PERCY JACKSON', ''],
  // GREEK MYTHOLOGY (6)
  ['', 'WISDOM IS THE', 'GREATEST STRENGTH', '- ATHENA', ''],
  ['', 'TRUE HEROES', 'HELP OTHERS', '- HERCULES', ''],
  ['', 'THE JOURNEY HOME IS', 'WORTH EVERY STEP', '- THE ODYSSEY', ''],
  ['', 'CLEVERNESS CAN', 'BEAT STRENGTH', '- ODYSSEUS', ''],
  ['', 'KNOW YOURSELF AND', 'YOU WILL KNOW THE', 'UNIVERSE - DELPHI', ''],
  ['', 'EVERY MAZE HAS', 'A WAY OUT', '- THESEUS', ''],
  // NORSE MYTHOLOGY (6)
  ['', 'BE STRONG LIKE THOR', 'WISE LIKE ODIN', '', ''],
  ['', 'EVEN THUNDER STARTS', 'AS A WHISPER', '', ''],
  ['', 'A KIND WORD NEED', 'NOT COST MUCH', '- ODIN', ''],
  ['', 'THE BRAVE LIVE', 'ON FOREVER', '', ''],
  ['', 'IN EVERY WINTER', 'SPRING HIDES', '', ''],
  ['', 'STAND TALL LIKE', 'A MIGHTY OAK', '- YGGDRASIL', '']
];

// --- JOKES (197) ---

const JOKES = [
  // ANIMALS (37)
  ['', 'WHY DID THE COW', 'CROSS THE ROAD?', 'TO THE UDDER SIDE!', ''],
  ['', 'WHAT DO YOU CALL', 'A SLEEPING BULL?', 'A BULLDOZER!', ''],
  ['', 'WHY ARE FISH', 'SO SMART?', 'THEY LIVE IN SCHOOLS', ''],
  ['', 'WHAT DO YOU CALL', 'A BEAR WITH NO TEETH?', 'A GUMMY BEAR!', ''],
  ['', 'WHAT IS A CATS', 'FAVORITE COLOR?', 'PURR-PLE!', ''],
  ['', 'WHAT DO YOU CALL', 'A FLY WITH NO WINGS?', 'A WALK!', ''],
  ['', 'WHAT DO COWS', 'READ?', 'MOO-SPAPERS!', ''],
  ['', 'WHY DONT LEOPARDS', 'PLAY HIDE AND SEEK?', 'ALWAYS SPOTTED!', ''],
  ['', 'WHAT DO YOU CALL', 'A LAZY KANGAROO?', 'A POUCH POTATO!', ''],
  ['', 'WHAT SOUND DO', 'PORCUPINES MAKE?', 'OW OW OW!', ''],
  ['', 'WHAT DO YOU CALL', 'AN ALLIGATOR IN VEST?', 'INVESTIGATOR!', ''],
  ['', 'WHAT DO DUCKS', 'GET AFTER THEY EAT?', 'A BILL!', ''],
  ['', 'WHAT DO YOU CALL', 'A FISH WITHOUT EYES?', 'A FSH!', ''],
  ['', 'WHERE DO COWS', 'GO FOR FUN?', 'THE MOO-VIES!', ''],
  ['', 'WHY CANT YOU TELL', 'A SECRET ON A FARM?', 'THE CORN HAS EARS!', ''],
  ['', 'WHAT DO YOU CALL', 'A DOG MAGICIAN?', 'A LABRACADABRADOR!', ''],
  ['', 'WHY DO BEES HAVE', 'STICKY HAIR?', 'THEY USE HONEYCOMBS!', ''],
  ['', 'WHAT DO FROGS', 'ORDER AT A CAFE?', 'CROAK-A-COLA!', ''],
  ['', 'WHAT DO SNAKES', 'STUDY IN SCHOOL?', 'HISS-TORY!', ''],
  ['', 'WHERE DO SHEEP', 'GO ON VACATION?', 'THE BAAAA-HAMAS!', ''],
  ['', 'WHAT DO CATS EAT', 'FOR BREAKFAST?', 'MICE KRISPIES!', ''],
  ['', 'WHY DID THE DUCK', 'GO TO THE DOCTOR?', 'IT WAS FEELING QUACK', ''],
  ['', 'WHAT DO YOU CALL', 'A COLD DOG?', 'A CHILI DOG!', ''],
  ['', 'HOW DO BEES', 'GET TO SCHOOL?', 'ON THE BUZZ!', ''],
  ['', 'WHAT DO YOU CALL', 'A PENGUIN IN DESERT?', 'LOST!', ''],
  ['', 'WHAT DO YOU GIVE', 'A SICK BIRD?', 'TWEET-MENT!', ''],
  ['', 'WHY DID THE HORSE', 'GO BEHIND THE TREE?', 'TO CHANGE HIS JOCKY', ''],
  ['', 'WHAT DO ELEPHANTS', 'USE TO TALK?', 'ELEPHONES!', ''],
  ['', 'WHY DO FISH LIVE', 'IN SALT WATER?', 'PEPPER MAKES SNEEZE', ''],
  ['', 'WHAT DO TURTLES', 'DO ON BIRTHDAYS?', 'THEY SHELLEBRATE!', ''],
  ['', 'WHY ARE CATS', 'GOOD AT VIDEO GAMES?', 'THEY HAVE NINE LIVES', ''],
  ['', 'WHAT DO YOU CALL', 'A DINOSAUR THAT NAPS?', 'A DINO-SNORE!', ''],
  ['', 'WHAT DO OWLS SAY', 'ON HALLOWEEN?', 'HAPPY OWL-OWEEN!', ''],
  ['', 'WHY DO GIRAFFES', 'HAVE LONG NECKS?', 'THEIR FEET SMELL!', ''],
  ['', 'WHAT DO YOU CALL', 'A FUNNY CHICKEN?', 'A COMEDI-HEN!', ''],
  ['', 'WHY ARE DOGS', 'BAD DANCERS?', 'TWO LEFT FEET!', ''],
  // FOOD (35)
  ['', 'WHAT DO YOU CALL', 'CHEESE THAT ISNT YOURS', 'NACHO CHEESE!', ''],
  ['', 'WHAT DO YOU CALL', 'FAKE SPAGHETTI?', 'AN IMPASTA!', ''],
  ['', 'WHY DID THE TOMATO', 'TURN RED?', 'IT SAW THE DRESSING!', ''],
  ['', 'WHY DID THE BANANA', 'GO TO THE DOCTOR?', 'IT WASNT PEELING WELL', ''],
  ['', 'WHAT DO ELVES', 'MAKE SANDWICHES WITH?', 'SHORTBREAD!', ''],
  ['', 'WHY DID THE COOKIE', 'GO TO THE DOCTOR?', 'IT FELT CRUMMY!', ''],
  ['', 'WHAT DID THE GRAPE', 'SAY WHEN STEPPED ON?', 'NOTHING JUST A WHINE', ''],
  ['', 'WHY DID THE EGG', 'HIDE?', 'IT WAS A LITTLE CHICK', ''],
  ['', 'WHY DONT EGGS', 'TELL JOKES?', 'THEY MIGHT CRACK UP!', ''],
  ['', 'WHAT DO YOU CALL', 'A SAD STRAWBERRY?', 'A BLUEBERRY!', ''],
  ['', 'HOW DO YOU FIX', 'A BROKEN PIZZA?', 'WITH TOMATO PASTE!', ''],
  ['', 'WHAT DID THE CAKE', 'SAY TO THE FORK?', 'WANT A PIECE OF ME?', ''],
  ['', 'WHAT DID THE', 'BREAD SAY TO BUTTER?', "YOU'RE ON A ROLL!", ''],
  ['', 'WHY DID THE LEMON', 'STOP ROLLING?', 'IT RAN OUT OF JUICE!', ''],
  ['', 'WHAT DO APPLES', 'AND ORANGES HAVE?', "THEY'RE BOTH FRUIT!", ''],
  ['', 'WHAT IS A PRETZELS', 'FAVORITE DAY?', 'TWISTS-DAY!', ''],
  ['', 'WHAT DO YOU CALL', 'A SLEEPING PIZZA?', 'A PIZZZZZA!', ''],
  ['', 'WHY DID THE MELON', 'JUMP IN THE LAKE?', 'WANTED TO BE WATER', ''],
  ['', 'HOW DO YOU MAKE', 'A MILKSHAKE?', 'GIVE A COW A POGO!', ''],
  ['', 'WHAT KIND OF NUT', 'ALWAYS HAS A COLD?', 'CASHEW!', ''],
  ['', 'WHAT DID THE HOT', 'DOG SAY TO THE BUN?', 'STOP LOAFING AROUND', ''],
  ['', 'WHY DID BACON', 'LAUGH?', 'THE EGG CRACKED ONE!', ''],
  ['', 'WHAT DOES A NOSY', 'PEPPER DO?', 'GETS JALAPENO BIZ!', ''],
  ['', 'WHAT VEGETABLES', 'DO LIBRARIANS LIKE?', 'QUIET PEAS!', ''],
  ['', 'WHY WAS THE SOUP', 'SO GOOD AT BASEBALL?', 'IT HAD A GOOD STOCK!', ''],
  ['', 'WHAT DID KETCHUP', 'SAY TO MUSTARD?', "YOU'RE THE WURST!", ''],
  ['', 'WHAT DID PEANUT', 'BUTTER SAY TO JELLY?', 'STUCK ON YOU!', ''],
  ['', 'WHAT DO YOU CALL', 'A RICH ELF?', 'WELFY!', ''],
  ['', 'HOW DO TACOS', 'SAY GRACE?', 'LETTUCE PRAY!', ''],
  ['', 'WHY DID THE PEACH', 'GO TO THE DENTIST?', 'BAD FUZZ ON TEETH!', ''],
  ['', 'WHY DO MUSHROOMS', 'GET INVITED TO PARTY?', "THEY'RE FUN-GI!", ''],
  ['', 'WHAT DO YOU CALL', 'A RUNNING TURKEY?', 'FAST FOOD!', ''],
  ['', 'HOW DO PICKLES', 'ENJOY A DAY OUT?', 'THEY RELISH IT!', ''],
  // SCHOOL (30)
  ['', 'WHY DID THE KID', 'BRING A LADDER?', 'TO GO TO HIGH SCHOOL', ''],
  ['', 'WHAT IS A WITCHS', 'FAVORITE SUBJECT?', 'SPELLING!', ''],
  ['', 'WHY DID THE BOOK', 'GO TO THE HOSPITAL?', 'IT HURT ITS SPINE!', ''],
  ['', 'WHAT DO YOU CALL', 'A TEACHER WHO FARTS?', 'A PRIVATE TUTOR!', ''],
  ['', 'WHY WAS THE MATH', 'BOOK ALWAYS SAD?', 'IT HAD PROBLEMS!', ''],
  ['', 'WHAT DID THE PEN', 'SAY TO THE PENCIL?', "YOU'RE POINTLESS!", ''],
  ['', 'WHY DO CALCULATORS', 'MAKE GREAT FRIENDS?', 'YOU CAN COUNT ON EM!', ''],
  ['', 'WHY DID THE ERASER', 'GO TO SCHOOL?', 'TO CORRECT MISTAKES!', ''],
  ['', 'WHAT DO ELVES', 'LEARN IN SCHOOL?', 'THE ELF-ABET!', ''],
  ['', 'WHAT SCHOOL SUPPLY', 'IS KING OF THE CLASS?', 'THE RULER!', ''],
  ['', 'WHY WAS THE BROOM', 'LATE FOR SCHOOL?', 'IT OVERSWEPT!', ''],
  ['', 'WHY DO MAGICIANS', 'DO WELL IN SCHOOL?', 'GOOD AT TRICK TESTS!', ''],
  ['', 'WHATS A TEACHERS', 'FAVORITE NATION?', 'EXPLA-NATION!', ''],
  ['', 'WHY DID THE CLOCK', 'GET SENT TO OFFICE?', 'IT TOCKED TOO MUCH!', ''],
  ['', 'WHATS A PIRATES', 'FAVORITE LETTER?', 'YOU THINK ITS RRRR!', ''],
  ['', 'HOW DID THE MUSIC', 'TEACHER GET LOCKED OUT', 'SHE LOST HER KEYS!', ''],
  ['', 'WHAT DID ZERO SAY', 'TO EIGHT?', 'NICE BELT!', ''],
  ['', 'WHY DO WE NEVER', 'TELL SECRETS IN CLASS?', 'TOO MANY RULERS!', ''],
  ['', 'WHAT DO LIBRARIANS', 'TAKE FISHING?', 'BOOKWORMS!', ''],
  ['', 'WHY DID THE PENCIL', 'WIN THE AWARD?', 'IT WAS SHARP!', ''],
  ['', 'WHAT DID THE PAPER', 'SAY TO THE PENCIL?', 'WRITE ON!', ''],
  ['', 'WHAT DO MATH', 'TEACHERS EAT?', 'SQUARE MEALS!', ''],
  ['', 'WHY IS SIX AFRAID', 'OF SEVEN?', '7 ATE 9!', ''],
  ['', 'WHAT DO YOU CALL', 'A NUMBER THAT MOVES?', 'A ROAMIN NUMERAL!', ''],
  ['', 'WHY IS HISTORY', 'LIKE A FRUIT CAKE?', 'FULL OF DATES!', ''],
  ['', 'WHATS THE SMARTEST', 'INSECT?', 'A SPELLING BEE!', ''],
  ['', 'WHAT DID SCIENCE', 'SAY TO ART?', 'YOU HAVE NO CLASS!', ''],
  ['', 'WHY DID THE GYM', 'TEACHER GO TO BEACH?', 'TO TEST THE WATERS!', ''],
  ['', 'WHAT DO COMPUTERS', 'SNACK ON?', 'MICRO CHIPS!', ''],
  // SILLY/EVERYDAY (55)
  ['', 'WHY DID THE BICYCLE', 'FALL OVER?', 'IT WAS TWO-TIRED!', ''],
  ['', 'WHATS BROWN', 'AND STICKY?', 'A STICK!', ''],
  ['', 'I DONT TRUST', 'STAIRS', 'ALWAYS UP TO STUFF!', ''],
  ['', 'WHY CANT YOUR NOSE', 'BE 12 INCHES LONG?', "THEN IT'D BE A FOOT!", ''],
  ['', 'WHAT HAS HANDS', 'BUT CANT CLAP?', 'A CLOCK!', ''],
  ['', 'WHAT HAS A HEAD', 'AND A TAIL BUT NO BODY', 'A COIN!', ''],
  ['', 'WHY DID THE GOLFER', 'BRING TWO PANTS?', 'HOLE IN ONE!', ''],
  ['', 'WHAT DO YOU CALL', 'A BOOMERANG THAT', 'WONT COME BACK? STICK', ''],
  ['', 'HOW DO YOU', 'ORGANIZE A SPACE PARTY', 'YOU PLANET!', ''],
  ['', 'HOW DOES THE MOON', 'CUT HIS HAIR?', 'ECLIPSE IT!', ''],
  ['', 'WHY DID THE PICTURE', 'GO TO JAIL?', 'IT WAS FRAMED!', ''],
  ['', 'WHAT DO CLOUDS', 'WEAR UNDERNEATH?', 'THUNDERWEAR!', ''],
  ['', 'WHAT DO YOU CALL', 'A FUNNY MOUNTAIN?', 'HILL-ARIOUS!', ''],
  ['', 'WHY DID THE BELT', 'GET ARRESTED?', 'HELD UP SOME PANTS!', ''],
  ['', 'WHAT DO YOU CALL', 'A SNOWMAN IN SUMMER?', 'A PUDDLE!', ''],
  ['', 'WHAT FALLS BUT', 'NEVER GETS HURT?', 'RAIN!', ''],
  ['', 'WHY DID THE SCARECROW', 'WIN AN AWARD?', 'OUTSTANDING IN FIELD', ''],
  ['', 'HOW DO MOUNTAINS', 'SEE?', 'THEY PEAK!', ''],
  ['', 'WHAT DID ONE WALL', 'SAY TO THE OTHER?', 'MEET YOU AT CORNER!', ''],
  ['', 'WHAT DID ONE HAT', 'SAY TO THE OTHER?', 'YOU WAIT HERE!', ''],
  ['', 'WHY DO BALLOONS', 'HATE GOING TO SCHOOL?', 'POP QUIZZES!', ''],
  ['', 'HOW DO YOU CATCH', 'A SQUIRREL?', 'ACT LIKE A NUT!', ''],
  ['', 'WHAT DID THE OCEAN', 'SAY TO THE BEACH?', 'NOTHING IT WAVED!', ''],
  ['', 'WHY CANT YOU', 'GIVE ELSA A BALLOON?', "SHE'LL LET IT GO!", ''],
  ['', 'WHAT DO YOU CALL', 'A TRAIN THAT SNEEZES?', 'ACHOO CHOO TRAIN!', ''],
  ['', 'WHAT ROOM HAS', 'NO DOORS OR WINDOWS?', 'A MUSHROOM!', ''],
  ['', 'WHY DID THE MATH', 'TEACHER GO OUTSIDE?', 'TO USE A PRO-TRACTOR', ''],
  ['', 'HOW DO TREES', 'GET ON THE INTERNET?', 'THEY LOG IN!', ''],
  ['', 'WHY DID THE TEDDY', 'BEAR SKIP DESSERT?', 'IT WAS STUFFED!', ''],
  ['', 'WHAT DID ONE TOILET', 'SAY TO THE OTHER?', 'YOU LOOK FLUSHED!', ''],
  ['', 'WHY WAS THE ROBOT', 'SO TIRED?', 'HAD A HARD DRIVE!', ''],
  ['', 'WHY DID THE SHOE', 'GO TO THE DOCTOR?', 'IT HAD LOST ITS SOLE', ''],
  ['', 'WHAT DO DENTISTS', 'CALL THEIR X-RAYS?', 'TOOTH PICS!', ''],
  ['', 'WHY DID THE PHONE', 'WEAR GLASSES?', 'LOST ITS CONTACTS!', ''],
  ['', 'WHATS A VAMPIRES', 'FAVORITE FRUIT?', 'A BLOOD ORANGE!', ''],
  ['', 'WHY DO GHOSTS', 'MAKE BAD LIARS?', 'YOU SEE THROUGH EM!', ''],
  ['', 'WHAT DO SKELETONS', 'ORDER AT A CAFE?', 'SPARE RIBS!', ''],
  ['', 'WHY CANT SKELETONS', 'FIGHT EACH OTHER?', 'NO GUTS!', ''],
  ['', 'WHY WAS THE', 'COMPUTER COLD?', 'LEFT ITS WINDOWS OPEN', ''],
  ['', 'WHY DID THE LAMP', 'GO TO SCHOOL?', 'TO GET BRIGHTER!', ''],
  ['', 'HOW DOES A PENGUIN', 'BUILD ITS HOUSE?', 'IGLOOS IT TOGETHER!', ''],
  ['', 'WHAT DID THE', 'STAMP SAY TO ENVELOPE', 'STICK WITH ME!', ''],
  ['', 'WHAT DID THE TRAFFIC', 'LIGHT SAY TO THE CAR?', 'DONT LOOK I CHANGE!', ''],
  ['', 'WHAT DID THE LEFT', 'EYE SAY TO THE RIGHT?', 'BETWEEN US SOMETHING', ''],
  ['', 'HOW DOES A BARBER', 'WIN A RACE?', 'HE KNOWS A SHORTCUT', ''],
  ['', 'WHAT DO YOU CALL', 'A CAN OPENER THATS', 'BROKEN? CANT OPENER', ''],
  ['', 'WHY DID THE KID', 'BRING A CLOCK TO LUNCH', 'HE WANTED SECONDS!', ''],
  ['', 'WHAT DID THE JANITOR', 'SAY WHEN HE JUMPED OUT', 'SUPPLIES!', ''],
  ['', 'WHAT DO ASTRONAUTS', 'EAT FOR DINNER?', 'LAUNCH!', ''],
  ['', 'WHY DO WE TELL', 'ACTORS TO BREAK A LEG?', 'EVERY PLAY HAS CAST!', ''],
  // SCIENCE & NATURE (25)
  ['', 'WHAT IS A TORNADOS', 'FAVORITE GAME?', 'TWISTER!', ''],
  ['', 'WHAT DID EARTH SAY', 'TO THE OTHER PLANETS?', 'YOU HAVE NO LIFE!', ''],
  ['', 'WHY DOES THE MOON', 'NEED A LOAN?', 'ITS DOWN TO QUARTER!', ''],
  ['', 'WHY CANT FLOWERS', 'RIDE A BICYCLE?', 'NO PETALS! OH WAIT!', ''],
  ['', 'WHAT IS A ROCKS', 'FAVORITE MUSIC?', 'ROCK AND ROLL!', ''],
  ['', 'WHY DO VOLCANOES', 'GET INVITED OUT?', "THEY'RE A BLAST!", ''],
  ['', 'WHAT DID THE BIG', 'FLOWER SAY TO SMALL?', 'HEY THERE BUD!', ''],
  ['', 'WHAT RUNS BUT', 'NEVER GETS TIRED?', 'WATER!', ''],
  ['', 'HOW MUCH DOES IT', 'COST TO GO TO SPACE?', 'A LOT OF BUCKS!', ''],
  ['', 'WHAT KIND OF MUSIC', 'DO PLANETS LISTEN TO?', 'NEPTUNES!', ''],
  ['', 'WHY DID THE LEAF', 'GO TO THE DOCTOR?', 'FEELING GREEN!', ''],
  ['', 'WHAT DO CLOUDS DO', 'WHEN THEY GET RICH?', 'MAKE IT RAIN!', ''],
  ['', 'WHY IS THE GRASS', 'SO DANGEROUS?', 'FULL OF BLADES!', ''],
  ['', 'HOW DO SCIENTISTS', 'FRESHEN THEIR BREATH?', 'EXPERI-MINTS!', ''],
  ['', 'WHAT DO YOU DO', 'WITH A SICK CHEMIST?', 'CANT HELIUM CANT', ''],
  ['', 'WHAT IS A LIGHT', 'YEARS FAVORITE SNACK?', 'MARS BARS!', ''],
  ['', 'WHY ARE ATOMS', 'ALWAYS LYING?', 'THEY MAKE EVERYTHING', ''],
  ['', 'WHAT DID MARS SAY', 'TO SATURN?', 'GIVE ME A RING!', ''],
  ['', 'HOW DO YOU KNOW', 'THE OCEAN IS FRIENDLY?', 'IT WAVES!', ''],
  ['', 'WHY DID THE TREE', 'GO TO THE DENTIST?', 'ROOT CANAL!', ''],
  ['', 'WHAT IS WINDS', 'FAVORITE COLOR?', 'BLEW!', ''],
  ['', 'WHY DO HURRICANES', 'HAVE NAMES?', "THEY'D GET LOST!", ''],
  // POP CULTURE & MISC (25)
  ['', 'WHY DID MARIO', 'GO TO THE DOCTOR?', 'MUSHROOM PROBLEMS!', ''],
  ['', 'WHAT DO MINIONS', 'CALL THEIR LEADER?', 'BANANA!', ''],
  ['', 'WHY DOES PETER PAN', 'ALWAYS FLY?', 'HE NEVERLANDS!', ''],
  ['', 'WHAT IS THORS', 'FAVORITE DAY?', 'THORS-DAY!', ''],
  ['', 'WHY WAS CINDERELLA', 'BAD AT SOCCER?', 'SHE RAN FROM BALL!', ''],
  ['', 'WHAT DO YOU CALL', 'SPIDERMAN ON A BREAK?', 'PETER PARKER!', ''],
  ['', 'WHAT DO YOU CALL', 'SHREK AT THE BEACH?', 'AN OGRE-TAN!', ''],
  ['', 'WHY DID YODA GO', 'TO THE BANK?', 'NEED A FORCE DEPOSIT', ''],
  ['', 'WHAT DOES IRONMAN', 'AND SILVER SURFER MAKE', 'ALLOYS!', ''],
  ['', 'HOW DOES DARTH', 'VADER LIKE HIS TOAST?', 'ON THE DARK SIDE!', ''],
  ['', 'WHAT DO YOU CALL', 'ELSA WITH A SUNBURN?', 'MELTDOWN!', ''],
  ['', 'WHY IS GROOT', 'BAD AT TESTS?', 'HE ONLY KNOWS ONE!', ''],
  ['', 'WHAT DOES SONIC', 'EAT FOR BREAKFAST?', 'FAST FOOD!', ''],
  ['', 'HOW DOES PIKACHU', 'SAY HELLO?', 'WATTS UP!', ''],
  ['', 'WHY CANT HARRY', 'POTTER TELL JOKES?', 'RIDDIKULUS!', ''],
  ['', 'WHAT DO YOU CALL', 'HOGWARTS WITHOUT MAGIC', 'BORING SCHOOL!', ''],
  ['', 'WHY DID SPONGEBOB', 'FAIL HIS TEST?', 'BELOW C LEVEL!', ''],
  ['', 'WHY WAS THE', 'MATH WIZARD SO COOL?', 'HAD TOO MANY FANS!', ''],
  ['', 'WHAT DID THE', 'POKEMON SAY AT EASTER?', 'PIKACHU EGGS!', ''],
  ['', 'WHAT CAR DOES', 'LUKE SKYWALKER DRIVE?', 'A TOY-YODA!', ''],
  ['', 'WHY DID GOLLUM', 'GO TO THERAPY?', 'RING ATTACHMENT ISSUE', '']
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
  ['', 'DID YOU KNOW?', 'A GROUP OF FLAMINGOS', 'IS A FLAMBOYANCE', ''],
  ['', 'DID YOU KNOW?', 'HONEY NEVER', 'GOES BAD EVER!', ''],
  ['', 'DID YOU KNOW?', 'OCTOPUSES HAVE', 'THREE HEARTS!', ''],
  ['', 'DID YOU KNOW?', 'BANANAS ARE', 'ACTUALLY BERRIES!', ''],
  ['', 'DID YOU KNOW?', 'A SNAIL CAN SLEEP', 'FOR THREE YEARS!', ''],
  ['', 'DID YOU KNOW?', 'COWS HAVE', 'BEST FRIENDS!', ''],
  ['', 'DID YOU KNOW?', 'YOUR NOSE CAN SMELL', 'ONE TRILLION SCENTS', ''],
  ['', 'DID YOU KNOW?', 'DOLPHINS SLEEP WITH', 'ONE EYE OPEN!', ''],
  ['', 'DID YOU KNOW?', 'A SHRIMP HAS ITS', 'HEART IN ITS HEAD!', ''],
  ['', 'DID YOU KNOW?', 'FROGS DRINK WATER', 'THROUGH THEIR SKIN!', ''],
  ['', 'DID YOU KNOW?', 'BUTTERFLIES TASTE', 'WITH THEIR FEET!', ''],
  ['', 'DID YOU KNOW?', 'SEA OTTERS HOLD', 'HANDS WHEN SLEEPING', ''],
  ['', 'DID YOU KNOW?', 'A BOLT OF LIGHTNING', 'IS FIVE TIMES HOTTER', ''],
  ['', 'DID YOU KNOW?', 'YOUR BONES ARE', 'STRONGER THAN STEEL', ''],
  ['', 'DID YOU KNOW?', 'CATS SPEND 70 PERCENT', 'OF THEIR LIFE NAPPING', '']
];

// --- SPACE FACTS (15) ---

const SPACE_FACTS = [
  ['', 'SPACE FACT!', 'JUPITER HAS', '95 MOONS', ''],
  ['', 'SPACE FACT!', 'THE SUN IS A STAR', 'NOT A PLANET', ''],
  ['', 'SPACE FACT!', 'ONE DAY ON VENUS', 'IS 243 EARTH DAYS', ''],
  ['', 'SPACE FACT!', 'SATURN COULD FLOAT', 'IN A GIANT BATHTUB', ''],
  ['', 'SPACE FACT!', 'THE MOON HAS', 'NO WIND AT ALL', ''],
  ['', 'SPACE FACT!', 'MARS IS CALLED', 'THE RED PLANET', ''],
  ['', 'SPACE FACT!', 'SPACE IS TOTALLY', 'SILENT', ''],
  ['', 'SPACE FACT!', 'A YEAR ON MERCURY', 'IS JUST 88 DAYS', ''],
  ['', 'SPACE FACT!', 'NEPTUNE HAS', 'SUPERSONIC WINDS', ''],
  ['', 'SPACE FACT!', 'YOU WEIGH LESS', 'ON THE MOON', ''],
  ['', 'SPACE FACT!', 'THE SUN IS 93', 'MILLION MILES AWAY', ''],
  ['', 'SPACE FACT!', 'THERE ARE MORE STARS', 'THAN GRAINS OF SAND', ''],
  ['', 'SPACE FACT!', 'FOOTPRINTS ON THE', 'MOON LAST FOREVER', ''],
  ['', 'SPACE FACT!', 'EARTH SPINS AT', '1000 MILES PER HOUR', ''],
  ['', 'SPACE FACT!', 'ASTRONAUTS GROW', 'TALLER IN SPACE', '']
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

// --- COMBINED DEFAULT SET (quotes + jokes + riddles + new categories) ---

export const DEFAULT_MESSAGES = [...QUOTES, ...JOKES, ...RIDDLES, ...KNOCK_KNOCKS, ...FUN_FACTS, ...SPACE_FACTS, ...VOCABULARY, ...MATH_PUZZLES];

export const TIME_SLOTS = [
  { startHour: 7, endHour: 8, messages: MORNING_MESSAGES },
  { startHour: 19.5, endHour: 20.5, messages: BEDTIME_MESSAGES }
];