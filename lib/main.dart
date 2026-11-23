import 'package:flutter/material.dart';

void main() => runApp(const CepteFirsatApp());

const demoLabel = 'DEMO VERİSİ';

class MarketProduct {
  final int id;
  final String name;
  final String category;
  final String emoji;
  final String unit;
  final List<double> prices;

  const MarketProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.unit,
    required this.prices,
  });

  double get lowestPrice => prices.reduce((a, b) => a < b ? a : b);
  int get cheapestMarket => prices.indexOf(lowestPrice);
}

const markets = ['BİM', 'A101', 'ŞOK', 'Migros'];

const demoProducts = <MarketProduct>[
  MarketProduct(id: 1, name: 'Tam yağlı süt', category: 'Süt ürünleri', emoji: '🥛', unit: '1 L', prices: [34.90, 36.50, 35.90, 39.90]),
  MarketProduct(id: 2, name: 'Ayçiçek yağı', category: 'Temel gıda', emoji: '🫗', unit: '1 L', prices: [59.90, 62.90, 61.50, 65.90]),
  MarketProduct(id: 3, name: 'Baldo pirinç', category: 'Temel gıda', emoji: '🍚', unit: '1 kg', prices: [49.90, 47.90, 52.50, 54.90]),
  MarketProduct(id: 4, name: 'Bulaşık deterjanı', category: 'Temizlik', emoji: '🧽', unit: '750 ml', prices: [44.90, 42.50, 46.90, 49.90]),
  MarketProduct(id: 5, name: 'Yumurta', category: 'Temel gıda', emoji: '🥚', unit: '15 adet', prices: [79.90, 82.50, 77.90, 85.90]),
  MarketProduct(id: 6, name: 'Makarna', category: 'Temel gıda', emoji: '🍝', unit: '500 g', prices: [17.50, 16.90, 18.25, 19.90]),
  MarketProduct(id: 7, name: 'Yoğurt', category: 'Süt ürünleri', emoji: '🥣', unit: '1,5 kg', prices: [59.90, 62.50, 58.90, 67.90]),
  MarketProduct(id: 8, name: 'Tuvalet kâğıdı', category: 'Temizlik', emoji: '🧻', unit: '16 rulo', prices: [99.90, 104.90, 96.90, 119.90]),
  MarketProduct(id: 9, name: 'Türk kahvesi', category: 'İçecek', emoji: '☕', unit: '100 g', prices: [39.90, 42.90, 41.50, 45.90]),
  MarketProduct(id: 10, name: 'Bisküvi', category: 'Atıştırmalık', emoji: '🍪', unit: '300 g', prices: [24.90, 22.50, 23.90, 27.90]),
];

const specialLists = <String, List<int>>{
  'Glutensiz ürünler': [3],
  'Türk malı ürünler': [9],
  'Katkı maddesi içermeyen ürünler': [],
  'Şekersiz ürünler': [],
  'Vegan ürünler': [2, 3],
  'Organik ürünler': [],
  'Laktozsuz ürünler': [],
  'Helal ürünler': [],
  'Yerli üretici ürünleri': [9],
  'İndirimdeki sağlıklı ürünler': [3],
};

String money(double value) => '${value.toStringAsFixed(2).replaceAll('.', ',')} ₺';

