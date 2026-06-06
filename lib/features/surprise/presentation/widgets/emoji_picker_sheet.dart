import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

const _categories = [
  (label: 'Fêtes', emojis: ['🎉', '🎊', '🎈', '🥳', '🎁', '🎀', '🎂', '🍾', '🥂', '🎆', '🎇', '✨']),
  (label: 'Voyages', emojis: ['✈️', '🏖️', '🏝️', '🏔️', '🗺️', '🚢', '🚂', '🏕️', '🌅', '🌍', '🗼', '🎡']),
  (label: 'Musique', emojis: ['🎵', '🎶', '🎸', '🎹', '🎺', '🎻', '🥁', '🎤', '🎧', '🎼', '🎙️', '🪗']),
  (label: 'Gastronomie', emojis: ['🍽️', '🍷', '🥐', '🍣', '🥗', '🍰', '🧁', '🫶', '🍫', '☕', '🍕', '🥩']),
  (label: 'Activités', emojis: ['🎭', '🎨', '🎬', '🎮', '⚽', '🎾', '🏊', '🧗', '🎯', '🏇', '🎠', '🎪']),
  (label: 'Nature', emojis: ['🌸', '🌻', '🌙', '⭐', '🌈', '🦋', '🌿', '🌊', '🍀', '🦚', '🌺', '🐬']),
  (label: 'Amour', emojis: ['❤️', '💌', '💐', '💍', '🥰', '😍', '💑', '👫', '🫂', '💕', '🌹', '💝']),
];

class EmojiPickerSheet extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const EmojiPickerSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<EmojiPickerSheet> createState() => _EmojiPickerSheetState();
}

class _EmojiPickerSheetState extends State<EmojiPickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.52,
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Choisir un emoji',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 18),
                ),
                const Spacer(),
                if (widget.selected.isNotEmpty)
                  Text(widget.selected,
                      style: const TextStyle(fontSize: 28)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppTheme.primaryLight,
            indicatorWeight: 2,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textLight,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            dividerColor: AppTheme.divider,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: _categories
                .map((c) => Tab(text: c.label))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: category.emojis.length,
                  itemBuilder: (context, index) {
                    final emoji = category.emojis[index];
                    final isSelected = emoji == widget.selected;
                    return GestureDetector(
                      onTap: () {
                        widget.onSelected(emoji);
                        Navigator.pop(context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.accentLight.withValues(alpha: 0.4)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryLight
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
