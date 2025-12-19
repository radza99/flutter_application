import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ตู้ปลูกผักอัจฉริยะ',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        fontFamily: 'Sarabun',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// หน้าแรก (Dashboard)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double ph = 6.5;
  double ec = 1.2;
  double temp = 26.0;
  double tds = 780.0;

  Color getStatusColor(double value, double min, double max) {
    if (value < min) return Colors.red;
    if (value > max) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[900]!, Colors.green[600]!, Colors.green[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://nutraponics.com/wp-content/uploads/2023/12/eb537391-b4d2-407d-9647-ff159333f17b.png',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco, size: 80, color: Colors.white, shadows: [Shadow(color: Colors.black54,blurRadius: 5, offset: Offset(0, 3))],),
                      const SizedBox(height: 10),
                      const Text(
                        'ตู้ปลูกผัก demo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 13))],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'ระบบไฮโดรโปนิกส์ควบคุมโดย PID',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          shadows: [Shadow(color: Colors.black54,blurRadius: 5, offset: Offset(0, 3))],



                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => setState(() {}),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMetricCard('pH', ph.toStringAsFixed(1), '', getStatusColor(ph, 5.5, 7.0), Icons.science),
                      _buildMetricCard('EC', ec.toStringAsFixed(1), 'mS/cm', getStatusColor(ec, 0.8, 2.0), Icons.electric_meter),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMetricCard('อุณหภูมิ', temp.toStringAsFixed(1), '°C', getStatusColor(temp, 22, 30), Icons.thermostat),
                      _buildMetricCard('TDS', tds.toStringAsFixed(0), 'ppm', getStatusColor(tds, 500, 1500), Icons.water),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'แดชบอร์ด'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'ประวัติ'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ควบคุม'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'ข้อมูลค่า'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ControlScreen()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoScreen()));
          }
        },
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String unit, Color color, IconData icon) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 50, color: color),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
              ),
              Text(unit, style: TextStyle(fontSize: 14, color: color.withOpacity(0.8))),
            ],
          ),
        ),
      ),
    );
  }
}

