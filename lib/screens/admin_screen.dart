import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/menu_item.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _passCtrl = TextEditingController();
  int _tab = 0;

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();

    if (!p.adminAuth) return _LoginView(passCtrl: _passCtrl);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Admin Panel',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brown)),
              TextButton(
                onPressed: () {
                  p.logout();
                  setState(() => _tab = 0);
                },
                child: Text('Logout',
                    style: GoogleFonts.lato(
                        color: AppColors.red, fontWeight: FontWeight.w700)),
              ),
            ]),
            const SizedBox(height: 24),

            // Tab bar
            Row(children: [
              for (final entry in {
                'Dashboard': 0,
                'Items': 1,
                'Vouchers': 2,
                'Orders': 3
              }.entries)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _TabButton(
                      label: entry.key,
                      active: _tab == entry.value,
                      onTap: () => setState(() => _tab = entry.value)),
                ),
            ]),
            const SizedBox(height: 28),

            if (_tab == 0) _DashboardTab(),
            if (_tab == 1) _ItemsTab(),
            if (_tab == 2) _VouchersTab(),
            if (_tab == 3) _OrdersTab(),
          ]),
        ),
      ),
    );
  }
}

// ─── Login ────────────────────────────────────────────────────────────────────
class _LoginView extends StatelessWidget {
  final TextEditingController passCtrl;
  const _LoginView({required this.passCtrl});

  @override
  Widget build(BuildContext context) {
    final p = context.read<AppProvider>();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 60),
            const Text('🔐', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 20),
            Text('Admin Panel',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    color: AppColors.brown,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Enter your password to continue',
                style: GoogleFonts.lato(
                    fontSize: 14, color: AppColors.lightBrown)),
            const SizedBox(height: 28),
            AdminField(
                label: 'Password',
                controller: passCtrl,
                hint: '••••••••',
                obscure: true),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!p.login(passCtrl.text))
                    showAppToast(context, 'Wrong password', isError: true);
                },
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 12),
            Text('Default: hoven2025',
                style: GoogleFonts.lato(fontSize: 12, color: AppColors.sand)),
          ]),
        ),
      ),
    );
  }
}

// ─── Tab Button ───────────────────────────────────────────────────────────────
class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabButton(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: active ? AppColors.brown : Colors.transparent,
          border: Border.all(color: AppColors.brown),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: GoogleFonts.lato(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
                color: active ? AppColors.cream : AppColors.brown)),
      ),
    );
  }
}

// ─── Dashboard ────────────────────────────────────────────────────────────────
class _DashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(builder: (context, constraints) {
        final count = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: count,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.6,
          children: [
            StatCard(
                label: 'Revenue',
                value: '${p.totalRevenue} EGP',
                valueColor: AppColors.green),
            StatCard(
                label: 'Cost',
                value: '${p.totalCost} EGP',
                valueColor: AppColors.red),
            StatCard(
                label: 'Profit',
                value: '${p.totalProfit} EGP',
                valueColor: AppColors.brown),
            StatCard(
                label: 'Orders',
                value: '${p.orders.length}',
                valueColor: AppColors.darkBrown),
          ],
        );
      }),
      const SizedBox(height: 24),
      Card(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ITEM COST BREAKDOWN',
              style: GoogleFonts.lato(
                  fontSize: 11,
                  color: AppColors.lightBrown,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Base: 800g = 230 EGP',
              style:
                  GoogleFonts.lato(fontSize: 13, color: AppColors.lightBrown)),
          const SizedBox(height: 16),
          Wrap(
              spacing: 10,
              runSpacing: 10,
              children: p.items
                  .map((item) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                            color: AppColors.softCream,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${item.emoji} ${item.name}',
                                  style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.darkBrown)),
                              const SizedBox(height: 4),
                              Text('Cost: ~${item.costPrice} EGP',
                                  style: GoogleFonts.lato(
                                      fontSize: 12, color: AppColors.red)),
                              Text('Price: ${item.price} EGP',
                                  style: GoogleFonts.lato(
                                      fontSize: 12, color: AppColors.green)),
                              Text('Margin: ${item.margin} EGP',
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.brown)),
                            ]),
                      ))
                  .toList()),
        ]),
      )),
    ]);
  }
}

