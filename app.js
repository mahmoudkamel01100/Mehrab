// App State
const state = {
    currentView: 'home',
    activeTab: 'hawamdya',
    audio: null,
    isPlaying: false,
    currentTrack: null,
    isRepeat: false,
    tasbihCount: 0,
    currentAzkarType: 'morning',
    azkarData: {
        morning: [
            { id: 1, text: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.", count: 1, benefit: "من قالها حين يصبح وحين يمسي كفته من كل شيء." },
            { id: 2, text: "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ.", count: 1, benefit: "أذكار الصباح المأثورة عن النبي ﷺ." },
            { id: 3, text: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.", count: 3, benefit: "لم يضره من الله شيء." },
            { id: 4, text: "أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.", count: 3, benefit: "حفظ من لدغ العقرب والهوام." },
            { id: 5, text: "سُبْحَانَ اللهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.", count: 3, benefit: "تعدل ساعات طويلة من العبادة والذكر." }
        ],
        evening: [
            { id: 1, text: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.", count: 1, benefit: "من قالها حين يصبح وحين يمسي كفته من كل شيء." },
            { id: 2, text: "اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ.", count: 1, benefit: "أذكار المساء المأثورة عن النبي ﷺ." },
            { id: 3, text: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.", count: 3, benefit: "لم يضره من الله شيء." },
            { id: 4, text: "أَمْسَيْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ.", count: 1, benefit: "الاعتراف بالفطرة والإسلام." },
            { id: 5, text: "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.", count: 3, benefit: "دعاء الكرب وتيسير الأمور." }
        ]
    },
    activeAzkar: []
};

// Data Structures
const recitersData = {
    hawamdya: [
        { id: 'h1', name: 'الشيخ حمدي أبو الدهب', avatar: 'images/Hdahab.jpg', type: 'hawamdya', server: 'mock' },
        { id: 'h2', name: 'الشيخ محمود عبدالسلام', avatar: 'images/Msalam.jpg', type: 'hawamdya', server: 'mock' },
        { id: 'h3', name: 'الشيخ محمد حسني', avatar: 'images/Mhosny.jpg', type: 'hawamdya', server: 'mock' },
        { id: 'h4', name: 'الشيخ محمد جمعة', avatar: 'images/Mgomaa.jpg', type: 'hawamdya', server: 'mock' },
        { id: 'h5', name: 'الشيخ حنفي محمود', avatar: 'images/Mhanafy.jpg', type: 'hawamdya', server: 'mock' },
        { id: 'h6', name: 'الشيخ عبدالرحمن مصطفى', avatar: 'images/AbdoMostafa.jpg', type: 'hawamdya', server: 'mock' }
    ],
    egypt: [
        { id: 'e1', name: 'محمد صديق المنشاوي - مرتل 🇪🇬', avatar: 'images/MMenshawy.jpg', type: 'egypt', server: 'https://server10.mp3quran.net/minsh/' },
        { id: 'e2', name: 'محمد الطبلاوي - مجود 🇪🇬', avatar: 'images/MTablawy.jpg', type: 'egypt', server: 'https://server12.mp3quran.net/tblwy_mjod/' },
        { id: 'e3', name: 'أحمد نعينع - مجود 🇪🇬', avatar: 'images/ANeana3.jpg', type: 'egypt', server: 'https://server11.mp3quran.net/na3na_mjod/' },
        { id: 'e4', name: 'عبدالله كامل - مرتل 🇪🇬', avatar: 'images/AKamel.jpg', type: 'egypt', server: 'https://server16.mp3quran.net/kamal/' },
        { id: 'e5', name: 'عبدالباسط عبدالصمد - مرتل 🇪🇬', avatar: 'images/Abdelbaset.jpg', type: 'egypt', server: 'https://server7.mp3quran.net/basit/' },
        { id: 'e6', name: 'عبدالباسط عبدالصمد - مجود 🇪🇬', avatar: 'images/Abdelbaset.jpg', type: 'egypt', server: 'https://server13.mp3quran.net/basit_mjod/' },
        { id: 'e7', name: 'محمود خليل الحصري - مرتل 🇪🇬', avatar: 'images/7osary.jpg', type: 'egypt', server: 'https://server13.mp3quran.net/husr/' },
        { id: 'e8', name: 'محمود خليل الحصري - مجود 🇪🇬', avatar: 'images/7osary.jpg', type: 'egypt', server: 'https://server12.mp3quran.net/husr_mjod/' },
        { id: 'e9', name: 'محمود علي البنا - مرتل 🇪🇬', avatar: 'images/MAlbana.jpg', type: 'egypt', server: 'https://server8.mp3quran.net/banna/' },
        { id: 'e10', name: 'أحمد محمد عامر - مرتل 🇪🇬', avatar: 'images/Ahmed-amer.png', type: 'egypt', server: 'https://server10.mp3quran.net/a_amer/' }
    ],
    saudi: [
        { id: 's1', name: 'محمد علي الحذيفي - مرتل 🇸🇦', avatar: 'images/7ozify.jpg', type: 'saudi', server: 'https://server9.mp3quran.net/hudhaify/' },
        { id: 's2', name: 'أحمد العجمي - مرتل 🇸🇦', avatar: 'images/Agamy.jpg', type: 'saudi', server: 'https://server10.mp3quran.net/ajm/' },
        { id: 's3', name: 'سعد الغامدي - مرتل 🇸🇦', avatar: 'images/Saad_Ghamdy.jpg', type: 'saudi', server: 'https://server7.mp3quran.net/s_gmd/' },
        { id: 's4', name: 'سعود الشريم - مرتل 🇸🇦', avatar: 'images/ElShorem.jpg', type: 'saudi', server: 'https://server7.mp3quran.net/shur/' },
        { id: 's5', name: 'عبدالرحمن السديس - مرتل 🇸🇦', avatar: 'images/Sodes.jpg', type: 'saudi', server: 'https://server11.mp3quran.net/sds/' },
        { id: 's6', name: 'ماهر المعيقلي - مرتل 🇸🇦', avatar: 'images/Maher.png', type: 'saudi', server: 'https://server12.mp3quran.net/maher/' },
        { id: 's7', name: 'محمد أيوب - مرتل 🇸🇦', avatar: 'images/Ayob.jpeg', type: 'saudi', server: 'https://server8.mp3quran.net/ayoub/' },
        { id: 's8', name: 'ناصر القطامي - مرتل 🇸🇦', avatar: 'images/Katamy.jpg', type: 'saudi', server: 'https://server11.mp3quran.net/qtm/' },
        { id: 's9', name: 'ياسر الدوسري - مرتل 🇸🇦', avatar: 'images/Dosary.jpg', type: 'saudi', server: 'https://server11.mp3quran.net/yasser/' }
    ]
};

// Dynamic 114 Surah list generation
const surahNames = [
    "الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة", "الأنعام", "الأعراف", "الأنفال", "التوبة", "يونس",
    "هود", "يوسف", "الرعد", "إبراهيم", "الحجر", "النحل", "الإسراء", "الكهف", "مريم", "طه",
    "الأنبياء", "الحج", "المؤمنون", "النور", "الفرقان", "الشعراء", "النمل", "القصص", "العنكبوت", "الروم",
    "لقمان", "السجدة", "الأحزاب", "سبأ", "فاطر", "يس", "الصافات", "ص", "الزمر", "غافر",
    "فصلت", "الشورى", "الزخرف", "الدخان", "الجاثية", "الأحقاف", "محمد", "الفتح", "الحجرات", "ق",
    "الذاريات", "الطور", "النجم", "القمر", "الرحمن", "الواقعة", "الحديد", "المجادلة", "الحشر", "الممتحنة",
    "الصف", "الجمعة", "المنافقون", "التغابن", "الطلاق", "التحريم", "الملك", "القلم", "الحاقة", "المعارج",
    "نوح", "الجن", "المزمل", "المدثر", "القيامة", "الإنسان", "المرسلات", "النبأ", "النازعات", "عبس",
    "التكوير", "الانفطار", "المطففين", "الانشقاق", "البروج", "الطارق", "الأعلى", "الغاشية", "الفجر", "البلد",
    "الشمس", "الليل", "الضحى", "الشرح", "التين", "العلق", "القدر", "البينة", "الزلزلة", "العاديات",
    "القارعة", "التكاثر", "العصر", "الهمزة", "الفيل", "قريش", "الماعون", "الكوثر", "الكافرون", "النصر",
    "المسد", "الإخلاص", "الفلق", "الناس"
];

const surahList = surahNames.map((name, index) => {
    const num = String(index + 1).padStart(3, '0');
    return { num: num, name: `سورة ${name}` };
});

// Airtable Configuration & Fetch Logic
const airtableConfig = {
    apiKey: 'patbQBh65alVVwMju.8ca4c598d1db7e728b4224c58b20958ba3c87717e2ec4e1e02d46cce6af09ada',
    baseId: 'appAqknF6wbsid5Xu',
    tableName: 'Qoran'
};

let airtableData = {}; // Cache: { columnName: { surahNum: url } }

const reciterIdToAirtableColumn = {
    'h1': 'حمدى أبو الدهب',
    'h2': 'محمود عبد السلام',
    'h3': 'محمد حسنى',
    'h4': 'محمد جمعة',
    'h5': 'حنفى محمود',
    'h6': 'عبدالرحمن مصطفى',
    'e1': 'محمد صديق المنشاوى',
    'e2': 'محمد الطبلاوى',
    'e3': 'أحمد نعينع',
    'e4': 'عبدالله كامل',
    'e5': 'عبدالباسط عبدالصمد1',
    'e6': 'عبدالباسط عبدالصمد2',
    'e7': 'محمود خليل الحصرى1',
    'e8': 'محمود خليل الحصرى2',
    'e9': 'محمود على البنا',
    'e10': 'أحمد محمد عامر',
    's1': 'محمد على الحذيفى',
    's2': 'أحمد العجمى',
    's3': 'سعد الغامدى',
    's4': 'سعود الشريم',
    's5': 'عبدالرحمن السديس',
    's6': 'ماهر المعيقلى',
    's7': 'محمد أيوب',
    's8': 'ناصر القطامى',
    's9': 'ياسر الدوسرى'
};

function normalizeArabic(text) {
    if (!text) return '';
    return text
        .trim()
        .replace(/^سورة\s+/, '')
        .trim()
        .replace(/[أإآ]/g, 'ا')
        .replace(/ة/g, 'ه')
        .replace(/[ّ]/g, '');
}

function cleanAudioUrl(url) {
    if (!url) return '';
    // Convert iaXXXXXX.us.archive.org/XX/items/ to archive.org/download/ to bypass dead/offline subdomains
    return url.replace(/https?:\/\/ia\d+\.us\.archive\.org\/\d+\/items\//i, 'https://archive.org/download/');
}

async function fetchAirtableRecords(offset = '') {
    let url = `https://api.airtable.com/v0/${airtableConfig.baseId}/${encodeURIComponent(airtableConfig.tableName)}?pageSize=100`;
    if (offset) {
        url += `&offset=${offset}`;
    }

    try {
        const response = await fetch(url, {
            headers: {
                'Authorization': `Bearer ${airtableConfig.apiKey}`
            }
        });
        if (!response.ok) throw new Error(`HTTP error status: ${response.status}`);
        const data = await response.json();
        
        if (data.records) {
            data.records.forEach(record => {
                const soraName = record.fields.sora;
                if (!soraName) return;
                
                const normalized = normalizeArabic(soraName);
                const surahIdx = surahNames.findIndex(name => normalizeArabic(name) === normalized);
                if (surahIdx !== -1) {
                    const surahNum = (surahIdx + 1).toString().padStart(3, '0');
                    
                    for (const columnName in record.fields) {
                        if (columnName === 'sora') continue;
                        if (!airtableData[columnName]) {
                            airtableData[columnName] = {};
                        }
                        airtableData[columnName][surahNum] = cleanAudioUrl(record.fields[columnName]);
                    }
                }
            });
        }

        if (data.offset) {
            await fetchAirtableRecords(data.offset);
        } else {
            console.log('Airtable loaded successfully. Reciters:', Object.keys(airtableData).length);
        }
    } catch (err) {
        console.error('Error fetching Airtable records:', err);
    }
}

// Custom Lectures cache for Dr. Saad Hamouda
const saadReciterObject = { id: 'l1', name: 'د. سعد حمودة', avatar: 'images/DRsaad.png', type: 'hamouda', server: 'mock' };
let activeSaadTable = null;
let activeSaadTitle = '';
const saadCache = {
    saad_nahw: null,
    saad_videos_YouTube: null,
    saad_5otab: null
};

// Initialize Application
document.addEventListener('DOMContentLoaded', () => {
    updateDateDisplay();
    calculatePrayerTimes();
    renderReciters();
    resetAzkar();
    initPlayerEvents();

    // Local Storage for Tasbih
    if(localStorage.getItem('tasbihCount')) {
        state.tasbihCount = parseInt(localStorage.getItem('tasbihCount'));
        document.getElementById('tasbih-counter').innerText = state.tasbihCount;
    }

    // Local Storage for Theme
    if(localStorage.getItem('themeMode')) {
        setThemeMode(localStorage.getItem('themeMode'));
    }

    // Load Airtable Data
    fetchAirtableRecords();

    // Render Quran Text (Offline Uthmani)
    renderQuranTextSurahs();

    // Check for saved reading position
    checkLastReadBookmark();

    // Bind scroll listener for written Quran auto-save
    const readerBody = document.getElementById('quran-reader-body');
    if (readerBody) {
        readerBody.addEventListener('scroll', handleQuranScroll);
    }

    // Set initial checkbox state for Adhan notifications
    const webNotifSwitch = document.getElementById('web-notifications-switch');
    if (webNotifSwitch) {
        const isEnabled = localStorage.getItem('webAdhanNotificationsEnabled') === 'true';
        webNotifSwitch.checked = isEnabled;
    }

    // Setup background prayer check for web notifications (run every 30 seconds)
    setInterval(checkPrayerTimesForNotifications, 30000);
});

// Update Header Hijri and Gregorian Dates
function updateDateDisplay() {
    const today = new Date();
    
    // Gregorian Formatting
    const gregOptions = { weekday: 'long', year: 'numeric', month: 'numeric', day: 'numeric' };
    const gregStr = today.toLocaleDateString('ar-EG', gregOptions);
    document.getElementById('gregorian-date-header').innerText = gregStr;

    // Hijri Formatting (Built-in to Browser Intl)
    try {
        const hijriOptions = { day: 'numeric', month: 'long', year: 'numeric' };
        const hijriFormatter = new Intl.DateTimeFormat('ar-SA-u-ca-islamic', hijriOptions);
        const hijriStr = hijriFormatter.format(today);
        document.getElementById('hijri-date-header').innerText = hijriStr;
    } catch(e) {
        document.getElementById('hijri-date-header').innerText = "التاريخ الهجري غير متاح";
    }
}

/* 
  Calculates Offline Prayer Times for Al-Hawamdeya
  Coordinates: Lat: 29.8967, Lng: 31.2631
  Calculation Method: Egyptian General Authority of Survey (declination: Fajr -19.5, Isha -17.5)
*/
function calculatePrayerTimes() {
    const date = new Date();
    const lat = 29.8967;
    const lng = 31.2631;

    // Timezone offset check (Egypt uses UTC+3 for DST from late April to late Oct, else UTC+2)
    // We can compute timezone offset from the system date dynamically
    const timezone = -date.getTimezoneOffset() / 60; 

    // Convert Date to Julian Date
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    
    let a = Math.floor((14 - month) / 12);
    let y = year + 4800 - a;
    let m = month + 12 * a - 3;
    let jd = day + Math.floor((153 * m + 2) / 5) + 365 * y + Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400) - 32045;

    // Solar coordinates
    let d = jd - 2451545.0; // days since J2000
    let g = (357.529 + 0.98560028 * d) % 360;
    let q = (280.459 + 0.98564736 * d) % 360;
    let L = (q + 1.915 * Math.sin(rad(g)) + 0.020 * Math.sin(rad(2 * g))) % 360;
    
    let R = 1.00014 - 0.01671 * Math.cos(rad(g)) - 0.00014 * Math.cos(rad(2 * g));
    let e = 23.439 - 0.00000036 * d;
    
    let DD = deg(Math.asin(Math.sin(rad(e)) * Math.sin(rad(L)))); // Declination
    let RA = deg(Math.atan2(Math.cos(rad(e)) * Math.sin(rad(L)), Math.cos(rad(L)))) / 15; // Right Ascension
    RA = (RA + 24) % 24;
    
    let EqT = q/15 - RA; // Equation of time

    // Midday (Dhuhr)
    let noon = (12 + timezone - lng / 15 - EqT + 24) % 24;

    // Sunrise and Sunset
    let U_sunrise = solarAngle(lat, DD, -0.833);
    let sunrise = noon - U_sunrise / 15;
    let sunset = noon + U_sunrise / 15;

    // Fajr (declination -19.5 for Egyptian Survey)
    let U_fajr = solarAngle(lat, DD, -19.5);
    let fajr = noon - U_fajr / 15;

    // Isha (declination -17.5 for Egyptian Survey)
    let U_isha = solarAngle(lat, DD, -17.5);
    let isha = noon + U_isha / 15;

    // Asr (Shadow length = 1 + shadow at noon)
    let g_asr = deg(Math.atan(1 + Math.tan(rad(Math.abs(lat - DD)))));
    let U_asr = solarAngle(lat, DD, 90 - g_asr);
    let asr = noon + U_asr / 15;

    // Display Timings
    const formatTime = (t) => {
        let h = Math.floor(t);
        let min = Math.floor((t - h) * 60);
        let ampm = h >= 12 ? 'م' : 'ص';
        h = h % 12;
        h = h ? h : 12; // 0 should be 12
        let minStr = min < 10 ? '0' + min : min;
        return `${h}:${minStr} ${ampm}`;
    };

    document.querySelector('#prayer-fajr .time').innerText = formatTime(fajr);
    document.querySelector('#prayer-shuruq .time').innerText = formatTime(sunrise);
    document.querySelector('#prayer-dhuhr .time').innerText = formatTime(noon);
    document.querySelector('#prayer-asr .time').innerText = formatTime(asr);
    document.querySelector('#prayer-maghrib .time').innerText = formatTime(sunset);
    document.querySelector('#prayer-isha .time').innerText = formatTime(isha);

    // Highlight next prayer card based on current time
    highlightNextPrayer(fajr, sunrise, noon, asr, sunset, isha);
}

function solarAngle(lat, DD, angle) {
    let omega = Math.acos((Math.sin(rad(angle)) - Math.sin(rad(lat)) * Math.sin(rad(DD))) / (Math.cos(rad(lat)) * Math.cos(rad(DD))));
    return deg(omega);
}

function rad(d) { return d * Math.PI / 180; }
function deg(r) { return r * 180 / Math.PI; }

function highlightNextPrayer(fajr, sunrise, noon, asr, sunset, isha) {
    const now = new Date();
    const currTime = now.getHours() + now.getMinutes() / 60;
    
    let nextId = '';
    if (currTime < fajr) nextId = 'prayer-fajr';
    else if (currTime >= fajr && currTime < sunrise) nextId = 'prayer-shuruq';
    else if (currTime >= sunrise && currTime < noon) nextId = 'prayer-dhuhr';
    else if (currTime >= noon && currTime < asr) nextId = 'prayer-asr';
    else if (currTime >= asr && currTime < sunset) nextId = 'prayer-maghrib';
    else if (currTime >= sunset && currTime < isha) nextId = 'prayer-isha';
    else nextId = 'prayer-fajr'; // After Isha, the next is Fajr tomorrow

    document.querySelectorAll('.prayer-card').forEach(card => card.classList.remove('active'));
    const nextCard = document.getElementById(nextId);
    if(nextCard) nextCard.classList.add('active');
}

// Navigation Tab Switcher
function switchTab(viewId) {
    state.currentView = viewId;
    
    // Toggle View Sections
    document.querySelectorAll('.app-view').forEach(view => {
        view.classList.remove('active');
    });
    const selectedView = document.getElementById(`view-${viewId}`);
    if (selectedView) selectedView.classList.add('active');

    // Toggle Nav Bar Active Class
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
    });
    const selectedNav = document.getElementById(`nav-${viewId}`);
    if (selectedNav) selectedNav.classList.add('active');

    // Close floating surah panel if active when changing views
    closeSurahPanel();

    if (viewId === 'saad') {
        renderSaadStandaloneCategories();
    }
}

// Render Reciters list based on active tab filtering
function renderReciters() {
    const container = document.getElementById('reciters-container');
    container.innerHTML = '';
    
    const reciters = recitersData[state.activeTab];
    reciters.forEach(reciter => {
        const card = document.createElement('div');
        card.className = 'reciter-card card';
        card.onclick = () => openSurahPanel(reciter);

        card.innerHTML = `
            <img class="reciter-avatar" src="${reciter.avatar}" alt="${reciter.name}">
            <span class="reciter-info-name">${reciter.name}</span>
        `;
        container.appendChild(card);
    });
}

function filterReciters(category) {
    state.activeTab = category;
    
    // Toggle category tab buttons active state
    document.querySelectorAll('.category-tabs .tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    event.currentTarget.classList.add('active');

    renderReciters();
}

// Surah selector panel open/close
let selectedReciter = null;
function openSurahPanel(reciter) {
    selectedReciter = reciter;
    
    // Restore default search bar display
    document.querySelector('.surah-search').style.display = 'flex';
    document.getElementById('surah-search-input').value = '';
    
    if (reciter.type === 'hamouda') {
        showSaadCategories();
    } else {
        document.getElementById('panel-reciter-name').innerText = reciter.name;
        const container = document.getElementById('surah-list-container');
        container.innerHTML = '';

        surahList.forEach(item => {
            const row = document.createElement('div');
            row.className = 'surah-item';
            row.onclick = () => playAudio(reciter, item);

            row.innerHTML = `
                <div class="surah-title-right">
                    <span class="surah-index">${parseInt(item.num)}</span>
                    <span>${item.name}</span>
                </div>
                <i class="fa-solid fa-circle-play play-icon-left"></i>
            `;
            container.appendChild(row);
        });
    }

    document.getElementById('surah-panel').classList.add('active');
}

function closeSurahPanel() {
    document.getElementById('surah-panel').classList.remove('active');
    document.getElementById('surah-search-input').value = '';
    activeSaadTable = null;
    activeSaadTitle = '';
}

function searchSurah() {
    const query = document.getElementById('surah-search-input').value.trim().toLowerCase();
    const container = document.getElementById('surah-list-container');
    
    if (selectedReciter && selectedReciter.id === 'l1' && activeSaadTable) {
        const items = saadCache[activeSaadTable] || [];
        const filtered = items.filter(item => (item.title || '').toLowerCase().includes(query));
        renderSaadItems(filtered);
        return;
    }

    container.innerHTML = '';
    const filtered = surahList.filter(item => item.name.includes(query));

    filtered.forEach(item => {
        const row = document.createElement('div');
        row.className = 'surah-item';
        row.onclick = () => playAudio(selectedReciter, item);

        row.innerHTML = `
            <div class="surah-title-right">
                <span class="surah-index">${parseInt(item.num)}</span>
                <span>${item.name}</span>
            </div>
            <i class="fa-solid fa-circle-play play-icon-left"></i>
        `;
        container.appendChild(row);
    });
}

function showSaadCategories() {
    activeSaadTable = null;
    activeSaadTitle = '';
    
    document.getElementById('panel-reciter-name').innerText = "د. سعد حمودة - الأقسام";
    document.querySelector('.surah-search').style.display = 'none';
    
    const container = document.getElementById('surah-list-container');
    container.innerHTML = `
        <div class="saad-categories-grid">
            <div class="saad-category-card" onclick="openSaadCategory('saad_nahw', 'دروس النحو')">
                <div class="category-icon-wrapper"><i class="fa-solid fa-book-open"></i></div>
                <div class="category-info">
                    <h4>دروس النحو</h4>
                    <p>شرح كتاب قواعد اللغة العربية والنحو بالتفصيل</p>
                </div>
                <i class="fa-solid fa-chevron-left category-arrow"></i>
            </div>
            
            <div class="saad-category-card" onclick="openSaadCategory('saad_videos_YouTube', 'فيديوهات متنوعة')">
                <div class="category-icon-wrapper"><i class="fa-solid fa-video"></i></div>
                <div class="category-info">
                    <h4>فيديوهات متنوعة</h4>
                    <p>دروس يوتيوب دينية وفتاوى علمية متنوعة</p>
                </div>
                <i class="fa-solid fa-chevron-left category-arrow"></i>
            </div>
            
            <div class="saad-category-card" onclick="openSaadCategory('saad_5otab', 'خطب صوتية')">
                <div class="category-icon-wrapper"><i class="fa-solid fa-microphone"></i></div>
                <div class="category-info">
                    <h4>خطب صوتية</h4>
                    <p>خطب الجمعة والمحاضرات الصوتية بصوت الشيخ</p>
                </div>
                <i class="fa-solid fa-chevron-left category-arrow"></i>
            </div>
        </div>
    `;
}

async function openSaadCategory(tableName, categoryTitle) {
    activeSaadTable = tableName;
    activeSaadTitle = categoryTitle;
    
    document.getElementById('panel-reciter-name').innerHTML = `
        <span class="back-btn-saad" onclick="showSaadCategories()"><i class="fa-solid fa-arrow-right"></i></span>
        <span>${categoryTitle}</span>
    `;
    
    document.querySelector('.surah-search').style.display = 'flex';
    document.getElementById('surah-search-input').value = '';
    
    const container = document.getElementById('surah-list-container');
    
    if (saadCache[tableName]) {
        renderSaadItems(saadCache[tableName]);
    } else {
        container.innerHTML = `
            <div class="loading-spinner">
                <i class="fa-solid fa-spinner fa-spin"></i>
                <span>جاري تحميل الدروس...</span>
            </div>
        `;
        try {
            const data = await fetchSaadTable(tableName);
            saadCache[tableName] = data;
            renderSaadItems(data);
        } catch (err) {
            console.error("Error loading Saad table: ", err);
            container.innerHTML = `<div class="loading-spinner">فشل تحميل البيانات. يرجى التحقق من اتصال الإنترنت.</div>`;
        }
    }
}

async function fetchSaadTable(tableName) {
    let url = `https://api.airtable.com/v0/appAqknF6wbsid5Xu/${encodeURIComponent(tableName)}?pageSize=100`;
    let allRecords = [];
    let offset = '';
    
    do {
        let fetchUrl = url + (offset ? `&offset=${offset}` : '');
        const response = await fetch(fetchUrl, {
            headers: {
                'Authorization': `Bearer patbQBh65alVVwMju.8ca4c598d1db7e728b4224c58b20958ba3c87717e2ec4e1e02d46cce6af09ada`
            }
        });
        if (!response.ok) throw new Error(`HTTP error status: ${response.status}`);
        const data = await response.json();
        if (data.records) {
            allRecords = allRecords.concat(data.records);
        }
        offset = data.offset || '';
    } while (offset);
    
    return allRecords.map(r => r.fields);
}

function renderSaadItems(items) {
    const container = document.getElementById('surah-list-container');
    container.innerHTML = '';
    
    if (!items || items.length === 0) {
        container.innerHTML = `<div class="loading-spinner">لا يوجد دروس حالياً.</div>`;
        return;
    }
    
    items.forEach((item, index) => {
        const row = document.createElement('div');
        row.className = 'surah-item';
        
        const isVideo = activeSaadTable !== 'saad_5otab';
        
        if (isVideo) {
            row.onclick = () => window.open('https://www.youtube.com/watch?v=' + item.video, '_blank');
        } else {
            row.onclick = () => playAudio(selectedReciter, {
                num: String(index + 1).padStart(3, '0'),
                name: item.title,
                url: cleanAudioUrl(item.link)
            });
        }
        
        row.innerHTML = `
            <div class="surah-title-right">
                <span class="surah-index">
                    <i class="fa-solid ${isVideo ? 'fa-play' : 'fa-music'}"></i>
                </span>
                <span>${item.title}</span>
            </div>
            <i class="fa-solid ${isVideo ? 'fa-arrow-up-right-from-square' : 'fa-circle-play'} play-icon-left"></i>
        `;
        container.appendChild(row);
    });
}

// Audio Player System
function playAudio(reciter, track) {
    // Generate Audio Source
    let audioUrl = '';
    
    if (track.url) {
        audioUrl = track.url;
    } else {
        // Check if we have an Airtable URL for this reciter and Surah
        const airtableCol = reciterIdToAirtableColumn[reciter.id];
        if (airtableCol && airtableData[airtableCol] && airtableData[airtableCol][track.num]) {
            audioUrl = airtableData[airtableCol][track.num];
        } else {
            if(reciter.server === 'mock') {
                // Use a beautiful default public adhan/clip for local reciters mock
                audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
            } else {
                // Build correct Mp3Quran URL: server + surahNumber + .mp3 (e.g. server/001.mp3)
                audioUrl = `${reciter.server}${track.num}.mp3`;
            }
        }
    }

    state.currentTrack = {
        name: track.name,
        reciter: reciter.name,
        url: audioUrl
    };

    // Close panel
    closeSurahPanel();

    // Create or Change Audio Object
    if (state.audio) {
        state.audio.pause();
    }
    
    state.audio = new Audio(audioUrl);
    state.audio.play()
        .then(() => {
            state.isPlaying = true;
            updatePlayerUI();
            showAudioPlayer();
        })
        .catch(err => {
            console.error("Audio playback error: ", err);
            alert("خطأ في تشغيل الملف الصوتي، يرجى التحقق من اتصالك بالإنترنت.");
        });

    // Audio playback events
    state.audio.addEventListener('timeupdate', () => {
        if(!state.audio) return;
        const current = state.audio.currentTime;
        const duration = state.audio.duration || 0;
        
        // Progress slider
        const pct = (current / duration) * 100 || 0;
        document.getElementById('player-progress-slider').value = pct;
        
        // Timer Labels
        document.getElementById('player-current-time').innerText = formatSeconds(current);
        document.getElementById('player-total-time').innerText = formatSeconds(duration);
    });

    state.audio.addEventListener('ended', () => {
        if (state.isRepeat) {
            state.audio.currentTime = 0;
            state.audio.play();
        } else {
            state.isPlaying = false;
            updatePlayerUI();
        }
    });
}

function initPlayerEvents() {
    // Enable mini-player seek / hover logic
    const slider = document.getElementById('player-progress-slider');
    slider.addEventListener('change', () => {
        if(state.audio) {
            const time = (slider.value / 100) * state.audio.duration;
            state.audio.currentTime = time;
        }
    });
}

function formatSeconds(sec) {
    let hrs = Math.floor(sec / 3600);
    let min = Math.floor((sec - hrs * 3600) / 60);
    let secs = Math.floor(sec - hrs * 3600 - min * 60);

    hrs = hrs < 10 ? '0' + hrs : hrs;
    min = min < 10 ? '0' + min : min;
    secs = secs < 10 ? '0' + secs : secs;

    return `${hrs}:${min}:${secs}`;
}

function togglePlayPause() {
    if (!state.audio) return;

    if (state.isPlaying) {
        state.audio.pause();
        state.isPlaying = false;
    } else {
        state.audio.play();
        state.isPlaying = true;
    }
    updatePlayerUI();
}

function toggleRepeat() {
    state.isRepeat = !state.isRepeat;
    const btn = document.getElementById('btn-repeat');
    if (state.isRepeat) {
        btn.classList.add('active');
    } else {
        btn.classList.remove('active');
    }
}

function seekAudio(value) {
    if(state.audio && state.audio.duration) {
        state.audio.currentTime = (value / 100) * state.audio.duration;
    }
}

function shareTrack() {
    if(navigator.share && state.currentTrack) {
        navigator.share({
            title: `محراب الحوامدية: استمع إلى ${state.currentTrack.name}`,
            text: `استمع إلى تلاوة مميزة للشيخ ${state.currentTrack.reciter} عبر تطبيق محراب الحوامدية`,
            url: state.currentTrack.url
        }).catch(err => console.log(err));
    } else {
        alert("خاصية المشاركة غير مدعومة في متصفحك الحالي، يمكنك نسخ رابط الملف الصوتي: " + (state.currentTrack ? state.currentTrack.url : ''));
    }
}

function updatePlayerUI() {
    if (!state.currentTrack) return;

    // Full screen player
    document.getElementById('player-reciter').innerText = state.currentTrack.reciter;
    document.getElementById('player-track-name').innerText = state.currentTrack.name;
    
    const playBtn = document.getElementById('btn-play-pause');
    if(state.isPlaying) {
        playBtn.innerHTML = '<i class="fa-solid fa-pause"></i>';
        playBtn.classList.remove('paused');
    } else {
        playBtn.innerHTML = '<i class="fa-solid fa-play"></i>';
        playBtn.classList.add('paused');
    }

    // Mini player
    document.getElementById('mini-track-name').innerText = state.currentTrack.name;
    document.getElementById('mini-reciter-name').innerText = state.currentTrack.reciter;
    
    const miniPlayIcon = document.getElementById('mini-play-icon');
    if(state.isPlaying) {
        miniPlayIcon.className = 'fa-solid fa-pause';
    } else {
        miniPlayIcon.className = 'fa-solid fa-play';
    }

    // Show mini-player
    document.getElementById('mini-player').style.display = 'flex';
}

function showAudioPlayer() {
    document.getElementById('audio-player-overlay').classList.add('active');
}

function hideAudioPlayer() {
    document.getElementById('audio-player-overlay').classList.remove('active');
}

// Azkar System
function switchAzkarType(type) {
    state.currentAzkarType = type;
    
    document.getElementById('azkar-tab-morning').classList.remove('active');
    document.getElementById('azkar-tab-evening').classList.remove('active');
    
    document.getElementById(`azkar-tab-${type}`).classList.add('active');
    
    resetAzkar();
}

function resetAzkar() {
    // Clone original data to modify counters in session
    state.activeAzkar = JSON.parse(JSON.stringify(state.azkarData[state.currentAzkarType]));
    renderAzkar();
}

function renderAzkar() {
    const container = document.getElementById('azkar-list-container');
    container.innerHTML = '';

    state.activeAzkar.forEach(zekr => {
        const card = document.createElement('div');
        card.className = `zekr-card card ${zekr.count === 0 ? 'done' : ''}`;
        card.onclick = () => decrementZekr(zekr.id);

        card.innerHTML = `
            <div class="zekr-content">
                <p class="zekr-text">${zekr.text}</p>
                <span class="zekr-benefit">${zekr.benefit}</span>
            </div>
            <div class="zekr-counter-btn">${zekr.count}</div>
        `;
        container.appendChild(card);
    });
}

function decrementZekr(id) {
    const zekr = state.activeAzkar.find(z => z.id === id);
    if(zekr && zekr.count > 0) {
        zekr.count--;
        
        // Haptic vibe mock
        if(navigator.vibrate) {
            navigator.vibrate(30);
        }
        
        renderAzkar();
    }
}

// Electronic Tasbih
let isDropdownOpen = false;
function toggleTasbihDropdown() {
    isDropdownOpen = !isDropdownOpen;
    const dropdown = document.getElementById('tasbih-dropdown-list');
    dropdown.style.display = isDropdownOpen ? 'block' : 'none';
}

function selectTasbih(text, benefit) {
    document.getElementById('current-tasbih-text').innerText = text;
    document.getElementById('tasbih-benefit-text').innerText = benefit;
    toggleTasbihDropdown();
}

function incrementTasbih() {
    state.tasbihCount++;
    document.getElementById('tasbih-counter').innerText = state.tasbihCount;
    localStorage.setItem('tasbihCount', state.tasbihCount);

    if(navigator.vibrate) {
        navigator.vibrate(40);
    }
}

function resetTasbih() {
    state.tasbihCount = 0;
    document.getElementById('tasbih-counter').innerText = state.tasbihCount;
    localStorage.removeItem('tasbihCount');
}

// Settings Overlay & Theme Controls
let isSettingsOpen = false;
function toggleSettingsPanel() {
    isSettingsOpen = !isSettingsOpen;
    const panel = document.getElementById('settings-panel');
    if(isSettingsOpen) {
        panel.classList.add('active');
    } else {
        panel.classList.remove('active');
    }
}

function setThemeMode(mode) {
    const wrapper = document.querySelector('.phone-wrapper');
    const darkBtn = document.getElementById('theme-btn-dark');
    const lightBtn = document.getElementById('theme-btn-light');

    if (wrapper) {
        if(mode === 'light') {
            wrapper.classList.add('light-mode');
            if (lightBtn && darkBtn) {
                lightBtn.classList.add('active');
                darkBtn.classList.remove('active');
            }
        } else {
            wrapper.classList.remove('light-mode');
            if (lightBtn && darkBtn) {
                darkBtn.classList.add('active');
                lightBtn.classList.remove('active');
            }
        }
    }
    localStorage.setItem('themeMode', mode);
}

// ==========================================
// OFF-LINE WRITTEN QURAN SYSTEM
// ==========================================
const surahTypes = [
    "مكية", "مدنية", "مدنية", "مدنية", "مدنية", "مكية", "مكية", "مدنية", "مدنية", "مكية",
    "مكية", "مكية", "مدنية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مدنية", "مكية", "مدنية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مدنية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مدنية", "مدنية", "مدنية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مدنية", "مكية", "مدنية", "مدنية", "مدنية", "مدنية",
    "مدنية", "مدنية", "مدنية", "مدنية", "مدنية", "مدنية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مدنية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مدنية", "مدنية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مدنية",
    "مكية", "مكية", "مكية", "مكية"
];

function renderQuranTextSurahs(filter = '') {
    const container = document.getElementById('quran-surahs-container');
    if (!container) return;
    container.innerHTML = '';

    surahNames.forEach((name, index) => {
        if (filter && !name.includes(filter)) return;
        
        const surahNum = index + 1;
        const surah = quranTextData.find(s => s.index === surahNum);
        const ayahsCount = surah ? surah.ayahs.length : 0;
        const type = surahTypes[index];
        
        const row = document.createElement('div');
        row.className = 'surah-item';
        row.onclick = () => showQuranReader(surahNum);
        
        row.innerHTML = `
            <div class="surah-title-right">
                <span class="surah-index">${surahNum}</span>
                <div>
                    <span style="font-weight: bold; display: block; color: var(--text-color);">${name}</span>
                    <span style="font-size: 11px; color: var(--gold-color);">${type} • ${ayahsCount} آية</span>
                </div>
            </div>
            <i class="fa-solid fa-book-open play-icon-left"></i>
        `;
        container.appendChild(row);
    });
}

function searchQuranTextSurah() {
    const query = document.getElementById('quran-search-input').value.trim();
    renderQuranTextSurahs(query);
}

function showQuranReader(surahIndex) {
    const surah = quranTextData.find(s => s.index === surahIndex);
    if (!surah) return;

    currentReadingSurahIndex = surahIndex;
    isExplicitlyUnsaved = false;

    const type = surahTypes[surahIndex - 1];
    const ayahsCount = surah.ayahs.length;
    document.getElementById('quran-reader-title').innerText = `سورة ${surah.name} (${type} • ${ayahsCount} آية)`;
    
    // Manage bookmark button visual state
    const savedIndex = localStorage.getItem('quranLastReadSurahIndex');
    const bookmarkBtn = document.getElementById('btn-save-bookmark');
    if (bookmarkBtn) {
        if (savedIndex && parseInt(savedIndex) === surahIndex) {
            bookmarkBtn.classList.add('saved');
            bookmarkBtn.innerHTML = '<i class="fa-solid fa-bookmark"></i>';
        } else {
            bookmarkBtn.classList.remove('saved');
            bookmarkBtn.innerHTML = '<i class="fa-regular fa-bookmark"></i>';
        }
    }
    
    const body = document.getElementById('quran-reader-body');
    body.innerHTML = '';
    
    // Add Basmala if it's not Surah Al-Tawbah (9)
    if (surahIndex !== 9) {
        body.innerHTML += `<div class="bismillah-text">بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ</div>`;
    }
    
    let paragraphHTML = '<p>';
    surah.ayahs.forEach(ayah => {
        let text = ayah.text;
        if (surahIndex !== 1 && ayah.num === 1) {
            text = text.replace(/^بِسْمِ\s+اللَّهِ\s+الرَّحْمَٰنِ\s+الرَّحِيمِ\s*/, '');
            text = text.replace(/^بِسْمِ\s+اللهِ\s+الرَّحٰمنِ\s+الرَّحِيْمِ\s*/, '');
        }
        paragraphHTML += `<span class="ayah-text">${text}</span><span class="ayah-num">${ayah.num}</span> `;
    });
    paragraphHTML += '</p>';
    
    body.innerHTML += paragraphHTML;
    
    document.getElementById('quran-reader-panel').classList.add('active');
}

function closeQuranReader() {
    // Save position silently on close!
    saveLastReadPosition(false);

    // Set reading index to null immediately so subsequent programmatic scroll events do not save
    currentReadingSurahIndex = null;

    if (isScrolling) {
        toggleAutoScroll(); // stop it
    }
    // reset scroll speed input visual slider to default
    document.getElementById('scroll-speed-input').value = 3;
    scrollSpeed = 3;

    // Scroll reader view back to top
    const readerBody = document.getElementById('quran-reader-body');
    if (readerBody) readerBody.scrollTop = 0;

    document.getElementById('quran-reader-panel').classList.remove('active');
    document.getElementById('quran-search-input').value = '';
    renderQuranTextSurahs();
}

// Auto Scroll System variables & functions
let scrollInterval = null;
let isScrolling = false;
let scrollSpeed = 3;

function toggleAutoScroll() {
    const container = document.getElementById('quran-reader-body');
    const btn = document.getElementById('btn-auto-scroll');
    if (!container || !btn) return;
    
    if (isScrolling) {
        // Stop scroll
        clearInterval(scrollInterval);
        scrollInterval = null;
        isScrolling = false;
        btn.innerHTML = '<i class="fa-solid fa-play"></i> <span>التمرير التلقائي</span>';
        btn.classList.remove('scrolling-active');
    } else {
        // Start scroll
        isScrolling = true;
        btn.innerHTML = '<i class="fa-solid fa-pause"></i> <span>إيقاف التمرير</span>';
        btn.classList.add('scrolling-active');
        
        startScrollingLoop(container);
    }
}

function startScrollingLoop(container) {
    if (scrollInterval) clearInterval(scrollInterval);
    
    scrollInterval = setInterval(() => {
        if (!isScrolling || !container) return;
        
        // Scroll down fractionally for smoother movement
        container.scrollTop += (scrollSpeed * 0.35);
        
        // If reached bottom, stop auto scroll
        if (container.scrollTop + container.clientHeight >= container.scrollHeight - 2) {
            toggleAutoScroll();
        }
    }, 30);
}

function updateScrollSpeed() {
    const input = document.getElementById('scroll-speed-input');
    if (!input) return;
    scrollSpeed = parseInt(input.value);
    
    if (isScrolling) {
        const container = document.getElementById('quran-reader-body');
        if (container) startScrollingLoop(container);
    }
}

// Written Quran Bookmarking and Resume System
let currentReadingSurahIndex = null;
let saveScrollTimeout = null;
let isExplicitlyUnsaved = false;

function handleQuranScroll() {
    if (!currentReadingSurahIndex || isExplicitlyUnsaved) return;
    
    if (saveScrollTimeout) clearTimeout(saveScrollTimeout);
    
    // Save position 300ms after scroll events stop to avoid high-frequency writing
    saveScrollTimeout = setTimeout(() => {
        if (currentReadingSurahIndex && !isExplicitlyUnsaved) {
            saveLastReadPosition(false); // silently save on scroll
        }
    }, 300);
}

function getCurrentVisibleAyah() {
    const container = document.getElementById('quran-reader-body');
    if (!container) return 1;
    
    const ayahElements = container.querySelectorAll('.ayah-text');
    if (!ayahElements || ayahElements.length === 0) return 1;
    
    const containerRect = container.getBoundingClientRect();
    const containerTop = containerRect.top;
    
    let closestAyahNum = 1;
    
    for (let i = 0; i < ayahElements.length; i++) {
        const el = ayahElements[i];
        const rect = el.getBoundingClientRect();
        
        // The first ayah whose bottom is below the container top is the visible one at the top of viewport
        if (rect.bottom >= containerTop + 10) {
            const numSpan = el.nextElementSibling;
            if (numSpan && numSpan.classList.contains('ayah-num')) {
                const parsed = parseInt(numSpan.innerText);
                if (!isNaN(parsed)) {
                    closestAyahNum = parsed;
                    break; // Found the top visible ayah, stop searching
                }
            }
        }
    }
    return closestAyahNum;
}

function saveLastReadPosition(showAlert = false) {
    if (!currentReadingSurahIndex) return;
    if (isExplicitlyUnsaved && !showAlert) return; // Don't auto-save if user explicitly unsaved

    const container = document.getElementById('quran-reader-body');
    const offset = container ? container.scrollTop : 0;
    
    const activeAyah = getCurrentVisibleAyah();
    
    localStorage.setItem('quranLastReadSurahIndex', currentReadingSurahIndex);
    localStorage.setItem('quranLastReadScrollOffset', offset);
    localStorage.setItem('quranLastReadAyahNum', activeAyah);
    
    const surahName = surahNames[currentReadingSurahIndex - 1];
    localStorage.setItem('quranLastReadSurahName', surahName);
    
    // Update Bookmark Button UI
    const bookmarkBtn = document.getElementById('btn-save-bookmark');
    if (bookmarkBtn) {
        bookmarkBtn.classList.add('saved');
        bookmarkBtn.innerHTML = '<i class="fa-solid fa-bookmark"></i>';
    }
    
    // Refresh the last read quick link card
    checkLastReadBookmark();
    if (showAlert) {
        alert(`تم حفظ علامة موضع القراءة بنجاح في سورة ${surahName} - الآية ${activeAyah}`);
    }
}

function toggleLastReadPosition() {
    if (!currentReadingSurahIndex) return;
    const savedIndex = localStorage.getItem('quranLastReadSurahIndex');
    const isBookmarked = savedIndex && parseInt(savedIndex) === currentReadingSurahIndex;
    
    if (isBookmarked) {
        // Unsave
        isExplicitlyUnsaved = true;
        localStorage.removeItem('quranLastReadSurahIndex');
        localStorage.removeItem('quranLastReadScrollOffset');
        localStorage.removeItem('quranLastReadSurahName');
        localStorage.removeItem('quranLastReadAyahNum');
        
        const bookmarkBtn = document.getElementById('btn-save-bookmark');
        if (bookmarkBtn) {
            bookmarkBtn.classList.remove('saved');
            bookmarkBtn.innerHTML = '<i class="fa-regular fa-bookmark"></i>';
        }
        checkLastReadBookmark();
        alert('تم إزالة علامة القراءة.');
    } else {
        // Save
        isExplicitlyUnsaved = false;
        saveLastReadPosition(true);
    }
}

function deleteLastReadBookmark() {
    localStorage.removeItem('quranLastReadSurahIndex');
    localStorage.removeItem('quranLastReadScrollOffset');
    localStorage.removeItem('quranLastReadSurahName');
    localStorage.removeItem('quranLastReadAyahNum');
    checkLastReadBookmark();
    alert('تم مسح موضع القراءة بنجاح.');
}

function checkLastReadBookmark() {
    const savedIndex = localStorage.getItem('quranLastReadSurahIndex');
    const savedName = localStorage.getItem('quranLastReadSurahName');
    const savedAyah = localStorage.getItem('quranLastReadAyahNum') || '1';
    
    const card = document.getElementById('quran-last-read-card');
    const text = document.getElementById('quran-last-read-text');
    
    if (card && text) {
        if (savedIndex && savedName) {
            text.innerText = `سورة ${savedName} - الآية ${savedAyah}`;
            card.style.display = 'flex';
        } else {
            card.style.display = 'none';
        }
    }
}

function goToLastRead() {
    const savedIndex = localStorage.getItem('quranLastReadSurahIndex');
    const savedOffset = localStorage.getItem('quranLastReadScrollOffset');
    if (!savedIndex) return;
    
    const idx = parseInt(savedIndex);
    const offset = parseFloat(savedOffset || '0');
    
    // Open the reader
    showQuranReader(idx);
    
    // Smoothly scroll to the saved offset after content layout renders
    setTimeout(() => {
        const container = document.getElementById('quran-reader-body');
        if (container) {
            container.scrollTop = offset;
        }
    }, 200);
}

// Web Adhan Notification Variables & Functions
let webAdhanAudio = null;
let lastTriggeredPrayerDate = '';
let lastTriggeredPrayerName = '';

function checkPrayerTimesForNotifications() {
    const isEnabled = localStorage.getItem('webAdhanNotificationsEnabled') === 'true';
    if (!isEnabled) return;

    const date = new Date();
    const lat = 29.8967;
    const lng = 31.2631;
    const timezone = -date.getTimezoneOffset() / 60; 

    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    
    let a = Math.floor((14 - month) / 12);
    let y = year + 4800 - a;
    let m = month + 12 * a - 3;
    let jd = day + Math.floor((153 * m + 2) / 5) + 365 * y + Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400) - 32045;

    let d = jd - 2451545.0;
    let g = (357.529 + 0.98560028 * d) % 360;
    let q = (280.459 + 0.98564736 * d) % 360;
    let L = (q + 1.915 * Math.sin(rad(g)) + 0.020 * Math.sin(rad(2 * g))) % 360;
    
    let e = 23.439 - 0.00000036 * d;
    let DD = deg(Math.asin(Math.sin(rad(e)) * Math.sin(rad(L))));
    let RA = deg(Math.atan2(Math.cos(rad(e)) * Math.sin(rad(L)), Math.cos(rad(L)))) / 15;
    RA = (RA + 24) % 24;
    let EqT = q/15 - RA;

    let noon = (12 + timezone - lng / 15 - EqT + 24) % 24;
    let U_fajr = solarAngle(lat, DD, -19.5);
    let fajr = noon - U_fajr / 15;
    let U_isha = solarAngle(lat, DD, -17.5);
    let isha = noon + U_isha / 15;
    let g_asr = deg(Math.atan(1 + Math.tan(rad(Math.abs(lat - DD)))));
    let U_asr = solarAngle(lat, DD, 90 - g_asr);
    let asr = noon + U_asr / 15;
    let U_sunrise = solarAngle(lat, DD, -0.833);
    let sunset = noon + U_sunrise / 15;

    const prayers = [
        { name: 'الفجر', val: fajr },
        { name: 'الظهر', val: noon },
        { name: 'العصر', val: asr },
        { name: 'المغرب', val: sunset },
        { name: 'العشاء', val: isha }
    ];

    const todayStr = date.toDateString();
    const currHour = date.getHours();
    const currMin = date.getMinutes();

    prayers.forEach(p => {
        let h = Math.floor(p.val);
        let min = Math.floor((p.val - h) * 60);

        if (currHour === h && currMin === min) {
            if (lastTriggeredPrayerDate !== todayStr || lastTriggeredPrayerName !== p.name) {
                lastTriggeredPrayerDate = todayStr;
                lastTriggeredPrayerName = p.name;
                triggerWebAdhanNotification(p.name);
            }
        }
    });
}

function triggerWebAdhanNotification(prayerName) {
    if (Notification.permission === 'granted') {
        new Notification(`حان الآن موعد أذان ${prayerName}`, {
            body: `صلاة ${prayerName} في مدينة الحوامدية وضواحيها`,
            icon: 'images/logo.png'
        });
    }

    if (webAdhanAudio) {
        webAdhanAudio.pause();
        webAdhanAudio = null;
    }

    webAdhanAudio = new Audio('https://www.islamcan.com/audio/adhan/makkah.mp3');
    webAdhanAudio.play().catch(err => {
        console.log("Autoplay blocked by browser. Interaction required: ", err);
    });
}

function toggleWebNotifications(checked) {
    localStorage.setItem('webAdhanNotificationsEnabled', checked ? 'true' : 'false');
    
    if (checked) {
        if ('Notification' in window) {
            Notification.requestPermission().then(permission => {
                if (permission !== 'granted') {
                    alert('لتشغيل التنبيهات، يرجى تفعيل إذن الإشعارات من إعدادات المتصفح.');
                    document.getElementById('web-notifications-switch').checked = false;
                    localStorage.setItem('webAdhanNotificationsEnabled', 'false');
                } else {
                    alert('تم تفعيل تنبيهات الأذان بنجاح. سيتم تشغيل الأذان عند دخول وقت الصلاة طالما أن هذه الصفحة مفتوحة.');
                }
            });
        } else {
            alert('متصفحك لا يدعم إشعارات الويب.');
            document.getElementById('web-notifications-switch').checked = false;
            localStorage.setItem('webAdhanNotificationsEnabled', 'false');
        }
    } else {
        if (webAdhanAudio) {
            webAdhanAudio.pause();
            webAdhanAudio = null;
        }
        alert('تم إلغاء تفعيل تنبيهات الأذان.');
    }
}

// Standalone Page for Dr. Saad Hamouda
function renderSaadStandaloneCategories() {
    activeSaadTable = null;
    activeSaadTitle = '';
    
    document.getElementById('saad-title-header').innerText = "د. سعد حمودة - الأقسام";
    document.getElementById('saad-search-box').style.display = 'none';
    
    const container = document.getElementById('saad-content-container');
    container.innerHTML = `
        <div class="saad-categories-grid">
            <div class="saad-category-card" onclick="openSaadStandaloneCategory('saad_nahw', 'دروس النحو')">
                <div class="category-icon-wrapper"><i class="fa-solid fa-book-open"></i></div>
                <div class="category-info">
                    <h4>دروس النحو</h4>
                    <p>شرح كتاب قواعد اللغة العربية والنحو بالتفصيل</p>
                </div>
                <i class="fa-solid fa-chevron-left category-arrow"></i>
            </div>
            
            <div class="saad-category-card" onclick="openSaadStandaloneCategory('saad_videos_YouTube', 'فيديوهات متنوعة')">
                <div class="category-icon-wrapper"><i class="fa-solid fa-video"></i></div>
                <div class="category-info">
                    <h4>فيديوهات متنوعة</h4>
                    <p>دروس يوتيوب دينية وفتاوى علمية متنوعة</p>
                </div>
                <i class="fa-solid fa-chevron-left category-arrow"></i>
            </div>
            
            <div class="saad-category-card" onclick="openSaadStandaloneCategory('saad_5otab', 'خطب صوتية')">
                <div class="category-icon-wrapper"><i class="fa-solid fa-microphone"></i></div>
                <div class="category-info">
                    <h4>خطب صوتية</h4>
                    <p>خطب الجمعة والمحاضرات الصوتية بصوت الشيخ</p>
                </div>
                <i class="fa-solid fa-chevron-left category-arrow"></i>
            </div>
        </div>
    `;
}

async function openSaadStandaloneCategory(tableName, categoryTitle) {
    activeSaadTable = tableName;
    activeSaadTitle = categoryTitle;
    
    document.getElementById('saad-title-header').innerHTML = `
        <span class="back-btn-saad" onclick="renderSaadStandaloneCategories()"><i class="fa-solid fa-arrow-right"></i></span>
        <span>${categoryTitle}</span>
    `;
    
    document.getElementById('saad-search-box').style.display = 'flex';
    document.getElementById('saad-search-input').value = '';
    
    const container = document.getElementById('saad-content-container');
    
    if (saadCache[tableName]) {
        renderSaadStandaloneItems(saadCache[tableName]);
    } else {
        container.innerHTML = `
            <div class="loading-spinner">
                <i class="fa-solid fa-spinner fa-spin"></i>
                <span>جاري تحميل الدروس...</span>
            </div>
        `;
        try {
            const data = await fetchSaadTable(tableName);
            saadCache[tableName] = data;
            renderSaadStandaloneItems(data);
        } catch (err) {
            console.error("Error loading Saad table: ", err);
            container.innerHTML = `<div class="loading-spinner">فشل تحميل البيانات. يرجى التحقق من اتصال الإنترنت.</div>`;
        }
    }
}

function renderSaadStandaloneItems(items) {
    const container = document.getElementById('saad-content-container');
    container.innerHTML = '';
    
    if (!items || items.length === 0) {
        container.innerHTML = `<div class="loading-spinner">لا يوجد دروس حالياً.</div>`;
        return;
    }
    
    items.forEach((item, index) => {
        const row = document.createElement('div');
        row.className = 'surah-item';
        
        const isVideo = activeSaadTable !== 'saad_5otab';
        
        if (isVideo) {
            row.onclick = () => playYoutubeVideo(item.video, item.title);
        } else {
            row.onclick = () => playAudio(saadReciterObject, {
                num: String(index + 1).padStart(3, '0'),
                name: item.title,
                url: cleanAudioUrl(item.link)
            });
        }
        
        row.innerHTML = `
            <div class="surah-title-right">
                <span class="surah-index">
                    <i class="fa-solid ${isVideo ? 'fa-play' : 'fa-music'}"></i>
                </span>
                <span>${item.title}</span>
            </div>
            <i class="fa-solid ${isVideo ? 'fa-video' : 'fa-circle-play'} play-icon-left" style="${isVideo ? 'color: var(--secondary-color);' : ''}"></i>
        `;
        container.appendChild(row);
    });
}

function searchSaadItems() {
    const query = document.getElementById('saad-search-input').value.trim().toLowerCase();
    if (activeSaadTable) {
        const items = saadCache[activeSaadTable] || [];
        const filtered = items.filter(item => (item.title || '').toLowerCase().includes(query));
        renderSaadStandaloneItems(filtered);
    }
}

// In-app YouTube Player Controls
function playYoutubeVideo(videoId, videoTitle) {
    const modal = document.getElementById('youtube-player-modal');
    const titleEl = document.getElementById('youtube-video-title');
    const iframe = document.getElementById('youtube-iframe');
    
    if (modal && iframe) {
        titleEl.innerText = videoTitle;
        iframe.src = `https://www.youtube.com/embed/${videoId}?autoplay=1&enablejsapi=1&origin=${window.location.origin}`;
        modal.classList.add('active');
        
        // Pause any currently playing app audio sermon/surah
        if (state.audio) {
            state.audio.pause();
            state.isPlaying = false;
            updatePlayPauseUI();
        }
    }
}

function closeYoutubePlayer() {
    const modal = document.getElementById('youtube-player-modal');
    const iframe = document.getElementById('youtube-iframe');
    
    if (modal && iframe) {
        iframe.src = '';
        modal.classList.remove('active');
    }
}
