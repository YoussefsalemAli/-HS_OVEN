import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/products_provider.dart';
import '../../utils/app_theme.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _emojiCtrl;
  late List<TextEditingController> _priceControllers;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product.name);
    _descCtrl = TextEditingController(text: widget.product.description);
    _emojiCtrl = TextEditingController(text: widget.product.emoji);
    _priceControllers = widget.product.sizes.map((s) => TextEditingController(text: s.price.toStringAsFixed(0))).toList();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _emojiCtrl.dispose();
    for (final c in _priceControllers) { c.dispose(); }
    super.dispose();
  }

  void _save() {
    final provider = context.read<ProductsProvider>();
    final updatedSizes = List.generate(widget.product.sizes.length, (i) {
      final price = double.tryParse(_priceControllers[i].text) ?? widget.product.sizes[i].price;
      return ProductSize(
        label: widget.product.sizes[i].label,
        weight: widget.product.sizes[i].weight,
        price: price,
        boxCost: widget.product.sizes[i].boxCost,
      );
    });

    final updated = Product(
      id: widget.product.id,
      name: _nameCtrl.text.trim().isEmpty ? widget.product.name : _nameCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? widget.product.description : _descCtrl.text.trim(),
      emoji: _emojiCtrl.text.trim().isEmpty ? widget.product.emoji : _emojiCtrl.text.trim(),
      sizes: updatedSizes,
      isAvailable: widget.product.isAvailable,
      category: widget.product.category,
    );

    provider.updateProduct(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التعديلات ✅', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightCream,
      appBar: AppBar(
        title: const Text('تعديل المنتج', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.warmBrown,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('حفظ', style: TextStyle(color: AppTheme.gold, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field('الإيموجي', _emojiCtrl, hint: '🍪'),
          const SizedBox(height: 12),
          _field('اسم المنتج', _nameCtrl),
          const SizedBox(height: 12),
          _field('الوصف', _descCtrl, maxLines: 2),
          const SizedBox(height: 20),
          const Text('الأسعار', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.darkBrown)),
          const SizedBox(height: 12),
          ...List.generate(widget.product.sizes.length, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _field('سعر ${widget.product.sizes[i].label} (جنيه)', _priceControllers[i], keyboardType: TextInputType.number),
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('حفظ التعديلات', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {String? hint, int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(labelText: label, hintText: hint),
      style: const TextStyle(fontFamily: 'Cairo'),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