// หน้า 2: ประวัติข้อมูล
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ประวัติข้อมูล'), centerTitle: true, backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ข้อมูลย้อนหลัง 24 ชั่วโมง', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.green),
                    title: Text('เวลา ${24 - index}:00 น.'),
                    subtitle: Text('pH: 6.5 | EC: 1.2 | Temp: 26°C | TDS: 780 ppm'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// หน้า 3: ควบคุมอุปกรณ์
// หน้า 3: ควบคุมอุปกรณ์ (เพิ่มควบคุมไฟ)
class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int pumpMode = 0; // 0 = Off, 1 = On, 2 = Auto
  int lightMode = 0; // 0 = Off, 1 = On, 2 = Auto (เพิ่มส่วนนี้)

  String getModeText(int mode) {
    switch (mode) {
      case 0:
        return 'ปิด';
      case 1:
        return 'เปิด';
      case 2:
        return 'อัตโนมัติ';
      default:
        return 'ปิด';
    }
  }

  Color getModeColor(int mode) {
    switch (mode) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getModeIcon(int mode) {
    switch (mode) {
      case 0:
        return Icons.power_off;
      case 1:
        return Icons.power_settings_new;
      case 2:
        return Icons.auto_awesome;
      default:
        return Icons.power_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ควบคุมอุปกรณ์'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // กล่องควบคุมปั๊มน้ำ
            _buildControlCard(
              title: 'ปั๊มน้ำ',
              icon: Icons.water_drop,
              mode: pumpMode,
              onModeChange: (newMode) => setState(() => pumpMode = newMode),
            ),
            const SizedBox(height: 32),
            // กล่องควบคุมไฟ LED (เพิ่มใหม่)
            _buildControlCard(
              title: 'ไฟปลูกผัก',
              icon: Icons.lightbulb,
              mode: lightMode,
              onModeChange: (newMode) => setState(() => lightMode = newMode),
            ),
            const SizedBox(height: 40),
            const Text(
              'การควบคุมจะส่งคำสั่งไปยังอุปกรณ์จริงทันที',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard({
    required String title,
    required IconData icon,
    required int mode,
    required Function(int) onModeChange,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 40, color: getModeColor(mode)),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.power_off,
                            color: mode == 0 ? Colors.red : Colors.grey[400], size: 36),
                        onPressed: () => onModeChange(0),
                      ),
                      const Text('ปิด', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.power_settings_new,
                            color: mode == 1 ? Colors.green : Colors.grey[400], size: 36),
                        onPressed: () => onModeChange(1),
                      ),
                      const Text('เปิด', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.auto_awesome,
                            color: mode == 2 ? Colors.blue : Colors.grey[400], size: 36),
                        onPressed: () => onModeChange(2),
                      ),
                      const Text('อัตโนมัติ', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(getModeIcon(mode), size: 40, color: getModeColor(mode)),
              const SizedBox(width: 12),
              Text(
                'สถานะ: ${getModeText(mode)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: getModeColor(mode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (mode == 2)
            const Text(
              'จะทำงานอัตโนมัติตามช่วงเวลาที่ตั้งไว้',
              style: TextStyle(fontSize: 14, color: Colors.green),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
// หน้า 4: ข้อมูลอธิบายค่าต่าง ๆ (หน้าใหม่ที่เพิ่ม)
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ข้อมูลเกี่ยวกับค่าต่าง ๆ'), centerTitle: true, backgroundColor: Colors.green),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(
            icon: Icons.science,
            title: 'pH (ค่าความเป็นกรด-ด่าง)',
            description:
            'บอกระดับความเป็นกรด-ด่างของน้ำในระบบ\n'
                '• ช่วงปกติสำหรับผักส่วนใหญ่: 5.5 - 7.0\n'
                '• ต่ำเกิน → กรดมาก รากอาจถูกทำลาย\n'
                '• สูงเกิน → ด่างมาก สารอาหารดูดซึมได้น้อย',
            normalRange: 'ช่วงปกติ:5.5 - 7.0',
            color: Colors.green,
          ),
          _buildInfoCard(
            icon: Icons.electric_meter,
            title: 'EC (Electrical Conductivity)',
            description:
            'วัดความเข้มข้นของสารอาหารในน้ำ\n'
                '• หน่วย: mS/cm\n'
                '• ช่วงปกติสำหรับผักส่วนใหญ่: 0.8 - 2.0\n'
                '• ต่ำเกิน → ขาดสารอาหาร\n'
                '• สูงเกิน → เผาไหม้ราก (nutrient burn)',
            normalRange: 'ช่วงปกติ:0.8 - 2.0 mS/cm',
            color: Colors.blue,
          ),
          _buildInfoCard(
            icon: Icons.thermostat,
            title: 'อุณหภูมิน้ำ',
            description:
            'อุณหภูมิของน้ำในระบบ\n'
                '• ช่วงปกติ: 22 - 30°C\n'
                '• ต่ำเกิน → รากดูดซึมสารอาหารช้า\n'
                '• สูงเกิน → ออกซิเจนในน้ำลด รากอาจเน่า',
            normalRange: 'ช่วงปกติ:22 - 30°C',
            color: Colors.orange,
          ),
          _buildInfoCard(
            icon: Icons.water,
            title: 'TDS (Total Dissolved Solids)',
            description:
            'ปริมาณสารละลายทั้งหมดในน้ำ (หน่วย ppm)\n'
                '• ช่วงปกติสำหรับผัก: 500 - 1500 ppm\n'
                '• มักใช้คู่กับ EC เพื่อยืนยันความเข้มข้น',
            normalRange: 'ช่วงปกติ:500 - 1500 ppm',
            color: Colors.teal,
          ),
          _buildInfoCard(
            icon: Icons.manage_accounts,
            title: ' ผู้จัดทำ',
            description:''
                '• นายฉัตรรัฐ ไวสติ\n'
                '• นายxxxxxxxxxx\n'
                '• นายxxxxxxxxxx\n'
                'มหาวิทยาลัยเทคโนโลยีราชมงคลล้านนา เชี่ยงใหม่',
            normalRange: 'คณะวิศวกรรมศาสตร์\n' ' สาขาวิศวกรรมไฟฟ้า สาขาวิชาวิศวกรรมคอมพิวเตอร์'  ,
            color: Colors.teal,
          ),

          const SizedBox(height: 40),
          const Text(
            'หมายเหตุ: ค่าปกติอาจแตกต่างกันตามชนิดผักและระยะการเจริญเติบโต',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required String normalRange,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
                  child: Icon(icon, size: 40, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        ' $normalRange',
                        style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(description, style: const TextStyle(fontSize: 15, height: 1.5)),
          ],
        ),
      ),
    );
  }
}