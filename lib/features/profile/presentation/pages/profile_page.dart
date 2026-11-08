import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ProfileBloc>().add(
        FetchProfileEvent(
          login: authState.tokens.login,
          peanutToken: authState.tokens.peanutToken,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.sellRed),
            tooltip: 'Logout',
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return const Center(child: Text('User not authenticated'));
          }

          final tokens = authState.tokens;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileBloc>().add(
                RefreshProfileEvent(
                  login: tokens.login,
                  peanutToken: tokens.peanutToken,
                ),
              );
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileLoaded) {
                  final info = state.accountInfo;

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // User Overview Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor: AppColors.primaryLight
                                      .withValues(alpha: 0.15),
                                  child: Text(
                                    info.login.toString().substring(0, 2),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        info.name,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Account #${info.login}',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'Verified Tier 1',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.accent,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Leverage 1:${info.leverage}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Financial Balance Cards Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                context: context,
                                title: 'Balance',
                                value: '\$${info.balance.toStringAsFixed(2)}',
                                icon: Icons.account_balance_wallet_rounded,
                                color: AppColors.primaryLight,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricCard(
                                context: context,
                                title: 'Equity',
                                value: '\$${info.equity.toStringAsFixed(2)}',
                                icon: Icons.trending_up_rounded,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _buildMetricCard(
                          context: context,
                          title: 'Free Margin',
                          value: '\$${info.freeMargin.toStringAsFixed(2)}',
                          icon: Icons.shield_outlined,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(height: 20),

                        // Account Information List Section
                        Text(
                          'Personal & Security Information',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Card(
                          child: Column(
                            children: [
                              _buildInfoTile(
                                context: context,
                                icon: Icons.phone_android_rounded,
                                title: 'Registered Phone Mask',
                                value: info.phoneMask,
                                subtitle: 'Verified via Peanut Security',
                              ),
                              const Divider(height: 1, indent: 56),
                              _buildInfoTile(
                                context: context,
                                icon: Icons.location_city_rounded,
                                title: 'Location',
                                value: '${info.city}, ${info.country}',
                              ),
                              const Divider(height: 1, indent: 56),
                              _buildInfoTile(
                                context: context,
                                icon: Icons.key_rounded,
                                title: 'Peanut Token Status',
                                value: 'Active & Validated',
                                subtitle:
                                    '${tokens.peanutToken.substring(0, 8)}...',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Re-Authorization / Refresh Action
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                              FetchProfileEvent(
                                login: tokens.login,
                                peanutToken: tokens.peanutToken,
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Re-Fetch Profile Data'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is ProfileError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.sellRed,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to Load Profile',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadProfileData,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                Icon(icon, size: 20, color: color),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryLight),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to end your session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(LogoutSubmittedEvent());
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.sellRed),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
