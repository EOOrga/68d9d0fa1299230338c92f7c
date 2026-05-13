import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

const bool kScreenshotMode = bool.fromEnvironment('SCREENSHOT_MODE');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await OperationsController.load(
    screenshotMode: kScreenshotMode,
  );
  runApp(PetersonChristopherApp(controller: controller));
}

class PetersonChristopherApp extends StatelessWidget {
  const PetersonChristopherApp({super.key, required this.controller});

  final OperationsController controller;

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: BrandColors.teal,
      onPrimary: Colors.white,
      secondary: BrandColors.gold,
      onSecondary: BrandColors.navy,
      tertiary: BrandColors.cyan,
      onTertiary: BrandColors.navy,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      surface: BrandColors.surface,
      onSurface: BrandColors.ink,
      surfaceContainerHighest: Color(0xFFE0EFF1),
      onSurfaceVariant: Color(0xFF365154),
      outline: Color(0xFF6F8588),
      outlineVariant: Color(0xFFBFCFD2),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: BrandColors.navy,
      onInverseSurface: Colors.white,
      inversePrimary: BrandColors.cyan,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          title: AppText.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: colorScheme,
            useMaterial3: true,
            scaffoldBackgroundColor: BrandColors.surface,
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              backgroundColor: BrandColors.surface,
              foregroundColor: BrandColors.ink,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFD7E4E7)),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: BrandColors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: Colors.white,
              indicatorColor: BrandColors.cyan.withValues(alpha: 0.16),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                );
              }),
            ),
          ),
          home: HomeShell(controller: controller),
        );
      },
    );
  }
}

class BrandColors {
  static const navy = Color(0xFF041B33);
  static const deepNavy = Color(0xFF021226);
  static const teal = Color(0xFF008B83);
  static const cyan = Color(0xFF16C7D9);
  static const gold = Color(0xFFF5B824);
  static const surface = Color(0xFFF6FAFB);
  static const ink = Color(0xFF0E2633);
}

class AppText {
  static const appName = 'PETERSON CHRISTOPHER';
  static const developerName = 'PETERSON CHRISTOPHER';
  static const supportEmail = 'support@petersonchristopher.com';
}

enum OperationType { maintenance, interview, procurement, patient }

extension OperationTypeDetails on OperationType {
  String get label {
    switch (this) {
      case OperationType.maintenance:
        return 'Maintenance';
      case OperationType.interview:
        return 'Interview';
      case OperationType.procurement:
        return 'Procurement';
      case OperationType.patient:
        return 'Patient record';
    }
  }

  String get pluralLabel {
    switch (this) {
      case OperationType.maintenance:
        return 'Maintenance requests';
      case OperationType.interview:
        return 'Interview scheduling';
      case OperationType.procurement:
        return 'Procurement requests';
      case OperationType.patient:
        return 'Patient records';
    }
  }

  IconData get icon {
    switch (this) {
      case OperationType.maintenance:
        return Icons.build_circle_outlined;
      case OperationType.interview:
        return Icons.event_available_outlined;
      case OperationType.procurement:
        return Icons.shopping_cart_checkout_outlined;
      case OperationType.patient:
        return Icons.medical_information_outlined;
    }
  }

  Color get color {
    switch (this) {
      case OperationType.maintenance:
        return BrandColors.teal;
      case OperationType.interview:
        return const Color(0xFF0078B7);
      case OperationType.procurement:
        return BrandColors.gold;
      case OperationType.patient:
        return const Color(0xFF0B9D92);
    }
  }
}

enum OperationStatus { intake, scheduled, active, waiting, completed }

extension OperationStatusDetails on OperationStatus {
  String get label {
    switch (this) {
      case OperationStatus.intake:
        return 'Intake';
      case OperationStatus.scheduled:
        return 'Scheduled';
      case OperationStatus.active:
        return 'Active';
      case OperationStatus.waiting:
        return 'Waiting';
      case OperationStatus.completed:
        return 'Completed';
    }
  }
}

class OperationRecord {
  const OperationRecord({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.contact,
    required this.department,
    required this.dueDate,
    required this.notes,
    required this.highPriority,
  });

  final String id;
  final OperationType type;
  final OperationStatus status;
  final String title;
  final String contact;
  final String department;
  final DateTime dueDate;
  final String notes;
  final bool highPriority;

