import 'package:flutter/material.dart';
import '../services/economy_service.dart';

class CoinWidget extends StatefulWidget {
  const CoinWidget({super.key});

  @override
  State<CoinWidget> createState() => _CoinWidgetState();
}

class _CoinWidgetState extends State<CoinWidget> {
  final EconomyService _economyService = EconomyService();

  @override
  void initState() {
    super.initState();
    _economyService.addListener(_onEconomyChanged);
  }

  @override
  void dispose() {
    _economyService.removeListener(_onEconomyChanged);
    super.dispose();
  }

  void _onEconomyChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000000) {
      return (number / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') + 'B';
    } else if (number >= 1000000) {
      return (number / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') + 'M';
    } else if (number >= 1000) {
      return (number / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') + 'K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amberAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amberAccent, size: 20),
          const SizedBox(width: 4),
          Text(
            _formatNumber(_economyService.coins),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
