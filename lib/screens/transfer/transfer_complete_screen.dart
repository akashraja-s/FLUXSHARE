import 'dart:io';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../mock/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import 'transfer_details_screen.dart';

class TransferCompleteScreen extends StatelessWidget {
  final FileInfo? fileInfo;
  final int receiversCount;
  final String durationText;
  final String avgSpeedText;

  const TransferCompleteScreen({
    super.key,
    this.fileInfo,
    this.receiversCount = 3,
    this.durationText = '01:52',
    this.avgSpeedText = '42 MB/s',
  });

  @override
  Widget build(BuildContext context) {
    final file = fileInfo ?? MockData.mockFiles[0]; // Project_Video.mp4, 4.8 GB

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            children: [
              const Spacer(),

              // Large monochrome checkmark icon
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlack,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.backgroundWhite,
                  size: 56,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Title
              const Text(
                'Transfer Complete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s8),

              // File details
              Text(
                '${file.name} (${file.formattedSize}) • 100%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s32),

              // Summary statistics card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.s20),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: AppShapes.cardBorderRadius,
                  border: Border.all(color: AppColors.borderGray),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      label: 'Receivers',
                      value: '$receiversCount',
                      icon: Icons.devices_rounded,
                    ),
                    Container(
                      height: 36,
                      width: 1,
                      color: AppColors.borderGray,
                    ),
                    _buildSummaryItem(
                      label: 'Duration',
                      value: durationText,
                      icon: Icons.timer_outlined,
                    ),
                    Container(
                      height: 36,
                      width: 1,
                      color: AppColors.borderGray,
                    ),
                    _buildSummaryItem(
                      label: 'Avg Speed',
                      value: avgSpeedText,
                      icon: Icons.speed_rounded,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              PrimaryButton(
                text: 'DONE',
                icon: Icons.check_rounded,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              SecondaryButton(
                text: 'CONFIRM FILE ON DISK',
                icon: Icons.verified_outlined,
                onPressed: () {
                  final physicalFile = File(file.id);
                  final exists = physicalFile.existsSync();
                  final size = exists ? physicalFile.lengthSync() : 0;

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        children: [
                          Icon(
                            exists ? Icons.check_circle_outline : Icons.error_outline,
                            color: exists ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text('File Verification'),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${file.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Path: ${file.id}', style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 8),
                          Text(
                            exists ? 'Status: Verified on Disk' : 'Status: NOT on disk',
                            style: TextStyle(
                              color: exists ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (exists) ...[
                            const SizedBox(height: 8),
                            Text('Actual size: $size bytes'),
                          ],
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              SecondaryButton(
                text: 'VIEW TRANSFER DETAILS',
                icon: Icons.bar_chart_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TransferDetailsScreen(
                        fileInfo: file,
                        durationText: durationText,
                        avgSpeedText: avgSpeedText,
                        receiversCount: receiversCount,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.darkGray),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlack,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.mediumGray,
          ),
        ),
      ],
    );
  }
}