  OperationRecord copyWith({
    OperationType? type,
    OperationStatus? status,
    String? title,
    String? contact,
    String? department,
    DateTime? dueDate,
    String? notes,
    bool? highPriority,
  }) {
    return OperationRecord(
      id: id,
      type: type ?? this.type,
      status: status ?? this.status,
      title: title ?? this.title,
      contact: contact ?? this.contact,
      department: department ?? this.department,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      highPriority: highPriority ?? this.highPriority,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'type': type.name,
      'status': status.name,
      'title': title,
      'contact': contact,
      'department': department,
      'dueDate': dueDate.toIso8601String(),
      'notes': notes,
      'highPriority': highPriority,
    };
  }

  static OperationRecord fromJson(Map<String, Object?> json) {
    return OperationRecord(
      id: json['id'] as String,
      type: OperationType.values.byName(json['type'] as String),
      status: OperationStatus.values.byName(json['status'] as String),
      title: json['title'] as String,
      contact: json['contact'] as String,
      department: json['department'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      notes: json['notes'] as String,
      highPriority: json['highPriority'] as bool,
    );
  }
}

class OperationsController extends ChangeNotifier {
  OperationsController._({
    required List<OperationRecord> records,
    required File? storageFile,
    required bool persistenceEnabled,
  }) : _records = records,
       _storageFile = storageFile,
       _persistenceEnabled = persistenceEnabled;

  static const _recordsKey = 'peterson_christopher_records_v1';

  final File? _storageFile;
  final bool _persistenceEnabled;
  List<OperationRecord> _records;

  static Future<OperationsController> load({
    required bool screenshotMode,
  }) async {
    if (screenshotMode) {
      return OperationsController.memory(records: screenshotRecords());
    }

    final storageFile = _recordStorageFile();
    final encoded = storageFile.existsSync()
        ? storageFile.readAsStringSync()
        : null;
    final records = encoded == null || encoded.isEmpty
        ? <OperationRecord>[]
        : (jsonDecode(encoded) as List<Object?>)
              .whereType<Map<String, Object?>>()
              .map(OperationRecord.fromJson)
              .toList();

    return OperationsController._(
      records: records,
      storageFile: storageFile,
      persistenceEnabled: true,
    );
  }

  factory OperationsController.memory({List<OperationRecord>? records}) {
    return OperationsController._(
      records: records ?? <OperationRecord>[],
      storageFile: null,
      persistenceEnabled: false,
    );
  }

  static File _recordStorageFile() {
    final directory = Directory(
      '${Directory.systemTemp.path}/peterson_christopher_ops',
    );
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return File('${directory.path}/$_recordsKey.json');
  }

  List<OperationRecord> get records {
    final sorted = List<OperationRecord>.from(_records);
    sorted.sort((a, b) {
      final priority = b.highPriority.toString().compareTo(
        a.highPriority.toString(),
      );
      if (priority != 0) {
        return priority;
      }
      return a.dueDate.compareTo(b.dueDate);
    });
    return sorted;
  }

  List<OperationRecord> byType(OperationType type) {
    return records.where((record) => record.type == type).toList();
  }

  int countByStatus(OperationStatus status) {
    return _records.where((record) => record.status == status).length;
  }

  OperationRecord? find(String id) {
    for (final record in _records) {
      if (record.id == id) {
        return record;
      }
    }
    return null;
  }

  void upsert(OperationRecord record) {
    final index = _records.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      _records = [..._records, record];
    } else {
      final updated = List<OperationRecord>.from(_records);
      updated[index] = record;
      _records = updated;
    }
    _save();
    notifyListeners();
  }

  void delete(String id) {
    _records = _records.where((record) => record.id != id).toList();
    _save();
    notifyListeners();
  }

  void clearAll() {
    _records = <OperationRecord>[];
    _save();
    notifyListeners();
  }

