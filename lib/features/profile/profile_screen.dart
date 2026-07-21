import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../shared/widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';
import '../auth/presentation/controllers/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authControllerProvider.notifier).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final profile = authState.profile;
    final healthAsync = ref.watch(healthMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Hồ sơ của tôi', 
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 22, 
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded, color: theme.colorScheme.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Hero Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04), 
                    blurRadius: 20, 
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(120)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.primaryContainer, width: 2),
                        ),
                        child: const ClipOval(child: UserAvatar(radius: 38)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.fullName ?? (authState.isLoading ? 'Đang tải...' : 'Khách'),
                              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              profile?.email ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star_rounded, size: 14, color: theme.colorScheme.onSecondaryContainer),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Premium Member', 
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontSize: 11, 
                                      color: theme.colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // --- ⚖️ Banner Nhắc Nhở Cập Nhật Cân Nặng Định Kỳ (chỉ hiện khi thiếu data sức khỏe) ---
            if (profile?.height == null || profile?.weight == null) ...[  
              _buildWeightReminderBanner(theme),
              const SizedBox(height: 20),
            ],
            
            // Health Goal Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.surface, theme.colorScheme.tertiaryFixed.withValues(alpha: 0.15)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.tertiaryFixedDim.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.monitor_weight_rounded, color: theme.colorScheme.tertiary),
                      const SizedBox(width: 8),
                      Text('Mục tiêu sức khỏe', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mức độ vận động', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              const SizedBox(height: 2),
                              Text(
                                profile?.activityLevel?.replaceAll('_', ' ') ?? '—',
                                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Chỉ số BMI hiện tại', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              const SizedBox(height: 2),
                              healthAsync.when(
                                data: (health) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(health.bmi.toStringAsFixed(1), style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        health.bmiCategory, 
                                        style: theme.textTheme.labelMedium?.copyWith(fontSize: 10, color: theme.colorScheme.secondary, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                loading: () => Text('—', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16)),
                                error: (_, __) => Text('N/A', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  healthAsync.when(
                    data: (health) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Định mức Calo đề xuất', 
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'TDEE ${health.tdee.toStringAsFixed(0)} kcal • Ngày ${health.calorieGoal.toStringAsFixed(0)} kcal',
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // --- 📊 Custom Macro Indicator (Protein - Carb - Fat) ---
                        const Text(
                          'Phân bổ dinh dưỡng đa lượng (Macros):',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildMacroIndicatorBar(theme),
                      ],
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Settings List Grid
            _SettingsItem(
              icon: Icons.person_rounded,
              iconColor: theme.colorScheme.primary,
              iconBgColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              title: 'Thông tin cá nhân',
              subtitle: 'Họ tên, Số điện thoại, Mật khẩu',
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.push('/health-setup'),
              child: _SettingsItem(
                icon: Icons.monitor_heart_rounded,
                iconColor: theme.colorScheme.secondary,
                iconBgColor: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
                title: 'Dữ liệu sức khỏe',
                subtitle: 'Dinh dưỡng, Dị ứng, Sở thích ăn uống',
              ),
            ),
            const SizedBox(height: 12),
            _SettingsItem(
              icon: Icons.location_on_rounded,
              iconColor: theme.colorScheme.onSurfaceVariant,
              iconBgColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              title: 'Địa chỉ đã lưu',
              subtitle: 'Nhà riêng, Văn phòng, Khác',
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.push('/order-history'),
              child: _SettingsItem(
                icon: Icons.receipt_long_rounded,
                iconColor: theme.colorScheme.onSurfaceVariant,
                iconBgColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                title: 'Lịch sử đơn hàng',
                subtitle: 'Các món ăn và hóa đơn trước đây',
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.push('/owner/dashboard'),
              child: _SettingsItem(
                icon: Icons.storefront_rounded,
                iconColor: theme.colorScheme.primary,
                iconBgColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                title: 'Chế độ chủ quán',
                subtitle: 'Quản lý doanh thu và thực đơn',
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
                icon: Icon(Icons.logout_rounded, color: theme.colorScheme.onErrorContainer),
                label: Text('Đăng xuất tài khoản', style: TextStyle(color: theme.colorScheme.onErrorContainer, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer.withValues(alpha: 0.25),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/for-you');
          if (index == 2) context.go('/cart');
          if (index == 3) context.go('/inbox');
        }
      ),
    );
  }

  // Tiện ích vẽ thanh phân bổ Macro dinh dưỡng (Protein 30%, Carb 50%, Fat 20%)
  Widget _buildMacroIndicatorBar(ThemeData theme) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                Expanded(flex: 30, child: Container(color: Colors.orange[700])), // Protein
                Expanded(flex: 50, child: Container(color: Colors.blue[600])), // Carb
                Expanded(flex: 20, child: Container(color: Colors.red[500])), // Fat
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Chú giải dinh dưỡng
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMacroLabel('Đạm (Protein)', '30%', Colors.orange[700]!),
            _buildMacroLabel('Đường bột (Carb)', '50%', Colors.blue[600]!),
            _buildMacroLabel('Chất béo (Fat)', '20%', Colors.red[500]!),
          ],
        )
      ],
    );
  }

  Widget _buildMacroLabel(String label, String pct, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: ', 
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          pct, 
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Tiện ích vẽ thẻ nhắc nhở cân nặng định kỳ
  Widget _buildWeightReminderBanner(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.scale_rounded, color: Colors.amber[800], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đã đến lúc cập nhật cân nặng!', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber[900]),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Cập nhật định kỳ giúp AI tính toán calo & đề xuất món ăn tối ưu nhất.', 
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.push('/health-setup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Cập nhật', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4))
        ]
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
