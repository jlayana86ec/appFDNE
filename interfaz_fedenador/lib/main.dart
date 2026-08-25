import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── COLORES ─────────────────────────────────────────────────────────────────
const kGold = Color(0xFFB8860B);
const kGoldLight = Color(0xFFDAA520);
const kGoldDark = Color(0xFF8B6508);
const kWhite = Colors.white;
const kDark = Color(0xFF1a1a1a);

// ─── CONECTIVIDAD ────────────────────────────────────────────────────────────
Future<bool> isConnected() async {
  try {
    final r = await Connectivity().checkConnectivity();
    if (r == ConnectivityResult.none) return false;
    return await InternetConnection().hasInternetAccess;
  } catch (_) {
    return false;
  }
}

// ─── MODELO DE MENÚ (soporta niveles infinitos) ───────────────────────────────
class MenuItem {
  final String label;
  final String? url;
  final List<MenuItem> children;
  MenuItem({required this.label, this.url, this.children = const []});
}

final menuItems = [
  MenuItem(
    label: 'PÁGINA WEB',
    url: 'https://fedenador.org.ec',
  ),
  MenuItem(
    label: 'PLATAFORMA VIRTUAL',
    url: 'https://educa.fedenador.org.ec/moodle30/login/index.php',
  ),
  MenuItem(
    label: 'MI DATA',
    children: [
      MenuItem(
        label: 'CENSO',
        children: [
          MenuItem(
              label: 'Censo Deportivo Nacional',
              url: 'https://fedenador.org.ec/censo-deportivo-nacional/'),
          // Para agregar más: MenuItem(label: 'NOMBRE', url: 'ENLACE'),
        ],
      ),
      MenuItem(
        label: 'IDEM',
        children: [
          MenuItem(
            label: 'Juegos Deportivos Nacional de Menores',
            children: [
              MenuItem(
                label: 'IDEM-JDN Menores Manabí 2024',
                url: 'https://fedenador.org.ec/idem-jdn-menores-manabi-2024/',
                children: [
                  MenuItem(
                      label: 'Informes IDEM Menores Manabí 2024',
                      url:
                          'https://fedenador.org.ec/informes-idem-menores-manabi-2024/'),
                  MenuItem(
                      label: 'Boletines y programaciones Menores Manabí 2024',
                      url:
                          'https://fedenador.org.ec/boletines-y-programaciones-menores-manabi-2024/'),
                ],
              ),
              MenuItem(
                label: 'IDEM-JDN Menores Guayas 2023',
                url: 'https://fedenador.org.ec/idem-jdn-menores-guayas-2023/',
                children: [
                  MenuItem(
                      label: 'Informes IDEM Menores Guayas 2023',
                      url:
                          'https://fedenador.org.ec/informes-idem-menores-guayas-2023/'),
                  MenuItem(
                      label: 'Boletines y programaciones Menores Guayas 2023',
                      url:
                          'https://fedenador.org.ec/boletines-y-programaciones-menores-guayas-2023/'),
                ],
              ),
            ],
          ),
          MenuItem(label: 'Juegos Deportivos Nacional Prejuveniles'),
          MenuItem(label: 'Juegos Deportivos Nacional Juveniles'),
          // Para agregar más: MenuItem(label: 'NOMBRE', url: 'ENLACE'),
        ],
      ),
    ],
  ),
  MenuItem(
    label: 'PLAN ANUAL DE CAPACITACIÓN 2026',
    url: 'https://fedenador.org.ec/calendario-2026/',
  ),
];

// ─── MAIN ─────────────────────────────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFF0F0F0),
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: kGold,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const FedenadorApp());
}