  void _save() {
    if (!_persistenceEnabled) {
      return;
    }
    final encoded = jsonEncode(
      _records.map((record) => record.toJson()).toList(),
    );
    _storageFile?.writeAsStringSync(encoded, flush: true);
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});

  final OperationsController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(
        controller: widget.controller,
        onShowRequests: () => setState(() => _currentIndex = 1),
      ),
      RequestsScreen(controller: widget.controller),
      PatientRecordsScreen(controller: widget.controller),
      SettingsScreen(controller: widget.controller),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1 || _currentIndex == 2
          ? FloatingActionButton.extended(
              key: const ValueKey('create-record'),
              onPressed: () {
                final initialType = _currentIndex == 2
                    ? OperationType.patient
                    : OperationType.maintenance;
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => RecordEditorPage(
                      controller: widget.controller,
                      initialType: initialType,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New'),
            )
          : null,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.controller,
    required this.onShowRequests,
  });

  final OperationsController controller;
  final VoidCallback onShowRequests;

  @override
  Widget build(BuildContext context) {
    final active = controller.records
        .where((record) => record.status != OperationStatus.completed)
        .length;
    final highPriority = controller.records
        .where(
          (record) =>
              record.highPriority && record.status != OperationStatus.completed,
        )
        .length;
    final dueSoon = controller.records
        .where(
          (record) =>
              record.status != OperationStatus.completed &&
              record.dueDate.difference(DateTime.now()).inDays <= 2,
        )
        .length;
    final completed = controller.countByStatus(OperationStatus.completed);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const _ScreenTitle(
          title: AppText.appName,
          subtitle: 'Daily operations command center',
        ),
        const SizedBox(height: 12),
        _HeroPanel(onShowRequests: onShowRequests),
        const SizedBox(height: 16),
        _SectionHeader(
          title: 'Today at a glance',
          actionLabel: 'View all',
          onPressed: onShowRequests,
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 8) / 2;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetricTile(
                  width: itemWidth,
                  value: '$active',
                  label: 'Open items',
                  icon: Icons.pending_actions_outlined,
                ),
                _MetricTile(
                  width: itemWidth,
                  value: '$highPriority',
                  label: 'Priority',
                  icon: Icons.priority_high_rounded,
                ),
                _MetricTile(
                  width: itemWidth,
                  value: '$dueSoon',
                  label: 'Due soon',
                  icon: Icons.timer_outlined,
                ),
                _MetricTile(
                  width: itemWidth,
                  value: '$completed',
                  label: 'Completed',
                  icon: Icons.verified_outlined,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: 'Service lanes'),
        const SizedBox(height: 8),
        for (final type in OperationType.values)
          _ServiceLaneCard(type: type, count: controller.byType(type).length),
        const SizedBox(height: 12),
        const _SectionHeader(title: 'Next work'),
        const SizedBox(height: 8),
        if (controller.records.isEmpty)
          const EmptyState(
            icon: Icons.assignment_add,
            title: 'No local records yet',
            body: 'Create a request or patient record to start tracking work.',
          )
        else
          for (final record in controller.records.take(3))
            RecordTile(
              record: record,
              onTap: () => _openDetail(context, controller, record),
            ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.onShowRequests});

  final VoidCallback onShowRequests;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [BrandColors.deepNavy, BrandColors.navy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'docs/icon.png',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'One workspace for four essential tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Capture requests, schedules, purchasing needs, and patient record notes without accounts or cloud sync.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: onShowRequests,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Open queue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key, required this.controller});

  final OperationsController controller;

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  OperationType? _filter;

  @override
  Widget build(BuildContext context) {
    final records = _filter == null
        ? widget.controller.records
        : widget.controller.byType(_filter!);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        const _ScreenTitle(
          title: 'Operations queue',
          subtitle: 'Maintenance, interviews, procurement, and patient tasks',
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: _filter == null,
                  onSelected: (_) => setState(() => _filter = null),
                ),
              ),
              for (final type in OperationType.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(type.icon, size: 18),
                    label: Text(type.label),
                    selected: _filter == type,
                    onSelected: (_) => setState(() => _filter = type),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (records.isEmpty)
          const EmptyState(
            icon: Icons.assignment_outlined,
            title: 'Queue is clear',
            body: 'Use New to capture the next business task locally.',
          )
        else
          for (final record in records)
            RecordTile(
              record: record,
              onTap: () => _openDetail(context, widget.controller, record),
            ),
      ],
    );
  }
}

class PatientRecordsScreen extends StatelessWidget {
  const PatientRecordsScreen({super.key, required this.controller});

  final OperationsController controller;

