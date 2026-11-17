/* =====================================================================
   Day 5 - Set 1 : Retail Inventory and Product Reviews
   File          : collections.js   (Task 5)
   Target        : MongoDB 8.0  (run with:  mongosh collections.js)

   What goes to MongoDB:
   - Product reviews  : free text with optional photos, tags and replies, so the
                        shape changes per review and fits a flexible document.
   - Search activity  : many small writes with no joins, read by time range,
                        so it suits an append-only document collection.
   Stock, suppliers and warehouses stay in SQL Server because they need
   joins, foreign keys and transactions.
   ===================================================================== */

db = db.getSiblingDB("retail_reviews");
db.reviews.drop();
db.search_activity.drop();

print("\n===== 1. createCollection reviews with $jsonSchema validator =====");
printjson(db.createCollection("reviews", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      title: "Product review",
      required: ["sku", "customer", "rating", "review_text", "review_date"],
      properties: {
        sku:          { bsonType: "string", pattern: "^SKU-[0-9]{4}$",
                        description: "must match a SQL Server Product.sku" },
        customer:     { bsonType: "object", required: ["name"],
                        properties: { name: { bsonType: "string" },
                                      city: { bsonType: "string" } } },
        rating:       { bsonType: "int", minimum: 1, maximum: 5,
                        description: "whole number 1 to 5" },
        review_text:  { bsonType: "string", minLength: 5 },
        review_date:  { bsonType: "date" },
        verified_purchase: { bsonType: "bool" },
        tags:         { bsonType: "array", items: { bsonType: "string" } },
        helpful_votes:{ bsonType: "int", minimum: 0 }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
}));

print("\n===== 2. insertMany : 10 reviews =====");
printjson(db.reviews.insertMany([
  { sku: "SKU-1001", customer: { name: "Arun",    city: "Chennai"   }, rating: 5,
    review_text: "Loud and clear sound, battery lasts all day.", review_date: new Date("2026-10-01"),
    verified_purchase: true,  tags: ["sound", "battery"], helpful_votes: 12 },
  { sku: "SKU-1001", customer: { name: "Divya",   city: "Bengaluru" }, rating: 3,
    review_text: "Good sound but Bluetooth drops sometimes.",   review_date: new Date("2026-10-04"),
    verified_purchase: true,  helpful_votes: 4 },
  { sku: "SKU-1002", customer: { name: "Karthik" }, rating: 4,
    review_text: "Charges my phone fast.",                       review_date: new Date("2026-10-05"),
    verified_purchase: false },
  { sku: "SKU-1003", customer: { name: "Meena",   city: "Madurai"   }, rating: 5,
    review_text: "Long grains, cooks well.",                     review_date: new Date("2026-10-06"),
    verified_purchase: true,  tags: ["quality"] },
  { sku: "SKU-1005", customer: { name: "Rahul",   city: "Hyderabad" }, rating: 2,
    review_text: "Motor heats up after ten minutes.",            review_date: new Date("2026-10-07"),
    verified_purchase: true,  tags: ["heating", "motor"], helpful_votes: 7 },
  { sku: "SKU-1006", customer: { name: "Sneha" }, rating: 4,
    review_text: "Sturdy table, easy to assemble.",              review_date: new Date("2026-10-08"),
    verified_purchase: true },
  { sku: "SKU-1008", customer: { name: "Vikram",  city: "Pune"      }, rating: 5,
    review_text: "Very comfortable for daily runs.",             review_date: new Date("2026-10-09"),
    verified_purchase: true,  tags: ["comfort"], helpful_votes: 9 },
  { sku: "SKU-1009", customer: { name: "Priya" }, rating: 1,
    review_text: "Handle cracked in the first week.",            review_date: new Date("2026-10-10"),
    verified_purchase: true,  tags: ["damaged"] },
  { sku: "SKU-1010", customer: { name: "Lakshmi", city: "Chennai"   }, rating: 4,
    review_text: "Kids love it, pieces fit well.",               review_date: new Date("2026-10-11"),
    verified_purchase: false },
  { sku: "SKU-1007", customer: { name: "Sanjay",  city: "Mumbai"    }, rating: 3,
    review_text: "Colour faded after two washes.",               review_date: new Date("2026-10-12"),
    verified_purchase: true,  helpful_votes: 2 }
]));

print("\n===== 3. Validator check : rating 7 must be rejected =====");
try {
  db.reviews.insertOne({ sku: "SKU-1001", customer: { name: "Test" }, rating: 7,
                         review_text: "Invalid rating test", review_date: new Date() });
} catch (e) {
  print("Insert rejected -> " + e.name + ": " + e.message);
}

print("\n===== 4. find : reviews of SKU-1001 =====");
printjson(db.reviews.find({ sku: "SKU-1001" },
          { _id: 0, sku: 1, "customer.name": 1, rating: 1, review_text: 1 }).toArray());

print("\n===== 4b. find : low ratings (rating <= 2), newest first =====");
printjson(db.reviews.find({ rating: { $lte: 2 } },
          { _id: 0, sku: 1, rating: 1, review_text: 1, review_date: 1 })
          .sort({ review_date: -1 }).toArray());

print("\n===== 5. updateOne : add a seller reply and a helpful vote to Rahul's review =====");
printjson(db.reviews.updateOne(
  { sku: "SKU-1005", "customer.name": "Rahul" },
  { $set: { seller_reply: "Sorry! A replacement unit has been shipped." },
    $inc: { helpful_votes: 1 } }));
printjson(db.reviews.findOne({ sku: "SKU-1005", "customer.name": "Rahul" },
          { _id: 0, sku: 1, rating: 1, helpful_votes: 1, seller_reply: 1 }));

print("\n===== 6. deleteOne : remove the unverified review of SKU-1002 =====");
print("count before = " + db.reviews.countDocuments());
printjson(db.reviews.deleteOne({ sku: "SKU-1002", verified_purchase: false }));
print("count after  = " + db.reviews.countDocuments());

print("\n===== 7. search_activity collection (append-only log) =====");
db.createCollection("search_activity");
printjson(db.search_activity.insertMany([
  { session_id: "S-501", term: "bluetooth speaker", results: 3, at: new Date("2026-10-12T10:01:00Z") },
  { session_id: "S-501", term: "speaker 20w",       results: 1, at: new Date("2026-10-12T10:02:30Z"),
    clicked_sku: "SKU-1001" },
  { session_id: "S-502", term: "running shoes",     results: 5, at: new Date("2026-10-12T11:15:00Z"),
    filters: { size: 9, brand: "StepUp" } }
]));
printjson(db.search_activity.find({ session_id: "S-501" }, { _id: 0 }).sort({ at: 1 }).toArray());
