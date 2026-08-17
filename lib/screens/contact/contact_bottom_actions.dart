import 'package:flutter/material.dart';

class ContactBottomActions extends StatelessWidget {
  final VoidCallback onGive;
  final VoidCallback onGot;

  const ContactBottomActions({
    super.key,
    required this.onGive,
    required this.onGot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: onGive,
              icon: const Icon(
                Icons.north_east_rounded,
              ),
              label: const Text('Give'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: onGot,
              icon: const Icon(
                Icons.south_west_rounded,
              ),
              label: const Text('Got'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}