  @override
  Widget build(BuildContext context) {
    final patients = controller.byType(OperationType.patient);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        const _ScreenTitle(
          title: 'Patient records',
          subtitle: 'Local notes for intake, follow-up, and file readiness',
        ),
        const SizedBox(height: 12),
        if (patients.isEmpty)
          const EmptyState(
            icon: Icons.medical_information_outlined,
            title: 'No patient records',
            body: 'Create a local patient note for the next intake or update.',
          )
        else
          for (final record in patients)
            RecordTile(
              record: record,
              onTap: () => _openDetail(context, controller, record),
            ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final OperationsController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const _ScreenTitle(
          title: 'Settings',
          subtitle: 'Local workspace preferences and privacy',
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.phone_android_outlined),
                title: Text('Device-only storage'),
                subtitle: Text(
                  'Records stay in this app on this Android device.',
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.cloud_off_outlined),
                title: Text('No account or sync'),
                subtitle: Text('The app does not upload business records.'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('No analytics'),
                subtitle: Text(
                  'No tracking, advertising identifiers, or cloud APIs.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Local record controls',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${controller.records.length} records are saved on this device.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: controller.records.isEmpty
                      ? null
                      : () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Clear local records?'),
                              content: const Text(
                                'This removes saved requests and patient notes from this device.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Clear'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            controller.clearAll();
                          }
                        },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear local records'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.support_agent_outlined),
            title: Text('Support'),
            subtitle: Text(AppText.supportEmail),
          ),
        ),
      ],
    );
  }
}

class RecordDetailPage extends StatelessWidget {
  const RecordDetailPage({
    super.key,
    required this.controller,
    required this.recordId,
  });

  final OperationsController controller;
  final String recordId;

  @override
  Widget build(BuildContext context) {
    final record = controller.find(recordId);
    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Record')),
        body: const EmptyState(
          icon: Icons.info_outline,
          title: 'Record unavailable',
          body: 'The selected local record is no longer saved.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(record.type.label),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => RecordEditorPage(
                    controller: controller,
                    existingRecord: record,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatusBanner(record: record),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.person_outline,
                    label: 'Responsible contact',
                    value: record.contact,
                  ),
                  _DetailRow(
                    icon: Icons.apartment_outlined,
                    label: 'Department or location',
                    value: record.department,
                  ),
                  _DetailRow(
                    icon: Icons.event_outlined,
                    label: 'Target date',
                    value: formatDate(record.dueDate),
                  ),
                  _DetailRow(
                    icon: Icons.notes_outlined,
                    label: 'Notes',
                    value: record.notes,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: record.status == OperationStatus.completed
                ? null
                : () {
                    controller.upsert(
                      record.copyWith(status: OperationStatus.completed),
                    );
                    Navigator.of(context).pop();
                  },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Mark completed'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              controller.delete(record.id);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete record'),
          ),
        ],
      ),
    );
  }
}

class RecordEditorPage extends StatefulWidget {
  const RecordEditorPage({
    super.key,
    required this.controller,
    this.initialType,
    this.existingRecord,
  });

  final OperationsController controller;
  final OperationType? initialType;
  final OperationRecord? existingRecord;

  @override
  State<RecordEditorPage> createState() => _RecordEditorPageState();
}

class _RecordEditorPageState extends State<RecordEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contactController;
  late final TextEditingController _departmentController;
  late final TextEditingController _dateController;
  late final TextEditingController _notesController;
  late OperationType _type;
  late OperationStatus _status;
  late bool _highPriority;

  @override
  void initState() {
    super.initState();
    final record = widget.existingRecord;
    _type = record?.type ?? widget.initialType ?? OperationType.maintenance;
    _status = record?.status ?? OperationStatus.intake;
    _highPriority = record?.highPriority ?? false;
    _titleController = TextEditingController(text: record?.title ?? '');
    _contactController = TextEditingController(text: record?.contact ?? '');
    _departmentController = TextEditingController(
      text: record?.department ?? '',
    );
    _dateController = TextEditingController(
      text: record == null
          ? formatDate(DateTime.now())
          : formatDate(record.dueDate),
    );
    _notesController = TextEditingController(text: record?.notes ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contactController.dispose();
    _departmentController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existingRecord != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit record' : 'New record')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            DropdownButtonFormField<OperationType>(
              key: const ValueKey('type-field'),
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Task type'),
              items: OperationType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.pluralLabel),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _type = value);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('title-field'),
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a title'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('contact-field'),
              controller: _contactController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Responsible contact',
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a responsible contact'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('department-field'),
              controller: _departmentController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Department or location',
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a department or location'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('date-field'),
              controller: _dateController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: 'Target date',
                helperText: 'Use YYYY-MM-DD',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a target date';
                }
                return parseDate(value) == null ? 'Use YYYY-MM-DD' : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<OperationStatus>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: OperationStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _status = value);
                }
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _highPriority,
              onChanged: (value) => setState(() => _highPriority = value),
              title: const Text('Priority item'),
              subtitle: const Text(
                'Keep this visible near the top of the queue.',
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('notes-field'),
              controller: _notesController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Operational notes'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter notes' : null,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const ValueKey('save-record'),
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save record'),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final existing = widget.existingRecord;
    final record = OperationRecord(
      id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: _type,
      status: _status,
      title: _titleController.text.trim(),
      contact: _contactController.text.trim(),
      department: _departmentController.text.trim(),
      dueDate: parseDate(_dateController.text.trim())!,
      notes: _notesController.text.trim(),
      highPriority: _highPriority,
    );
    widget.controller.upsert(record);
    Navigator.of(context).pop();
  }
}