// ─── Items ────────────────────────────────────────────────────────────────────
class _ItemsTab extends StatefulWidget {
  @override
  State<_ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<_ItemsTab> {
  MenuItem? _editing;

  // New item form
  final _nameC = TextEditingController();
  final _descC = TextEditingController();
  final _weightC = TextEditingController();
  final _priceC = TextEditingController();
  final _origC = TextEditingController();
  final _emojiC = TextEditingController(text: '🍪');

  @override
  void dispose() {
    _nameC.dispose();
    _descC.dispose();
    _weightC.dispose();
    _priceC.dispose();
    _origC.dispose();
    _emojiC.dispose();
    super.dispose();
  }

  void _addItem(AppProvider p) {
    if (_nameC.text.isEmpty || _priceC.text.isEmpty || _weightC.text.isEmpty) {
      showAppToast(context, 'Fill required fields', isError: true);
      return;
    }
    p.addItem(MenuItem(
      id: p.nextItemId,
      name: _nameC.text,
      description: _descC.text,
      weight: _weightC.text,
      price: int.tryParse(_priceC.text) ?? 0,
      originalPrice: _origC.text.isEmpty ? null : int.tryParse(_origC.text),
      emoji: _emojiC.text.isEmpty ? '🍪' : _emojiC.text,
    ));
    _nameC.clear();
    _descC.clear();
    _weightC.clear();
    _priceC.clear();
    _origC.clear();
    _emojiC.text = '🍪';
    showAppToast(context, 'Item added!');
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Edit dialog (inline)
      if (_editing != null)
        _EditItemCard(
          item: _editing!,
          onSave: (updated) {
            p.updateItem(updated);
            setState(() => _editing = null);
            showAppToast(context, 'Item updated!');
          },
          onCancel: () => setState(() => _editing = null),
        ),

      // Item list
      ...p.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Opacity(
              opacity: item.isActive ? 1 : 0.5,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(children: [
                          Text(item.name,
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkBrown)),
                          const SizedBox(width: 8),
                          if (item.originalPrice != null) const SaleBadge(),
                          if (!item.isActive) ...[
                            const SizedBox(width: 8),
                            Text('Hidden',
                                style: GoogleFonts.lato(
                                    fontSize: 11, color: AppColors.sand)),
                          ],
                        ]),
                        Text(
                          '${item.weight} · ${item.price} EGP${item.originalPrice != null ? ' (was ${item.originalPrice})' : ''}',
                          style: GoogleFonts.lato(
                              fontSize: 13, color: AppColors.lightBrown),
                        ),
                      ])),
                  Row(children: [
                    _SmallBtn(
                        label: 'Edit',
                        onTap: () =>
                            setState(() => _editing = item.copyWith())),
                    const SizedBox(width: 8),
                    _SmallBtn(
                        label: item.isActive ? 'Hide' : 'Show',
                        onTap: () => p.toggleItem(item.id)),
                  ]),
                ]),
              )),
            ),
          )),

      const SizedBox(height: 8),

      // Add new
      Card(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ADD NEW ITEM',
              style: GoogleFonts.lato(
                  fontSize: 11,
                  color: AppColors.lightBrown,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: AdminField(
                    label: 'Name *', controller: _nameC, hint: 'Box name')),
            const SizedBox(width: 12),
            SizedBox(
                width: 100,
                child: AdminField(
                    label: 'Emoji', controller: _emojiC, hint: '🍪')),
          ]),
          const SizedBox(height: 12),
          AdminField(
              label: 'Description',
              controller: _descC,
              hint: 'Short description'),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: AdminField(
                    label: 'Weight *', controller: _weightC, hint: '300g')),
            const SizedBox(width: 12),
            Expanded(
                child: AdminField(
                    label: 'Price (EGP) *',
                    controller: _priceC,
                    hint: '249',
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(
                child: AdminField(
                    label: 'Original Price (sale)',
                    controller: _origC,
                    hint: 'Optional',
                    keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () => _addItem(p), child: const Text('+ Add Item')),
        ]),
      )),
    ]);
  }
}

class _EditItemCard extends StatefulWidget {
  final MenuItem item;
  final ValueChanged<MenuItem> onSave;
  final VoidCallback onCancel;
  const _EditItemCard(
      {required this.item, required this.onSave, required this.onCancel});

  @override
  State<_EditItemCard> createState() => _EditItemCardState();
}

class _EditItemCardState extends State<_EditItemCard> {
  late TextEditingController _name, _desc, _weight, _price, _orig, _emoji;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.item.name);
    _desc = TextEditingController(text: widget.item.description);
    _weight = TextEditingController(text: widget.item.weight);
    _price = TextEditingController(text: widget.item.price.toString());
    _orig = TextEditingController(
        text: widget.item.originalPrice?.toString() ?? '');
    _emoji = TextEditingController(text: widget.item.emoji);
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _weight.dispose();
    _price.dispose();
    _orig.dispose();
    _emoji.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.softCream,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('EDITING: ${widget.item.name}',
              style: GoogleFonts.lato(
                  fontSize: 11,
                  color: AppColors.brown,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: AdminField(label: 'Name', controller: _name)),
            const SizedBox(width: 12),
            SizedBox(
                width: 100,
                child: AdminField(label: 'Emoji', controller: _emoji)),
          ]),
          const SizedBox(height: 12),
          AdminField(label: 'Description', controller: _desc),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: AdminField(label: 'Weight', controller: _weight)),
            const SizedBox(width: 12),
            Expanded(
                child: AdminField(
                    label: 'Price (EGP)',
                    controller: _price,
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(
                child: AdminField(
                    label: 'Original Price (sale)',
                    controller: _orig,
                    hint: 'Empty = no sale',
                    keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            ElevatedButton(
              onPressed: () => widget.onSave(widget.item.copyWith(
                name: _name.text,
                description: _desc.text,
                weight: _weight.text,
                price: int.tryParse(_price.text) ?? widget.item.price,
                originalPrice:
                    _orig.text.isEmpty ? null : int.tryParse(_orig.text),
                clearOriginalPrice: _orig.text.isEmpty,
                emoji: _emoji.text,
              )),
              child: const Text('Save Changes'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
                onPressed: widget.onCancel, child: const Text('Cancel')),
          ]),
        ]),
      ),
    );
  }
}

