import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_supabase_w_flutter/models/who_are_you.dart';
import '../providers/public_data_provider.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whoAreYousAsync = ref.watch(whoAreYousProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFB2DFDB),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ========== HEADER ==========
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(Icons.people_alt_rounded, size: 64, color: Color(0xFF00695C)),
                    SizedBox(height: 12),
                    Text('So, tell me...', style: TextStyle(fontSize: 18, color: Color(0xFF004D40), letterSpacing: 1.2)),
                    Text('Who are you?', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF004D40), letterSpacing: 0.5)),
                    SizedBox(height: 8),
                    Divider(color: Color(0xFF80CBC4), thickness: 2, indent: 60, endIndent: 60),
                  ],
                ),
              ),

              // ========== CONTENT ==========
              Expanded(
                child: whoAreYousAsync.when(
                  loading: () => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF00695C)),
                        SizedBox(height: 16),
                        Text('Loading people...', style: TextStyle(color: Color(0xFF004D40), fontSize: 16)),
                      ],
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                          const SizedBox(height: 12),
                          Text('Oops! Something went wrong', style: TextStyle(color: Colors.red.shade700, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(error.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade600, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  data: (people) {
                    if (people.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Color(0xFF80CBC4)),
                            SizedBox(height: 16),
                            Text('No one is here yet...', style: TextStyle(fontSize: 18, color: Color(0xFF004D40), fontWeight: FontWeight.w500)),
                            SizedBox(height: 8),
                            Text('Add some people to your database!', style: TextStyle(fontSize: 14, color: Color(0xFF80CBC4))),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: people.length,
                      itemBuilder: (context, index) {
                        final person = people[index];
                        return _buildPersonCard(context, person); // ✅ passes context
                      },
                    );
                  },
                ),
              ),

              // ========== FOOTER ==========
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '✨ ${DateTime.now().year} • Made with 💚',
                  style: const TextStyle(color: Color(0xFF004D40), fontSize: 12, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== HELPER: BUILD PERSON CARD ==========
  Widget _buildPersonCard(BuildContext context, WhoAreYou person) { // ✅ context parameter added
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85), // ✅ withValues instead of withOpacity
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06), // ✅ withValues instead of withOpacity
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showPersonDialog(context, person); // ✅ passes context + person
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _getAvatarColor(person.id),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      person.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Oh, hi! I am ${person.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF004D40))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.work_outline, size: 16, color: Color(0xFF00695C)),
                          const SizedBox(width: 6),
                          Text('a ${person.occupation}', style: const TextStyle(fontSize: 15, color: Color(0xFF00695C))),
                        ],
                      ),
                      if (person.createdAt != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 12, color: Color(0xFF80CBC4)),
                            const SizedBox(width: 4),
                            Text('Member since ${_formatDate(person.createdAt!)}', style: const TextStyle(fontSize: 11, color: Color(0xFF80CBC4))),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF80CBC4)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== HELPER: AVATAR COLORS ==========
  Color _getAvatarColor(int id) {
    const colors = [
      Color(0xFF00695C),
      Color(0xFF2E7D32),
      Color(0xFF00838F),
      Color(0xFF4A148C),
      Color(0xFFBF360C),
      Color(0xFF0D47A1),
    ];
    return colors[id % colors.length];
  }

  // ========== HELPER: FORMAT DATE ==========
  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }

  // ========== HELPER: SHOW PERSON DIALOG ==========
  void _showPersonDialog(BuildContext context, WhoAreYou person) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getAvatarColor(person.id),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  person.name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(person.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF004D40))),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow('Occupation', person.occupation),
            if (person.createdAt != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow('Member Since', _formatDate(person.createdAt!)),
            ],
            const SizedBox(height: 8),
            _buildDetailRow('ID', '#${person.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF80CBC4), fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF004D40), fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}