class RecordTile extends StatelessWidget {
  const RecordTile({super.key, required this.record, required this.onTap});

  final OperationRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badgeColor = record.type.color;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: badgeColor.withValues(alpha: 0.14),
          foregroundColor: record.type == OperationType.procurement
              ? BrandColors.navy
              : badgeColor,
          child: Icon(record.type.icon, size: 22),
        ),
        title: Text(
          record.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${record.status.label} • ${record.contact} • ${formatDate(record.dueDate)}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: record.highPriority
            ? const Icon(Icons.priority_high_rounded, color: BrandColors.gold)
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _ServiceLaneCard extends StatelessWidget {
  const _ServiceLaneCard({required this.type, required this.count});

  final OperationType type;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: type.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(type.icon, color: BrandColors.navy),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.pluralLabel,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text('$count local records'),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.width,
    required this.value,
    required this.label,
    required this.icon,
  });

  final double width;
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: BrandColors.teal),
              const SizedBox(height: 10),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: BrandColors.navy,
                ),
              ),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onPressed});

  final String title;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onPressed, child: Text(actionLabel!)),
      ],
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  const _ScreenTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: BrandColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF496268)),
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, size: 42, color: BrandColors.teal),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.record});

  final OperationRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: record.type.color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: record.type.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(record.type.icon, color: BrandColors.navy),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.status.label,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  record.highPriority
                      ? 'Priority item'
                      : record.type.pluralLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: BrandColors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF496268),
                  ),
                ),
                const SizedBox(height: 2),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _openDetail(
  BuildContext context,
  OperationsController controller,
  OperationRecord record,
) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) =>
          RecordDetailPage(controller: controller, recordId: record.id),
    ),
  );
}

String formatDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

DateTime? parseDate(String value) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
  if (match == null) {
    return null;
  }
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final parsed = DateTime(year, month, day);
  if (parsed.year != year || parsed.month != month || parsed.day != day) {
    return null;
  }
  return parsed;
}

List<OperationRecord> screenshotRecords() {
  return [
    OperationRecord(
      id: 'maintenance-sterilizer',
      type: OperationType.maintenance,
      status: OperationStatus.active,
      title: 'Sterilizer calibration request',
      contact: 'Facilities desk',
      department: 'Clinical wing B',
      dueDate: DateTime(2026, 5, 13),
      notes: 'Confirm calibration slot, vendor arrival, and room access.',
      highPriority: true,
    ),
    OperationRecord(
      id: 'interview-reception',
      type: OperationType.interview,
      status: OperationStatus.scheduled,
      title: 'Receptionist interview panel',
      contact: 'Avery Morgan',
      department: 'Front office',
      dueDate: DateTime(2026, 5, 14),
      notes: 'Prepare questions, candidate file, and panel room.',
      highPriority: false,
    ),
    OperationRecord(
      id: 'procurement-supplies',
      type: OperationType.procurement,
      status: OperationStatus.waiting,
      title: 'Exam room supply restock',
      contact: 'Procurement lead',
      department: 'Exam rooms 2 and 3',
      dueDate: DateTime(2026, 5, 15),
      notes: 'Order gloves, paper rolls, sanitation wipes, and labels.',
      highPriority: true,
    ),
    OperationRecord(
      id: 'patient-intake',
      type: OperationType.patient,
      status: OperationStatus.intake,
      title: 'Jordan Lee intake review',
      contact: 'Records desk',
      department: 'Patient services',
      dueDate: DateTime(2026, 5, 16),
      notes: 'Verify referral notes and insurance form before visit.',
      highPriority: false,
    ),
    OperationRecord(
      id: 'patient-follow-up',
      type: OperationType.patient,
      status: OperationStatus.completed,
      title: 'Mira Patel file update',
      contact: 'Care coordinator',
      department: 'Follow-up desk',
      dueDate: DateTime(2026, 5, 12),
      notes: 'Updated phone number and attached follow-up summary.',
      highPriority: false,
    ),
  ];
}
