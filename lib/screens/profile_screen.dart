// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.0
// File: lib/screens/profile_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../services/api_key_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _statPalController = TextEditingController();
  final _geminiController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _hasStatPal = false;
  bool _hasGemini = false;
  bool _obscureStatPal = true;
  bool _obscureGemini = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final status = await ApiKeyService.instance.status();
    if (!mounted) return;
    setState(() {
      _hasStatPal = status['statpal'] ?? false;
      _hasGemini = status['gemini'] ?? false;
      _loading = false;
    });
  }

  Future<void> _saveKeys() async {
    setState(() => _saving = true);

    final statPal = _statPalController.text.trim();
    final gemini = _geminiController.text.trim();

    if (statPal.isNotEmpty) {
      await ApiKeyService.instance.saveStatPalKey(statPal);
    }
    if (gemini.isNotEmpty) {
      await ApiKeyService.instance.saveGeminiKey(gemini);
    }

    _statPalController.clear();
    _geminiController.clear();

    await _loadStatus();

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('API kulcsok mentve'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _clearKeys() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kulcsok törlése'),
        content: const Text(
          'Biztosan törölni szeretnéd az összes mentett API kulcsot?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Mégse'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Törlés'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await ApiKeyService.instance.clearAll();
    await _loadStatus();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('API kulcsok törölve')),
    );
  }

  @override
  void dispose() {
    _statPalController.dispose();
    _geminiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildStatusCard(),
                const SizedBox(height: 24),
                _buildKeysCard(),
                const SizedBox(height: 24),
                _buildAboutCard(),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: const Icon(
              Icons.person,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zsolt AI PRO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sportfogadás elemző',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'API státusz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _statusRow('StatPal', _hasStatPal),
          const SizedBox(height: 12),
          _statusRow('Gemini AI', _hasGemini),
        ],
      ),
    );
  }

  Widget _statusRow(String label, bool ok) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.cancel,
          color: ok ? AppColors.success : Colors.grey,
          size: 22,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          ok ? 'Beállítva' : 'Nincs kulcs',
          style: TextStyle(
            color: ok ? AppColors.success : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildKeysCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'API kulcsok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A kulcsok biztonságos tárhelyen mentődnek. Üres mező = nem módosít.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _statPalController,
            obscureText: _obscureStatPal,
            decoration: InputDecoration(
              labelText: 'StatPal API kulcs',
              hintText:
                  _hasStatPal ? '•••••••• (már mentve)' : 'Írd be a kulcsot',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureStatPal
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _obscureStatPal = !_obscureStatPal);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _geminiController,
            obscureText: _obscureGemini,
            decoration: InputDecoration(
              labelText: 'Gemini API kulcs',
              hintText:
                  _hasGemini ? '•••••••• (már mentve)' : 'Írd be a kulcsot',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureGemini
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _obscureGemini = !_obscureGemini);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveKeys,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Mentés'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _clearKeys,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger),
              ),
              child: const Text('Összes kulcs törlése'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Névjegy',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '\( {AppConstants.appName}  v \){AppConstants.version}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'AI alapú sportfogadás elemző alkalmazás.\n'
            'Adatok: StatPal · AI: Google Gemini',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
