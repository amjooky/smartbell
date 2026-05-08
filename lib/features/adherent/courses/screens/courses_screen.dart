import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/auth/providers/auth_provider.dart';
import '../../../../shared/widgets/gym_badge.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> with SingleTickerProviderStateMixin {
  final _service = CourseService();
  List<Course> _courses = [];
  bool _loading = true;
  String? _error;
  int _selectedDay = 0;
  final _searchCtrl = TextEditingController();
  String _search = '';
  final Set<int> _reserving = {};

  static const _dayLabels = ['Tous', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  static const _dayKeys   = ['ALL','MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY'];

  List<Course> get _filtered {
    var list = _courses;
    if (_selectedDay > 0) {
      list = list.where((c) => c.dayOfWeek?.toUpperCase() == _dayKeys[_selectedDay]).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((c) =>
        c.name.toLowerCase().contains(q) ||
        (c.coachName?.toLowerCase().contains(q) ?? false)
      ).toList();
    }
    return list;
  }

  @override
  void initState() { super.initState(); _load(); }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      _courses = await _service.getCourses();
      setState(() => _loading = false);
    } catch (e) {
      setState(() { _error = DioClient.errorMessage(e); _loading = false; });
    }
  }

  Future<void> _reserve(Course course) async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    setState(() => _reserving.add(course.id));
    try {
      final memberRes = await DioClient.instance.dio.get('/members/user/${user.id}');
      final memberId  = (memberRes.data['id'] ?? 0).toInt();
      await _service.reserve(courseId: course.id, memberId: memberId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Réservation confirmée pour "${course.name}"'),
          backgroundColor: AppTheme.success,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(DioClient.errorMessage(e)),
          backgroundColor: AppTheme.error,
        ));
      }
    } finally {
      setState(() => _reserving.remove(course.id));
    }
  }

  static const _dayColors = [
    AppTheme.primary,
    Color(0xFFE57373), Color(0xFF81C784), Color(0xFF64B5F6),
    Color(0xFFFFB74D), Color(0xFFBA68C8), Color(0xFF4DB6AC), Color(0xFFF06292),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Cours', style: AppTheme.headingMedium),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _search = v),
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Rechercher un cours, coach...',
                  hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted, size: 20),
                  suffixIcon: _search.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear, size: 18, color: AppTheme.textMuted), onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); })
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _dayLabels.length,
                itemBuilder: (_, i) {
                  final sel = _selectedDay == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? _dayColors[i] : AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: sel ? _dayColors[i] : AppTheme.border, width: sel ? 1 : 0.5),
                      ),
                      child: Text(_dayLabels[i], style: TextStyle(
                        color: sel ? Colors.black : AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                      )),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : _error != null
              ? _ErrRetry(message: _error!, onRetry: _load)
              : RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: _load,
                  child: _filtered.isEmpty
                      ? const _Empty()
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final course = _filtered[i];
                            final dayIdx = _dayKeys.indexOf(course.dayOfWeek?.toUpperCase() ?? '').clamp(0, 7);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _CourseCard(
                                course: course,
                                accent: _dayColors[dayIdx],
                                isReserving: _reserving.contains(course.id),
                                onReserve: () => _reserve(course),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final Color accent;
  final bool isReserving;
  final VoidCallback onReserve;

  const _CourseCard({required this.course, required this.accent, required this.isReserving, required this.onReserve});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accent.withValues(alpha: 0.08),
          AppTheme.surface,
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: accent.withValues(alpha: 0.2), width: 1),
      boxShadow: [
        BoxShadow(
          color: accent.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 6, height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [accent, accent.withValues(alpha: 0.6)],
            ),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(course.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 16))),
                    if (course.dayOfWeek != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                        child: Text(course.dayLabel, style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                if (course.coachName != null)
                  Row(children: [
                    const Icon(Icons.person_outline, size: 13, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(course.coachName!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ]),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.schedule, size: 13, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(course.timeRange, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  if (course.location != null) ...[
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textMuted),
                    const SizedBox(width: 2),
                    Text(course.location!, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ]),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    course.isFull
                        ? GymBadge(text: 'Complet', type: BadgeType.red)
                        : GymBadge(text: '${course.spotsLeft} place${course.spotsLeft > 1 ? 's' : ''}', type: BadgeType.green),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: course.isFull || isReserving ? null : onReserve,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        child: isReserving
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                            : const Text('Réserver'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.event_busy, color: AppTheme.textMuted, size: 48),
      SizedBox(height: 12),
      Text('Aucun cours trouvé', style: TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
    ]),
  );
}

class _ErrRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrRetry({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.wifi_off_outlined, color: AppTheme.error, size: 48),
      const SizedBox(height: 12),
      Text(message, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13), textAlign: TextAlign.center),
      const SizedBox(height: 20),
      ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh, size: 16), label: const Text('Réessayer')),
    ])),
  );
}
