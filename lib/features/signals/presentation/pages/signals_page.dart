import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/signals_bloc.dart';
import '../bloc/signals_event.dart';
import '../bloc/signals_state.dart';

class SignalsPage extends StatefulWidget {
  const SignalsPage({super.key});

  @override
  State<SignalsPage> createState() => _SignalsPageState();
}

class _SignalsPageState extends State<SignalsPage> {
  @override
  void initState() {
    super.initState();
    _triggerFetch();
  }

  void _triggerFetch() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final blocState = context.read<SignalsBloc>().state;
      context.read<SignalsBloc>().add(
            FetchSignalsEvent(
              login: authState.tokens.login,
              partnerToken: authState.tokens.partnerToken,
              pairs: blocState.selectedPairs,
              fromDate: blocState.fromDate,
              toDate: blocState.toDate,
            ),
          );
    }
  }

  Future<void> _pickDateRange() async {
    final blocState = context.read<SignalsBloc>().state;
    final initialRange = DateTimeRange(
      start: blocState.fromDate,
      end: blocState.toDate,
    );

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryLight,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      if (mounted) {
        context.read<SignalsBloc>().add(
              SelectDateRangeEvent(
                fromDate: pickedRange.start,
                toDate: pickedRange.end,
              ),
            );
        _triggerFetch();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading Signals Archive'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Date Range Filter',
            onPressed: _pickDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Signals',
            onPressed: _triggerFetch,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Header Bar (Currency Pairs & Date Range)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: isDark ? AppColors.cardDark : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pair Chips Scrollable List
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ApiConstants.defaultCurrencyPairs.map((pair) {
                      final isSelected = context.select<SignalsBloc, bool>(
                        (bloc) => bloc.state.selectedPairs.contains(pair),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(pair),
                          selected: isSelected,
                          onSelected: (_) {
                            context.read<SignalsBloc>().add(TogglePairFilterEvent(pair));
                            _triggerFetch();
                          },
                          selectedColor: AppColors.primaryLight,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),

                // Selected Date Range Banner
                BlocBuilder<SignalsBloc, SignalsState>(
                  builder: (context, state) {
                    final dateFormat = DateFormat('dd MMM yyyy');
                    return InkWell(
                      onTap: _pickDateRange,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Range: ${dateFormat.format(state.fromDate)} - ${dateFormat.format(state.toDate)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 18,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main List Content Body
          Expanded(
            child: BlocBuilder<SignalsBloc, SignalsState>(
              builder: (context, state) {
                if (state is SignalsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SignalsLoaded) {
                  if (state.signals.isEmpty) {
                    return _buildEmptyState(theme, isDark);
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _triggerFetch(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.signals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final signal = state.signals[index];
                        return _buildSignalCard(context, signal, isDark);
                      },
                    ),
                  );
                } else if (state is SignalsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.sellRed),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to Load Signals',
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
                            onPressed: _triggerFetch,
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
          ),
        ],
      ),
    );
  }

  Widget _buildSignalCard(BuildContext context, dynamic signal, bool isDark) {
    final theme = Theme.of(context);
    final isBuy = signal.action.contains('BUY');
    final actionColor = isBuy ? AppColors.buyGreen : AppColors.sellRed;
    final timeFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Pair & Action Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: actionColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isBuy ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: actionColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signal.pair,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          timeFormat.format(signal.dateTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: actionColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: actionColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    signal.action,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: actionColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Price Details Row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPriceItem('Entry Price', signal.price.toStringAsFixed(4)),
                  if (signal.takeProfit != null)
                    _buildPriceItem('Take Profit', signal.takeProfit!.toStringAsFixed(4), color: AppColors.buyGreen),
                  if (signal.stopLoss != null)
                    _buildPriceItem('Stop Loss', signal.stopLoss!.toStringAsFixed(4), color: AppColors.sellRed),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Analyst Comment
            Text(
              signal.comment,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.query_stats_rounded,
              size: 64,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No Signals Found',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your currency pair selections or date range filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