// ─── Vouchers ─────────────────────────────────────────────────────────────────
class _VouchersTab extends StatefulWidget {
  @override
  State<_VouchersTab> createState() => _VouchersTabState();
}

class _VouchersTabState extends State<_VouchersTab> {
  final _codeC = TextEditingController();
  final _discC = TextEditingController();
  String _type = 'percent';

  @override
  void dispose() {
    _codeC.dispose();
    _discC.dispose();
    super.dispose();
  }

  void _add(AppProvider p) {
    if (_codeC.text.isEmpty || _discC.text.isEmpty) {
      showAppToast(context, 'Fill all fields', isError: true);
      return;
    }
    p.addVoucher(Voucher(
        code: _codeC.text.trim().toUpperCase(),
        discount: double.tryParse(_discC.text) ?? 0,
        type: _type));
    _codeC.clear();
    _discC.clear();
    showAppToast(context, 'Voucher added!');
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    return Column(children: [
      ...p.vouchers.map((v) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.softCream,
                    border: Border.all(
                        color: AppColors.sand,
                        style: BorderStyle.solid,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(v.code,
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brown,
                          letterSpacing: 2)),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: Text(v.label,
                        style: GoogleFonts.lato(
                            fontSize: 14, color: AppColors.darkBrown))),
                if (!v.isActive)
                  Text('Inactive',
                      style: GoogleFonts.lato(
                          fontSize: 12, color: AppColors.sand)),
                const SizedBox(width: 10),
                _SmallBtn(
                    label: v.isActive ? 'Deactivate' : 'Activate',
                    onTap: () => p.toggleVoucher(v.code)),
                const SizedBox(width: 8),
                _SmallBtn(
                    label: 'Delete',
                    danger: true,
                    onTap: () => p.deleteVoucher(v.code)),
              ]),
            )),
          )),
      Card(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ADD VOUCHER',
              style: GoogleFonts.lato(
                  fontSize: 11,
                  color: AppColors.lightBrown,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: AdminField(
                    label: 'Code', controller: _codeC, hint: 'SUMMER10')),
            const SizedBox(width: 12),
            Expanded(
                child: AdminField(
                    label: 'Discount',
                    controller: _discC,
                    hint: '10',
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('TYPE',
                      style: GoogleFonts.lato(
                          fontSize: 11,
                          color: AppColors.lightBrown,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(),
                    items: const [
                      DropdownMenuItem(
                          value: 'percent', child: Text('Percent (%)')),
                      DropdownMenuItem(
                          value: 'fixed', child: Text('Fixed (EGP)')),
                    ],
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ])),
          ]),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () => _add(p), child: const Text('+ Add Voucher')),
        ]),
      )),
    ]);
  }
}

// ─── Orders ───────────────────────────────────────────────────────────────────
class _OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = context.watch<AppProvider>().orders.reversed.toList();
    return Column(
      children: orders
          .map((o) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(o.id,
                                        style: GoogleFonts.lato(
                                            fontSize: 11,
                                            color: AppColors.lightBrown,
                                            letterSpacing: 1.5)),
                                    Text(o.name,
                                        style: GoogleFonts.playfairDisplay(
                                            fontSize: 18,
                                            color: AppColors.darkBrown)),
                                    Text('${o.date} · ${o.payment}',
                                        style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: AppColors.sand)),
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${o.total} EGP',
                                        style: GoogleFonts.playfairDisplay(
                                            fontSize: 20,
                                            color: AppColors.brown)),
                                    Text('Cost: ${o.cost} EGP',
                                        style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: AppColors.red)),
                                    Text('Profit: ${o.profit} EGP',
                                        style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.green)),
                                  ]),
                            ]),
                        const SizedBox(height: 12),
                        Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: o.items
                                .map((it) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: AppColors.softCream,
                                          border: Border.all(
                                              color: AppColors.border),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(it,
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: AppColors.brown)),
                                    ))
                                .toList()),
                      ]),
                )),
              ))
          .toList(),
    );
  }
}

// ─── Helper ───────────────────────────────────────────────────────────────────
class _SmallBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool danger;
  const _SmallBtn(
      {required this.label, required this.onTap, this.danger = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: danger ? AppColors.red : AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label,
            style: GoogleFonts.lato(
                fontSize: 12,
                color: danger ? AppColors.red : AppColors.brown,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}
