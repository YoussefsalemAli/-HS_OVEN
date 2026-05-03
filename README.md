# 🔥 H Oven - Flutter Web App

**Artisan Cinnamon Rolls & Cookies Store**

---

## 🚀 تشغيل المشروع محلياً

### المتطلبات
- Flutter SDK 3.0+
- Dart SDK 3.0+

### الخطوات

```bash
# 1. تثبيت المكتبات
flutter pub get

# 2. تشغيل على المتصفح
flutter run -d chrome

# 3. بناء للنشر
flutter build web --release --web-renderer html
```

---

## ⚙️ إعدادات مهمة قبل النشر

### 1. رقم الواتساب (في checkout_screen.dart)
```dart
static const String _whatsappNumber = '201XXXXXXXXX'; // ← غيّر لرقمك
static const String _instapayNumber = '01XXXXXXXXX';  // ← رقم إنستاباي
```

### 2. بيانات الأدمن (في admin_provider.dart)
```dart
static const String _adminUsername = 'admin';    // ← غيّر
static const String _adminPassword = 'hoven2024'; // ← غيّر لكلمة سر أقوى
```

---

## 🌐 النشر على Vercel

### الطريقة 1: من GitHub (مستحسن)

1. **ارفع المشروع على GitHub** (ريبو خاص private)
   ```bash
   git init
   git add .
   git commit -m "initial commit"
   git remote add origin https://github.com/username/h-oven.git
   git push -u origin main
   ```

2. **افتح [vercel.com](https://vercel.com)** وسجّل دخول

3. اضغط **"Add New Project"** → اختر الريبو

4. في إعدادات Build:
   - **Build Command:** `flutter build web --release --web-renderer html`
   - **Output Directory:** `build/web`
   - **Install Command:** اتركه فارغ

5. اضغط **Deploy** ✅

### الطريقة 2: Vercel CLI

```bash
npm i -g vercel
flutter build web --release --web-renderer html
cd build/web
vercel --prod
```

---

## 📱 مميزات الموقع

| الميزة | التفاصيل |
|--------|---------|
| 🌀 عربي RTL | كامل من اليمين لليسار |
| 🛒 سلة تسوق | إضافة/حذف/تعديل الكميات |
| 🎁 كود خصم | إضافة أكواد بنسب مختلفة |
| 🚗 توصيل | خيار توصيل أو استلام |
| 💳 دفع | كاش أو إنستاباي |
| 💬 واتساب | إرسال الطلب تلقائياً |
| 🔐 أدمن | لوحة تحكم محمية |
| ➕ منتجات | إضافة/تعديل/إخفاء المنتجات |

---

## 🔐 لوحة الأدمن

- **الدخول:** زر ⚙️ في أعلى يمين الصفحة
- **اسم المستخدم:** admin
- **كلمة المرور:** hoven2024

### ما يمكن للأدمن فعله:
- ✅ إضافة منتجات جديدة
- ✅ تعديل الأسعار
- ✅ إخفاء/إظهار منتجات
- ✅ إضافة وحذف أكواد الخصم
- ✅ تعديل سعر التوصيل

---

## 📊 حساب الأسعار

| الحجم | تكلفة المنتج | باكدج | إجمالي التكلفة | سعر البيع المقترح | ربح |
|-------|-------------|------|---------------|-----------------|-----|
| 100 جم | 31.25 ج | 7 ج | ~38 ج | 65-75 ج | ~30 ج |
| 150 جم | 46.9 ج | 8 ج | ~55 ج | 90-100 ج | ~40 ج |

*(بناءً على 800 جم = 250 جنيه)*

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                    # نقطة البداية
├── models/
│   ├── product.dart             # نموذج المنتج
│   ├── cart_item.dart           # عنصر السلة
│   ├── order.dart               # الطلب + رسالة واتساب
│   └── discount_code.dart       # كود الخصم
├── providers/
│   ├── products_provider.dart   # إدارة المنتجات
│   ├── cart_provider.dart       # إدارة السلة
│   └── admin_provider.dart      # جلسة الأدمن
├── screens/
│   ├── home_screen.dart         # الصفحة الرئيسية
│   ├── cart_screen.dart         # السلة
│   ├── checkout_screen.dart     # إتمام الطلب
│   └── admin/
│       ├── admin_login_screen.dart
│       ├── admin_dashboard_screen.dart
│       ├── edit_product_screen.dart
│       └── add_product_screen.dart
├── widgets/
│   ├── product_card.dart
│   └── cart_badge.dart
└── utils/
    └── app_theme.dart           # الألوان والثيم
```
