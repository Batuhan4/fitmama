import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _items = <_Item>[
    _Item('Sebze & Meyve', 'Avokado', '2 adet'),
    _Item('Sebze & Meyve', 'Muz', '4 adet'),
    _Item('Sebze & Meyve', 'Ispanak', '1 demet'),
    _Item('Sebze & Meyve', 'Limon', '3 adet'),
    _Item('Protein', 'Yumurta', '15 adet'),
    _Item('Protein', 'Tavuk göğsü', '500 g'),
    _Item('Protein', 'Yunan yoğurdu', '750 g'),
    _Item('Protein', 'Somon', '300 g'),
    _Item('Tahıl & Bakliyat', 'Yulaf', '1 paket'),
    _Item('Tahıl & Bakliyat', 'Kinoa', '500 g'),
    _Item('Tahıl & Bakliyat', 'Yeşil mercimek', '500 g'),
    _Item('Atıştırmalık', 'Ceviz', '200 g'),
    _Item('Atıştırmalık', 'Badem', '200 g'),
    _Item('Atıştırmalık', 'Bitter çikolata (%70)', '1 tablet'),
  ];

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<_Item>>{};
    for (final i in _items) {
      grouped.putIfAbsent(i.category, () => []).add(i);
    }
    final remaining = _items.where((i) => !i.checked).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışveriş listesi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Liste WhatsApp\'a kopyalandı')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAdd(context),
        backgroundColor: AppPalette.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni ekle'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          FitmamaCard(
            padding: const EdgeInsets.all(14),
            gradient: LinearGradient(
              colors: [
                AppPalette.primary.withValues(alpha: 0.18),
                AppPalette.accentPurple.withValues(alpha: 0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_basket_rounded,
                    color: AppPalette.primary, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$remaining ürün listede kaldı',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final entry in grouped.entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 8, left: 4),
              child: Text(entry.key.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.6)),
            ),
            FitmamaCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < entry.value.length; i++) ...[
                    _ItemRow(
                      item: entry.value[i],
                      onToggle: () => setState(() {
                        entry.value[i].checked = !entry.value[i].checked;
                      }),
                    ),
                    if (i < entry.value.length - 1)
                      Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  void _showAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final nameCtrl = TextEditingController();
        final qtyCtrl = TextEditingController();
        String category = 'Sebze & Meyve';
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Yeni ürün',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Ürün adı', hintText: 'Örn. Salatalık'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: qtyCtrl,
                decoration: const InputDecoration(
                    labelText: 'Miktar', hintText: 'Örn. 2 adet'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: category,
                items: const [
                  DropdownMenuItem(
                      value: 'Sebze & Meyve',
                      child: Text('Sebze & Meyve')),
                  DropdownMenuItem(value: 'Protein', child: Text('Protein')),
                  DropdownMenuItem(
                      value: 'Tahıl & Bakliyat',
                      child: Text('Tahıl & Bakliyat')),
                  DropdownMenuItem(
                      value: 'Atıştırmalık', child: Text('Atıştırmalık')),
                ],
                onChanged: (v) => category = v ?? category,
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _items.add(_Item(category, nameCtrl.text.trim(),
                        qtyCtrl.text.trim()));
                  });
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Listeye ekle'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Item {
  _Item(this.category, this.name, this.qty);
  final String category;
  final String name;
  final String qty;
  bool checked = false;
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.onToggle});
  final _Item item;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.checked
                    ? AppPalette.primary
                    : Colors.transparent,
                border: Border.all(
                  color: item.checked
                      ? AppPalette.primary
                      : scheme.outline,
                  width: 2,
                ),
              ),
              child: item.checked
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  decoration: item.checked
                      ? TextDecoration.lineThrough
                      : null,
                  color: item.checked
                      ? scheme.onSurfaceVariant
                      : scheme.onSurface,
                ),
              ),
            ),
            Text(item.qty,
                style: TextStyle(
                    color: scheme.onSurfaceVariant, fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}