class FedenadorApp extends StatelessWidget {
  const FedenadorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fedenador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kGold),
        useMaterial3: true,
        splashFactory: InkRipple.splashFactory,
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── SPLASH ──────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _iconCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
  late final AnimationController _logoCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600));

  late final Animation<double> _iconScale = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut));
  late final Animation<double> _logoOpacity = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn));
  late final Animation<Offset> _logoSlide =
      Tween(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    // 1. Aparece el ícono circular
    _iconCtrl.forward().then((_) {
      // 2. Aparece el logo y texto
      Future.delayed(const Duration(milliseconds: 200), _logoCtrl.forward);
    });
    // 3. Navega al home
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 350),
        ));
      }
    });
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _logoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF0EAD0), kGoldLight],
          ),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // ── Ícono circular (aparece primero) ──
            ScaleTransition(
              scale: _iconScale,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGold,
                  boxShadow: [
                    BoxShadow(
                      color: kGold.withOpacity(0.5),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icono.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.shield,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Logo + texto (aparece después) ──
            FadeTransition(
              opacity: _logoOpacity,
              child: SlideTransition(
                position: _logoSlide,
                child: Column(children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 260,
                    errorBuilder: (_, __, ___) => const Text(
                      'FEDENADOR',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: kGold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'FEDERACIÓN DEPORTIVA NACIONAL DEL ECUADOR',
                    style: TextStyle(
                      fontSize: 9,
                      color: kGoldDark,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─── HOME ─────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Mapa de qué ítems están expandidos
  final Map<String, bool> _expanded = {};
  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<double>> _animations = {};

  late final AnimationController _b1 = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
  late final AnimationController _b2 = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));
  late final AnimationController _b3 = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 80), _b1.forward);
    Future.delayed(const Duration(milliseconds: 180), _b2.forward);
    Future.delayed(const Duration(milliseconds: 280), _b3.forward);
  }

  @override
  void dispose() {
    _b1.dispose();
    _b2.dispose();
    _b3.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  AnimationController _getCtrl(String key) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 220));
      _animations[key] =
          CurvedAnimation(parent: _controllers[key]!, curve: Curves.easeInOut);
    }
    return _controllers[key]!;
  }

  void _toggle(String key) {
    final isOpen = _expanded[key] ?? false;
    setState(() => _expanded[key] = !isOpen);
    if (!isOpen) {
      _getCtrl(key).forward();
    } else {
      _getCtrl(key).reverse();
    }
  }

  bool _isExpanded(String key) => _expanded[key] ?? false;

  Future<void> _open(String url, String title) async {
    if (!await isConnected()) {
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const NoInternetScreen()));
      }
      return;
    }
    if (mounted) {
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => WebViewScreen(url: url, title: title),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 250),
          ));
    }
  }

  Future<bool> _exitDialog() async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('¿Deseas salir?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('¿Deseas cerrar la aplicación?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCELAR',
                    style: TextStyle(color: Colors.grey))),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('SALIR',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold))),
          ],
        ),
      ) ??
      false;

  // Construye recursivamente cualquier nivel de submenús
  Widget _buildMenuItems(
      List<MenuItem> items, int depth, AnimationController btnCtrl) {
    return Column(
      children: items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        final hasChildren = item.children.isNotEmpty;
        final key = '${depth}_${item.label}';
        final isOpen = _isExpanded(key);

        // Delay de entrada escalonado
        final ctrl = depth == 0
            ? (i == 0
                ? _b1
                : i == 1
                    ? _b2
                    : _b3)
            : btnCtrl;

        Widget button = AnimatedBuilder(
          animation: ctrl,
          builder: (_, __) => Opacity(
            opacity: ctrl.value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, 18 * (1 - ctrl.value.clamp(0.0, 1.0))),
              child: _buildButton(item, key, depth, isOpen, hasChildren),
            ),
          ),
        );

        if (!hasChildren) {
          return Padding(
            padding: EdgeInsets.only(bottom: depth == 0 ? 14 : 4),
            child: button,
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: depth == 0 ? 14 : 4),
          child: Column(children: [
            button,
            SizeTransition(
              sizeFactor: _animations[key] ?? const AlwaysStoppedAnimation(0),
              child: Padding(
                padding: EdgeInsets.only(left: depth == 0 ? 14 : 10, top: 4),
                child: _buildMenuItems(item.children, depth + 1, ctrl),
              ),
            ),
          ]),
        );
      }).toList(),
    );
  }

  Widget _buildButton(
      MenuItem item, String key, int depth, bool isOpen, bool hasChildren) {
    // Tamaños según profundidad
    final height = depth == 0
        ? 68.0
        : depth == 1
            ? 54.0
            : 46.0;
    final fontSize = depth == 0
        ? 15.0
        : depth == 1
            ? 13.0
            : 11.5;
    final iconSize = depth == 0 ? 26.0 : 20.0;
    final bgColor = depth == 0
        ? Colors.white
        : depth == 1
            ? const Color(0xFFFFF8E8)
            : const Color(0xFFFFF3D0);
    final radius = depth == 0 ? 14.0 : 10.0;
    final elevation = depth == 0 ? 6.0 : 3.0;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      elevation: elevation,
      shadowColor: kGold.withOpacity(0.3),
      child: InkWell(
        onTap: () {
          if (hasChildren) {
            _toggle(key);
          } else if (item.url != null) {
            _open(item.url!, item.label);
          }
        },
        borderRadius: BorderRadius.circular(radius),
        splashColor: kGoldLight.withOpacity(0.2),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: depth == 0 ? 18 : 14),
            child: Row(children: [
              if (depth == 0) ...[
                Icon(_iconForLabel(item.label), color: kGold, size: iconSize),
                const SizedBox(width: 12),
                Container(width: 1, height: 36, color: const Color(0xFFE8D080)),
                const SizedBox(width: 12),
              ] else ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kGold.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(item.label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: depth == 0 ? kDark : const Color(0xFF444444),
                      letterSpacing: 0.3,
                    )),
              ),
              AnimatedRotation(
                turns: (hasChildren && isOpen) ? 0.25 : 0,
                duration: const Duration(milliseconds: 220),
                child: Icon(Icons.chevron_right,
                    color: kGold, size: depth == 0 ? 22 : 18),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  IconData _iconForLabel(String label) {
    if (label.contains('WEB')) return Icons.language;
    if (label.contains('VIRTUAL') || label.contains('PLATAFORMA')) {
      return Icons.laptop_mac;
    }
    if (label.contains('DATA')) return Icons.person_outline;
    return Icons.chevron_right;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        // Cerrar submenús abiertos primero
        final anyOpen = _expanded.values.any((v) => v);
        if (anyOpen) {
          setState(() {
            for (final key in _expanded.keys.toList()) {
              _expanded[key] = false;
              _controllers[key]?.reverse();
            }
          });
          return;
        }
        if (await _exitDialog()) SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: kGoldLight,
        body: Column(children: [
          // ── Header blanco con curva ──
          Container(
            height: size.height * 0.50,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo principal (la imagen tipo "FEDENADOR" grande)
                  Image.asset(
                    'assets/logo.png',
                    width: size.width * 0.72,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Column(children: const [
                      Icon(Icons.shield, size: 80, color: kGold),
                      SizedBox(height: 8),
                      Text('FEDENADOR',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: kGold,
                            letterSpacing: 3,
                          )),
                    ]),
                  ),

                  const SizedBox(height: 12),

                  // Líneas decorativas + título
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 30, height: 1.5, color: kGold),
                      const SizedBox(width: 10),
                      const Text('LA MATRIZ DEL DEPORTE NACIONAL',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: kDark,
                            letterSpacing: 0.5,
                          )),
                      const SizedBox(width: 10),
                      Container(width: 30, height: 1.5, color: kGold),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'CAPACITAMOS  •  FORMAMOS  •  TRANSFORMAMOS',
                    style: TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFF777777),
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Banda colores Ecuador
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: size.width * 0.5,
                      height: 5,
                      child: Row(children: [
                        Expanded(
                            child: Container(color: const Color(0xFFFFD100))),
                        Expanded(
                            child: Container(color: const Color(0xFF003DA5))),
                        Expanded(
                            child: Container(color: const Color(0xFFCE1126))),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Botones ──
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
              child: _buildMenuItems(menuItems, 0, _b1),
            ),
          ),

          // ── Barra inferior ──
          Container(
            height: 68,
            decoration: BoxDecoration(
              color: kGold,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(children: const [
              _BVal(icon: Icons.star_border_rounded, label: 'EXCELENCIA'),
              _BVal(icon: Icons.menu_book_outlined, label: 'CAPACITACIÓN'),
              _BVal(icon: Icons.group_outlined, label: 'UNIÓN'),
              _BVal(icon: Icons.emoji_events_outlined, label: 'COMPROMISO'),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _BVal extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BVal({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 7.5, color: Colors.white, letterSpacing: 0.3)),
        ]),
      );
}

// ─── WEBVIEW ──────────────────────────────────────────────────────────────────
class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  const WebViewScreen({super.key, required this.url, required this.title});
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _ctrl;
  bool _error = false;
  late String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          _ctrl.getTitle().then((t) {
            if (t != null && t.isNotEmpty && t != 'about:blank' && mounted) {
              setState(() => _title = t);
            }
          });
        },
        onWebResourceError: (e) {
          if ((e.isForMainFrame ?? true) && mounted) {
            setState(() => _error = true);
          }
        },
        onNavigationRequest: (req) => _nav(req.url),
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  NavigationDecision _nav(String url) {
    if (url.contains('fedenador.org.ec')) return NavigationDecision.navigate;
    final ext = [
      'tel:',
      'mailto:',
      'whatsapp:',
      'market:',
      'geo:',
      'fb:',
      'instagram:',
      'twitter:',
      'youtube:'
    ];
    if (ext.any(url.startsWith)) {
      _ext(url);
      return NavigationDecision.prevent;
    }
    final social = [
      'wa.me',
      'api.whatsapp.com',
      'facebook.com',
      'instagram.com',
      'twitter.com',
      'x.com',
      'youtube.com',
      'youtu.be',
      'tiktok.com',
      'linkedin.com',
      'maps.google.com',
      'goo.gl/maps',
      'play.google.com'
    ];
    if (social.any(url.contains)) {
      _ext(url);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> _ext(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<bool> _back() async {
    if (await _ctrl.canGoBack()) {
      await _ctrl.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await _back() && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        // AppBar mínimo y limpio, sin barra de progreso
        appBar: AppBar(
          backgroundColor: kGold,
          foregroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: kGold,
            statusBarIconBrightness: Brightness.light,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () async {
              if (await _back() && context.mounted) Navigator.pop(context);
            },
          ),
          title: Row(children: [
            ClipOval(
              child: Image.asset('assets/icono.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.shield, size: 26, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 22),
              onPressed: () async {
                if (await isConnected()) {
                  _ctrl.reload();
                  setState(() => _error = false);
                } else {
                  setState(() => _error = true);
                }
              },
            ),
          ],
        ),
        body: _error ? _noInternet() : WebViewWidget(controller: _ctrl),
      ),
    );
  }

  Widget _noInternet() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.wifi_off_rounded, size: 90, color: kGold),
            const SizedBox(height: 20),
            const Text('Sin conexión a internet',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: kDark)),
            const SizedBox(height: 10),
            const Text('Verifica tu WiFi o datos móviles.',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (await isConnected()) {
                  setState(() => _error = false);
                  _ctrl.reload();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Aún sin conexión.')));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kGold,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('REINTENTAR',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ]),
        ),
      );
}

// ─── SIN INTERNET STANDALONE ─────────────────────────────────────────────────
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset('assets/icono.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.shield, size: 80, color: kGold)),
                    ),
                    const SizedBox(height: 28),
                    const Icon(Icons.wifi_off_rounded, size: 90, color: kGold),
                    const SizedBox(height: 20),
                    const Text('¡Sin conexión!',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: kDark)),
                    const SizedBox(height: 12),
                    const Text(
                        'No hay internet disponible.\nVerifica tu WiFi o datos móviles.',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF666666)),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kGold,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text('REGRESAR',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      );
}