class CepteFirsatApp extends StatelessWidget {
  const CepteFirsatApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16845B);
    return MaterialApp(
      title: 'Cepte Fırsat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF6F8F6), elevation: 0),
        cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  final Set<int> cart = {};
  final Set<int> favorites = {};
  final Set<int> alerts = {};
  String selectedMarket = 'Tümü';
  String query = '';
  String? selectedSpecialList;

  List<MarketProduct> get filtered => demoProducts.where((p) {
    final matchesQuery = p.name.toLowerCase().contains(query.toLowerCase()) || p.category.toLowerCase().contains(query.toLowerCase());
    final matchesMarket = selectedMarket == 'Tümü' || p.cheapestMarket == markets.indexOf(selectedMarket);
    return matchesQuery && matchesMarket;
  }).toList();

  void addToCart(MarketProduct p) {
    setState(() => cart.add(p.id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} sepete eklendi'), duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Cepte Fırsat', 'Broşürler', 'Karşılaştır', 'Sepetim', 'Özel listeler', 'Profil'];
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Icon(Icons.shopping_basket_rounded, color: Color(0xFF16845B)),
          const SizedBox(width: 8),
          Text(titles[tab], style: const TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFFFE9B8), borderRadius: BorderRadius.circular(20)),
              child: const Text('DEMO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Color(0xFF805500))),
            )),
          )
        ],
      ),
      body: IndexedStack(index: tab, children: [
        _homeTab(),
        _brochureTab(),
        _compareTab(),
        _cartTab(),
        _profileTab(),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana sayfa'),
          const NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Broşürler'),
          const NavigationDestination(icon: Icon(Icons.compare_arrows), label: 'Karşılaştır'),
          NavigationDestination(icon: Badge(label: Text('${cart.length}'), isLabelVisible: cart.isNotEmpty, child: const Icon(Icons.shopping_cart_outlined)), label: 'Sepet'),
          const NavigationDestination(icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), label: 'Özel listeler'),
          const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _hero() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF126D4B), Color(0xFF28A875)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(22),
    ),
    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('DAHA UCUZA ALIŞVERİŞ YAP', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
      SizedBox(height: 8),
      Text('Fırsatları karşılaştır,\nbütçeni koru.', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900, height: 1.15)),
      SizedBox(height: 8),
      Text('BİM · A101 · ŞOK · Migros', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _homeTab() => ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 20), children: [
    _hero(),
    const SizedBox(height: 18),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Bu haftanın fırsatları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      TextButton(onPressed: () => setState(() => tab = 2), child: const Text('Tümünü gör')),
    ]),
    _marketChips(),
    const SizedBox(height: 8),
    ...demoProducts.take(5).map(_productCard),
    const SizedBox(height: 12),
    _demoNotice(),
  ]);

  Widget _marketChips() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: ['Tümü', ...markets].map((m) => Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(label: Text(m), selected: selectedMarket == m, onSelected: (_) => setState(() => selectedMarket = m)),
    )).toList()),
  );

  Widget _productCard(MarketProduct p) {
    final isFav = favorites.contains(p.id);
    final isInCart = cart.contains(p.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(width: 54, height: 54, decoration: BoxDecoration(color: const Color(0xFFF0F5F1), borderRadius: BorderRadius.circular(14)), child: Center(child: Text(p.emoji, style: const TextStyle(fontSize: 27)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text('${p.unit} · En uygun: ${markets[p.cheapestMarket]}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(money(p.lowestPrice), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF16845B), fontSize: 16)),
          ])),
          Column(children: [
            IconButton(visualDensity: VisualDensity.compact, onPressed: () => setState(() => isFav ? favorites.remove(p.id) : favorites.add(p.id)), icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null)),
            IconButton(visualDensity: VisualDensity.compact, onPressed: () => addToCart(p), icon: Icon(isInCart ? Icons.check_circle : Icons.add_shopping_cart, color: const Color(0xFF16845B))),
          ]),
        ]),
      ),
    );
  }

  Widget _brochureTab() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Market broşürleri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 6),
    const Text('Örnek katalog kapakları. Gerçek broşürler sonraki aşamada eklenecek.', style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 16),
    ...[
      ('BİM', 'Haftanın yıldızları', '🟡'),
      ('A101', 'Aldın Aldın fırsatları', '🔵'),
      ('ŞOK', 'Haftanın fırsatları', '🔴'),
      ('Migros', 'İndirim kataloğu', '🟠'),
    ].map((x) => Card(child: ListTile(
      contentPadding: const EdgeInsets.all(14),
      leading: CircleAvatar(radius: 25, backgroundColor: const Color(0xFFF1F4F1), child: Text(x.$3, style: const TextStyle(fontSize: 23))),
      title: Text(x.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text('${x.$2} · Demo katalog'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showDialog(context: context, builder: (_) => AlertDialog(title: Text('${x.$1} broşürü'), content: const Text('Bu alan örnek katalog içindir. Gerçek broşür içeriği ve kullanım izinleri sonraki aşamada eklenecek.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat'))])),
    ))),
    _demoNotice(),
  ]);

  Widget _compareTab() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Ürün karşılaştırma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 10),
    TextField(decoration: InputDecoration(hintText: 'Ürün veya kategori ara', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)), onChanged: (v) => setState(() => query = v)),
    const SizedBox(height: 10),
    ...filtered.map((p) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Text(p.emoji, style: const TextStyle(fontSize: 25)), const SizedBox(width: 9), Expanded(child: Text('${p.name} (${p.unit})', style: const TextStyle(fontWeight: FontWeight.w800))) ]),
      const SizedBox(height: 10),
      ...List.generate(4, (i) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
        Expanded(child: Text(markets[i], style: TextStyle(fontWeight: i == p.cheapestMarket ? FontWeight.w900 : FontWeight.normal))),
        if (i == p.cheapestMarket) const Text('EN UYGUN  ', style: TextStyle(color: Color(0xFF16845B), fontSize: 10, fontWeight: FontWeight.w900)),
        Text(money(p.prices[i]), style: TextStyle(fontWeight: i == p.cheapestMarket ? FontWeight.w900 : FontWeight.w500, color: i == p.cheapestMarket ? const Color(0xFF16845B) : null)),
      ]))),
      Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () => addToCart(p), icon: const Icon(Icons.add_shopping_cart), label: const Text('Sepete ekle'))),
    ])))),
    if (filtered.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('Aramana uygun ürün bulunamadı.')),
    _demoNotice(),
  ]);

  Widget _cartTab() {
    final selected = demoProducts.where((p) => cart.contains(p.id)).toList();
    final totals = List.generate(4, (i) => selected.fold<double>(0, (sum, p) => sum + p.prices[i]));
    final best = selected.isEmpty ? -1 : totals.indexOf(totals.reduce((a, b) => a < b ? a : b));
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Alışveriş sepetim', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      if (selected.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Sepetin henüz boş.\nÜrün karşılaştırma ekranından ürün ekleyebilirsin.', textAlign: TextAlign.center))))
      else ...selected.map((p) => Card(child: ListTile(leading: Text(p.emoji, style: const TextStyle(fontSize: 24)), title: Text(p.name), subtitle: Text('En düşük: ${money(p.lowestPrice)}'), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => cart.remove(p.id)))))),
      if (selected.isNotEmpty) ...[
        const SizedBox(height: 12),
        const Text('Marketlere göre toplam', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
        const SizedBox(height: 8),
        ...List.generate(4, (i) => Card(child: ListTile(
          leading: CircleAvatar(child: Text(markets[i][0])),
          title: Text(markets[i], style: TextStyle(fontWeight: i == best ? FontWeight.w900 : FontWeight.normal)),
          subtitle: i == best ? const Text('Bu örnek sepette en düşük toplam', style: TextStyle(color: Color(0xFF16845B))) : null,
          trailing: Text(money(totals[i]), style: TextStyle(fontWeight: FontWeight.w900, color: i == best ? const Color(0xFF16845B) : null)),
        ))),
      ],
      _demoNotice(),
    ]);
  }

  Widget _specialListsTab() {
    final names = specialLists.keys.toList();
    if (selectedSpecialList != null) {
      final ids = specialLists[selectedSpecialList]!;
      final products = demoProducts.where((p) => ids.contains(p.id)).toList();
      return ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          IconButton(onPressed: () => setState(() => selectedSpecialList = null), icon: const Icon(Icons.arrow_back)),
          Expanded(child: Text(selectedSpecialList!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
        ]),
        const Text('Bu kategoriye eklenen örnek ürünler', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 12),
        if (products.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('Bu listede henüz örnek ürün yok. Gerçek ürünler, içerik ve etiket bilgileri doğrulandıktan sonra eklenecek.')))
        else ...products.map(_productCard),
        _demoNotice(),
      ]);
    }

    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Özel ürün listeleri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 6),
      const Text('İlgilendiğin ürün türünü seç. Bir ürün birden fazla özel listede yer alabilir.', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 14),
      ...names.map((name) {
        final count = specialLists[name]!.length;
        final icon = name.contains('Glutensiz') ? Icons.grain
          : name.contains('Türk malı') || name.contains('Yerli') ? Icons.flag_outlined
          : name.contains('Katkı') ? Icons.no_food_outlined
          : name.contains('Şekersiz') ? Icons.cake_outlined
          : name.contains('Vegan') ? Icons.eco_outlined
          : name.contains('Organik') || name.contains('sağlıklı') ? Icons.spa_outlined
          : name.contains('Laktozsuz') ? Icons.water_drop_outlined
          : Icons.verified_outlined;
        return Card(child: ListTile(
          leading: CircleAvatar(backgroundColor: const Color(0xFFEAF4ED), child: Icon(icon, color: const Color(0xFF16845B))),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('$count demo ürün'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => setState(() => selectedSpecialList = name),
        ));
      }),
      const SizedBox(height: 4),
      const Card(child: Padding(
        padding: EdgeInsets.all(14),
        child: Text('Önemli: Glutensiz, şekersiz, vegan, organik, laktozsuz, helal ve katkısız gibi özellikler yalnızca güvenilir ambalaj/içerik veya sertifika bilgisiyle doğrulanmalıdır. “Türk malı” ile “Türkiye’de üretilmiş” aynı anlama gelmeyebilir; bu bilgiler ayrı tutulacaktır.', style: TextStyle(fontSize: 12, height: 1.4)),
      )),
      _demoNotice(),
    ]);
  }

  Widget _profileTab() => ListView(padding: const EdgeInsets.all(16), children: [
    const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 36)),
    const SizedBox(height: 10),
    const Center(child: Text('Misafir kullanıcı', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900))),
    const Center(child: Text('Cepte Fırsat hesabın', style: TextStyle(color: Colors.black54))),
    const SizedBox(height: 18),
    Card(child: Column(children: [
      ListTile(leading: const Icon(Icons.favorite_outline), title: const Text('Favorilerim'), trailing: Text('${favorites.length} ürün'), onTap: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Favorilerim'), content: Text(favorites.isEmpty ? 'Henüz favori ürün eklemedin.' : demoProducts.where((p) => favorites.contains(p.id)).map((p) => p.name).join('\\n')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat'))]))),
      const Divider(height: 1),
      ListTile(leading: const Icon(Icons.notifications_active_outlined), title: const Text('Fiyat alarmlarım'), trailing: Text('${alerts.length} alarm'), onTap: _showAlertDialog),
      const Divider(height: 1),
      ListTile(leading: const Icon(Icons.workspace_premium_outlined), title: const Text('Premium üyelik'), subtitle: const Text('Daha fazla özellik'), trailing: const Icon(Icons.chevron_right), onTap: _showPremium),
      const Divider(height: 1),
      const ListTile(leading: Icon(Icons.info_outline), title: Text('Uygulama hakkında'), subtitle: Text('Sürüm 1.0 · Demo')),
    ])),
    _demoNotice(),
  ]);

  void _showAlertDialog() {
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, refresh) => AlertDialog(
      title: const Text('Fiyat alarmı oluştur'),
      content: SizedBox(width: 320, child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Bir ürün seç. Demo sürümünde alarm yalnızca cihaz içinde örnek olarak kaydedilir.'),
        const SizedBox(height: 12),
        ...demoProducts.take(5).map((p) => CheckboxListTile(dense: true, contentPadding: EdgeInsets.zero, title: Text(p.name), value: alerts.contains(p.id), onChanged: (v) { setState(() => v == true ? alerts.add(p.id) : alerts.remove(p.id)); refresh(() {}); })),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tamam'))],
    )));
  }

  void _showPremium() {
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Cepte Fırsat Premium', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('Örnek üyelik ekranı · Ödeme henüz aktif değil.'),
        const SizedBox(height: 12),
        const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.notifications_active), title: Text('Sınırsız fiyat alarmı')),
        const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.history), title: Text('Fiyat geçmişi')),
        const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.shopping_basket), title: Text('Gelişmiş sepet analizi')),
        const SizedBox(height: 8),
        const Text('Örnek fiyat: 39,90 TL / ay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF16845B))),
      ]),
    ));
  }

  Widget _demoNotice() => Container(
    margin: const EdgeInsets.only(top: 12, bottom: 18),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFFFFF3D8), borderRadius: BorderRadius.circular(13)),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.info_outline, color: Color(0xFF8B5A00)),
      SizedBox(width: 8),
      Expanded(child: Text('Bu sürümdeki tüm market, ürün, broşür ve fiyat bilgileri örnektir. Gerçek kampanya veya satış fiyatı değildir.', style: TextStyle(fontSize: 12, color: Color(0xFF704900)))),
    ]),
  );
}
