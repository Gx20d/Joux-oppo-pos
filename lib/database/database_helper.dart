import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  DatabaseHelper._();

  static final DatabaseHelper instance =
      DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;

  }

  Future<Database> _initDatabase() async {

    Directory directory =
        await getApplicationDocumentsDirectory();

    String path = join(
      directory.path,
      "joux_oppo.db",
    );

    return await openDatabase(

      path,

      version: 1,

      onCreate: _onCreate,

    );

  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {

    await db.execute("""

CREATE TABLE products(

id INTEGER PRIMARY KEY AUTOINCREMENT,

name TEXT NOT NULL,

brand TEXT,

quantity INTEGER DEFAULT 0,

buy_price REAL DEFAULT 0,

sell_price REAL DEFAULT 0,

barcode TEXT,

notes TEXT

)

""");

    await db.execute("""

CREATE TABLE customers(

id INTEGER PRIMARY KEY AUTOINCREMENT,

name TEXT NOT NULL,

phone TEXT,

address TEXT,

notes TEXT

)

""");

    await db.execute("""

CREATE TABLE suppliers(

id INTEGER PRIMARY KEY AUTOINCREMENT,

name TEXT NOT NULL,

phone TEXT,

address TEXT,

notes TEXT

)

""");

    await db.execute("""

CREATE TABLE purchases(

id INTEGER PRIMARY KEY AUTOINCREMENT,

supplier_id INTEGER,

date TEXT,

total REAL,

notes TEXT

)

""");

    await db.execute("""

CREATE TABLE purchase_items(

id INTEGER PRIMARY KEY AUTOINCREMENT,

purchase_id INTEGER,

product_id INTEGER,

quantity INTEGER,

buy_price REAL

)

""");

    await db.execute("""

CREATE TABLE sales(

id INTEGER PRIMARY KEY AUTOINCREMENT,

customer_id INTEGER,

date TEXT,

total REAL,

discount REAL DEFAULT 0,

paid REAL DEFAULT 0,

remaining REAL DEFAULT 0,

notes TEXT

)

""");

    await db.execute("""

CREATE TABLE sale_items(

id INTEGER PRIMARY KEY AUTOINCREMENT,

sale_id INTEGER,

product_id INTEGER,

quantity INTEGER,

sell_price REAL

)

""");
  
  }
    // =========================
  // PRODUCTS
  // =========================

  Future<int> insertProduct(
      Map<String, dynamic> data) async {

    final db = await database;

    return await db.insert(
      "products",
      data,
    );

  }

  Future<List<Map<String, dynamic>>>
      getProducts() async {

    final db = await database;

    return await db.query(

      "products",

      orderBy: "id DESC",

    );

  }

  Future<int> updateProduct(

    int id,

    Map<String, dynamic> data,

  ) async {

    final db = await database;

    return await db.update(

      "products",

      data,

      where: "id=?",

      whereArgs: [id],

    );

  }

  Future<int> deleteProduct(
      int id) async {

    final db = await database;

    return await db.delete(

      "products",

      where: "id=?",

      whereArgs: [id],

    );

  }

  Future<void> increaseProductQuantity(

    int productId,

    int quantity,

  ) async {

    final db = await database;

    await db.rawUpdate(

      """

UPDATE products

SET quantity = quantity + ?

WHERE id = ?

""",

      [

        quantity,

        productId,

      ],

    );

  }

  Future<void> decreaseProductQuantity(

    int productId,

    int quantity,

  ) async {

    final db = await database;

    await db.rawUpdate(

      """

UPDATE products

SET quantity = quantity - ?

WHERE id = ?

""",

      [

        quantity,

        productId,

      ],

    );

  }

  Future<int> getProductsCount() async {

    final db = await database;

    final result = await db.rawQuery(

      "SELECT COUNT(*) AS total FROM products",

    );

    return result.first["total"] as int;

  }
    // =========================
  // CUSTOMERS
  // =========================

  Future<int> insertCustomer(
      Map<String, dynamic> data) async {

    final db = await database;

    return await db.insert(
      "customers",
      data,
    );

  }

  Future<List<Map<String, dynamic>>>
      getCustomers() async {

    final db = await database;

    return await db.query(

      "customers",

      orderBy: "id DESC",

    );

  }

  Future<int> updateCustomer(

    int id,

    Map<String, dynamic> data,

  ) async {

    final db = await database;

    return await db.update(

      "customers",

      data,

      where: "id=?",

      whereArgs: [id],

    );

  }

  Future<int> deleteCustomer(
      int id) async {

    final db = await database;

    return await db.delete(

      "customers",

      where: "id=?",

      whereArgs: [id],

    );

  }

  Future<int> getCustomersCount() async {

    final db = await database;

    final result = await db.rawQuery(

      "SELECT COUNT(*) AS total FROM customers",

    );

    return result.first["total"] as int;

  }
    // =========================
  // SUPPLIERS
  // =========================

  Future<int> insertSupplier(
      Map<String, dynamic> data) async {

    final db = await database;

    return await db.insert(
      "suppliers",
      data,
    );

  }

  Future<List<Map<String, dynamic>>>
      getSuppliers() async {

    final db = await database;

    return await db.query(

      "suppliers",

      orderBy: "id DESC",

    );

  }

  Future<int> updateSupplier(

    int id,

    Map<String, dynamic> data,

  ) async {

    final db = await database;

    return await db.update(

      "suppliers",

      data,

      where: "id=?",

      whereArgs: [id],

    );

  }

  Future<int> deleteSupplier(
      int id) async {

    final db = await database;

    return await db.delete(

      "suppliers",

      where: "id=?",

      whereArgs: [id],

    );

  }

  Future<int> getSuppliersCount() async {

    final db = await database;

    final result = await db.rawQuery(

      "SELECT COUNT(*) AS total FROM suppliers",

    );

    return result.first["total"] as int;

  }
    // =========================
  // PURCHASES
  // =========================

  Future<int> insertPurchase(
      Map<String, dynamic> data) async {

    final db = await database;

    return await db.insert(
      "purchases",
      data,
    );

  }

  Future<int> insertPurchaseItem(
      Map<String, dynamic> data) async {

    final db = await database;

    return await db.insert(
      "purchase_items",
      data,
    );

  }

  Future<List<Map<String, dynamic>>>
      getPurchases() async {

    final db = await database;

    return await db.query(

      "purchases",

      orderBy: "id DESC",

    );

  }

  Future<List<Map<String, dynamic>>>
      getPurchaseItems(
      int purchaseId) async {

    final db = await database;

    return await db.rawQuery(

      '''

SELECT

purchase_items.*,

products.name AS product_name,

products.brand

FROM purchase_items

INNER JOIN products

ON purchase_items.product_id = products.id

WHERE purchase_items.purchase_id = ?

ORDER BY purchase_items.id DESC

''',

      [

        purchaseId,

      ],

    );

  }

  Future<int> deletePurchase(
      int id) async {

    final db = await database;

    await db.delete(

      "purchase_items",

      where: "purchase_id=?",

      whereArgs: [id],

    );

    return await db.delete(

      "purchases",

      where: "id=?",

      whereArgs: [id],

    );

  }

  Future<double> getTotalPurchases() async {

    final db = await database;

    final result = await db.rawQuery(

      '''

SELECT

IFNULL(SUM(total),0) AS total

FROM purchases

''',

    );

    return (result.first["total"] as num)
        .toDouble();

  }
      // =========================
  // SALES
  // =========================

  Future<int> insertSale(
      Map<String, dynamic> data) async {

    final db = await database;

    return await db.insert(
      "sales",
      data,
    );

  }

  Future<int> insertSaleItem(
      Map<String, dynamic> data) async {

    final db = await database;

    return await db.insert(
      "sale_items",
      data,
    );

  }

  Future<List<Map<String, dynamic>>>
      getSales() async {

    final db = await database;

    return await db.query(

      "sales",

      orderBy: "id DESC",

    );

  }

  Future<List<Map<String, dynamic>>>
      getSaleItems(
      int saleId) async {

    final db = await database;

    return await db.rawQuery(

      '''

SELECT

sale_items.*,

products.name AS product_name,

products.brand

FROM sale_items

INNER JOIN products

ON sale_items.product_id = products.id

WHERE sale_items.sale_id = ?

ORDER BY sale_items.id DESC

''',

      [

        saleId,

      ],

    );

  }

  Future<int> deleteSale(
      int id) async {

    final db = await database;

    await db.delete(

      "sale_items",

      where: "sale_id=?",

      whereArgs: [id],

    );

    return await db.delete(

      "sales",

      where: "id=?",

      whereArgs: [id],

    );

  }

  Future<double> getTotalSales() async {

    final db = await database;

    final result = await db.rawQuery(

      '''

SELECT

IFNULL(SUM(total),0) AS total

FROM sales

''',

    );

    return (result.first["total"] as num)
        .toDouble();

  }

  Future<double> getTotalProfit() async {

    final db = await database;

    final result = await db.rawQuery(

      '''

SELECT

IFNULL(

SUM(

(si.sell_price - pi.buy_price)
* si.quantity

),

0

) AS profit

FROM sale_items si

INNER JOIN purchase_items pi

ON si.product_id = pi.product_id

''',

    );

    return (result.first["profit"] as num)
        .toDouble();

  }
    // =========================
  // SEARCH
  // =========================

  Future<List<Map<String, dynamic>>> searchProducts(
      String keyword) async {

    final db = await database;

    return await db.query(

      "products",

      where: "name LIKE ? OR brand LIKE ? OR barcode LIKE ?",

      whereArgs: [

        "%$keyword%",

        "%$keyword%",

        "%$keyword%",

      ],

      orderBy: "name ASC",

    );

  }

  // =========================
  // STOCK
  // =========================

  Future<List<Map<String, dynamic>>> getLowStockProducts() async {

    final db = await database;

    return await db.query(

      "products",

      where: "quantity <= ?",

      whereArgs: [5],

      orderBy: "quantity ASC",

    );

  }

  Future<int> getLowStockCount() async {

    final db = await database;

    final result = await db.rawQuery(

      '''

SELECT COUNT(*) AS total

FROM products

WHERE quantity <= 5

''',

    );

    return result.first["total"] as int;

  }

  // =========================
  // REPORTS
  // =========================

  Future<Map<String, dynamic>> getDashboardData() async {

    return {

      "products": await getProductsCount(),

      "customers": await getCustomersCount(),

      "suppliers": await getSuppliersCount(),

      "sales": await getTotalSales(),

      "purchases": await getTotalPurchases(),

      "profit": await getTotalProfit(),

      "lowStock": await getLowStockCount(),

    };

  }

}