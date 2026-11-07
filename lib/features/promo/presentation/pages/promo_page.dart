import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/promo_bloc.dart';
import '../bloc/promo_event.dart';
import '../bloc/promo_state.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  @override
  void initState() {
    super.initState();
    context.read<PromoBloc>().add(FetchPromoEvent());
  }

  Future<void> _launchExternalUrl(BuildContext context, String urlString) async {
    final Uri? uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch URL: $urlString'),
            backgroundColor: AppColors.sellRed,
          ),
        );
      }
    }
  }

  Color _parseHexColor(String hexString) {
    try {
      final cleanHex = hexString.replaceAll('#', '').trim();
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      }
    } catch (_) {}
    return AppColors.primaryLight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo Materials'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Promo Materials',
            onPressed: () {
              context.read<PromoBloc>().add(RefreshPromoEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<PromoBloc, PromoState>(
        builder: (context, state) {
          if (state is PromoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PromoLoaded) {
            if (state.promos.isEmpty) {
              return Center(
                child: Text(
                  'No promo materials available.',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PromoBloc>().add(RefreshPromoEvent());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.promos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final promo = state.promos[index];
                  final btnColor = _parseHexColor(promo.buttonColor);

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Promo Graphic Header Image
                        if (promo.imageUrl.isNotEmpty)
                          AspectRatio(
                            aspectRatio: 16 / 7,
                            child: Image.network(
                              promo.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: btnColor.withOpacity(0.12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.card_giftcard_rounded,
                                        size: 40,
                                        color: btnColor,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'InstaForex Campaign',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: btnColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              },
                            ),
                          ),

                        // Promo Details & CTA
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo.text,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 16),

                              ElevatedButton(
                                onPressed: () => _launchExternalUrl(context, promo.link),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: btnColor,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(46),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      promo.buttonText,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.open_in_new_rounded, size: 18),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (state is PromoError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 56, color: AppColors.sellRed),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to Load Promo Materials',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<PromoBloc>().add(FetchPromoEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
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
  }
}
