import 'package:flutter/material.dart';
import '../models/mail_model.dart';
import '../services/mail_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../widgets/glass_container.dart';

class MailboxDialog extends StatefulWidget {
  const MailboxDialog({super.key});

  @override
  State<MailboxDialog> createState() => _MailboxDialogState();
}

class _MailboxDialogState extends State<MailboxDialog> {
  final MailService _mailService = MailService();

  @override
  void initState() {
    super.initState();
    _mailService.addListener(_onMailChanged);
  }

  @override
  void dispose() {
    _mailService.removeListener(_onMailChanged);
    super.dispose();
  }

  void _onMailChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final mails = _mailService.mails;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 600),
        child: GlassContainer(
          borderRadius: 16,
          padding: EdgeInsets.zero,
          width: double.infinity,
          child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.mailboxTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      if (mails.any((m) => !m.isClaimed && m.rewards.isNotEmpty))
                        ElevatedButton(
                          onPressed: () async {
                            await _mailService.claimAll();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.mailboxAllRewardsClaimed)),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 32),
                          ),
                          child: Text(AppLocalizations.of(context)!.mailboxClaimAll),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            // Mail List
            Expanded(
              child: mails.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.mailboxEmpty,
                        style: const TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: mails.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildMailItem(mails[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildMailItem(MailModel mail) {
    final dateFormat = DateFormat('yyyy.MM.dd');
    final hasRewards = mail.rewards.isNotEmpty;

    return InkWell(
      onTap: () {
        if (!mail.isRead) {
          _mailService.markAsRead(mail);
        }
        // Expand to show content
        showDialog(
          context: context,
          builder: (context) => _MailDetailDialog(mail: mail),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: mail.isRead ? Colors.black26 : Colors.black45,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: mail.isRead ? Colors.transparent : Colors.purpleAccent.withOpacity(0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              hasRewards ? Icons.card_giftcard : Icons.mail,
              color: mail.isRead ? Colors.white54 : Colors.amberAccent,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mail.title,
                    style: TextStyle(
                      color: mail.isRead ? Colors.white70 : Colors.white,
                      fontSize: 16,
                      fontWeight: mail.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.mailboxSenderAndDate(mail.sender, dateFormat.format(mail.timestamp)),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (hasRewards)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (mail.isClaimed)
                    Text(
                      AppLocalizations.of(context)!.mailboxClaimed,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    )
                  else
                    ElevatedButton(
                      onPressed: () async {
                        await _mailService.claimReward(mail);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 32),
                      ),
                      child: Text(AppLocalizations.of(context)!.mailboxClaim),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _MailDetailDialog extends StatelessWidget {
  final MailModel mail;
  
  const _MailDetailDialog({required this.mail});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');
    final hasRewards = mail.rewards.isNotEmpty;

    return Dialog(
      backgroundColor: const Color(0xFF1E1136),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    mail.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Text(
              AppLocalizations.of(context)!.mailboxSenderAndDate(mail.sender, dateFormat.format(mail.timestamp)),
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  mail.content,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            if (hasRewards) ...[
              const SizedBox(height: 24),
              Text(AppLocalizations.of(context)!.mailboxAttachedRewards, style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: mail.rewards.entries.map((entry) {
                  IconData icon;
                  Color iconColor;
                  if (entry.key == 'coins') {
                    icon = Icons.monetization_on;
                    iconColor = Colors.amberAccent;
                  } else {
                    icon = Icons.blur_on;
                    iconColor = Colors.purpleAccent;
                  }
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: iconColor, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '+${entry.value}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              if (!mail.isClaimed)
                ElevatedButton(
                  onPressed: () async {
                    await MailService().claimReward(mail);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.mailboxRewardClaimed)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: Text(AppLocalizations.of(context)!.mailboxClaimReward, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                )
              else
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(AppLocalizations.of(context)!.mailboxClaimed, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
