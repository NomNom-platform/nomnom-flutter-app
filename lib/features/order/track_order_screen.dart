import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Simulated Map Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder for map image
                  Opacity(
                    opacity: 0.1,
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC949o5b2i1hUPhkcx3-_oSYmcjKxqD0DyQnnr2lB0EcCsU_dKjWCHg-X44aTmbOarkd2a8a0OZIIzaAyXbBKyr7TZyJMl-J1NU_CmZQnpVTK0ZzVFgNEEX09tKOWLCYQUuYAhLQ-HcEnEFXOAseqGkBBMWOGu6EWNTAK6zqXQ62fg-K7sHydaBHzCeuqHleMCeestj5WkiWMejyCcdK5yFAWzt3c8o56eyGBpb4Q1NM7o8PoFv_-7ob3yyiCV9uKOoCPzMcflUIBUa',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Mock Car Marker
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: theme.colorScheme.primary.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)
                      ]
                    ),
                    child: Icon(Icons.directions_car, color: theme.colorScheme.onPrimary),
                  )
                ],
              ),
            ),
          ),
          
          // AppBar (Transparent)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
              elevation: 0,
              leading: BackButton(onPressed: () => context.go('/home')),
              title: Text('Track Order #12345', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {},
                )
              ],
            ),
          ),
          
          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, -8))
                ]
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(width: 48, height: 6, decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 24),
                  
                  Text('ESTIMATED ARRIVAL', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, letterSpacing: 1.2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('15-20', style: theme.textTheme.displayLarge?.copyWith(color: theme.colorScheme.primary)),
                      const SizedBox(width: 8),
                      Text('min', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary)),
                    ],
                  ),
                  Text('Driver is heading to the restaurant', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  
                  const Padding(padding: EdgeInsets.all(24), child: Divider()),
                  
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      children: [
                        _TrackingStep(
                          title: 'Order Pending', subtitle: 'Order received by system', time: '12:30 PM',
                          isCompleted: true, isActive: false, icon: Icons.check,
                        ),
                        _TrackingStep(
                          title: 'Order Confirmed', subtitle: 'Restaurant accepted your order', time: '12:32 PM',
                          isCompleted: true, isActive: false, icon: Icons.check,
                        ),
                        _TrackingStep(
                          title: 'Preparing', subtitle: 'Your food is being made with care', time: '',
                          isCompleted: false, isActive: true, icon: Icons.soup_kitchen,
                        ),
                        _TrackingStep(
                          title: 'Ready for Pickup', subtitle: 'Waiting for delivery partner', time: '',
                          isCompleted: false, isActive: false, icon: Icons.local_mall, isLast: true, // simplified for demo
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TrackingStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isCompleted;
  final bool isActive;
  final IconData icon;
  final bool isLast;

  const _TrackingStep({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isCompleted,
    required this.isActive,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? theme.colorScheme.primary : (isCompleted ? theme.colorScheme.secondary : theme.colorScheme.surfaceVariant),
                  ),
                  child: Icon(icon, size: 14, color: isActive ? theme.colorScheme.onPrimary : (isCompleted ? theme.colorScheme.onSecondary : theme.colorScheme.onSurfaceVariant)),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted ? theme.colorScheme.secondary : theme.colorScheme.surfaceVariant,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isActive ? theme.colorScheme.primary : (isCompleted ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                ],
              ),
            ),
          ),
          if (time.isNotEmpty)
            Text(time, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))
        ],
      ),
    );
  }
}
