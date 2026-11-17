// Day 5 - Set 2 : Task 5
// customer activity logs in a capped collection (run: mongosh collections.js)

db = db.getSiblingDB("bank_activity");
db.activity_logs.drop();

// capped collection: fixed size, keeps insertion order, oldest logs are removed automatically
print("--- create capped collection ---");
printjson(db.createCollection("activity_logs", { capped: true, size: 1048576, max: 5000 }));
printjson({ capped: db.activity_logs.isCapped() });

print("\n--- insert 20 activity documents ---");
const logs = [
  { customer_id: 1001, event: "LOGIN",          channel: "mobile",  ip: "49.37.12.10", at: new Date("2026-11-10T08:02:00Z") },
  { customer_id: 1001, event: "BALANCE_ENQUIRY", channel: "mobile",  account: "100100000001", at: new Date("2026-11-10T08:03:10Z") },
  { customer_id: 1002, event: "LOGIN",          channel: "web",     ip: "103.21.4.55", browser: "Chrome", at: new Date("2026-11-10T09:15:00Z") },
  { customer_id: 1001, event: "LOGOUT",         channel: "mobile",  at: new Date("2026-11-10T08:10:00Z") },
  { customer_id: 1003, event: "FAILED_LOGIN",   channel: "web",     ip: "157.48.2.9", reason: "wrong password", at: new Date("2026-11-11T07:45:00Z") },
  { customer_id: 1001, event: "LOGIN",          channel: "web",     ip: "49.37.12.10", browser: "Edge", at: new Date("2026-11-11T19:30:00Z") },
  { customer_id: 1001, event: "FUND_TRANSFER",  channel: "web",     from: "100100000001", to: "100100000008", amount: 5000, mode: "IMPS", at: new Date("2026-11-11T19:33:00Z") },
  { customer_id: 1004, event: "LOGIN",          channel: "mobile",  ip: "106.51.8.1", at: new Date("2026-11-12T06:20:00Z") },
  { customer_id: 1001, event: "LOGIN",          channel: "mobile",  ip: "49.37.12.11", at: new Date("2026-11-12T21:05:00Z") },
  { customer_id: 1002, event: "CHEQUE_BOOK_REQUEST", channel: "web", leaves: 25, at: new Date("2026-11-12T10:00:00Z") },
  { customer_id: 1001, event: "PIN_CHANGE",     channel: "atm",     atm_id: "ATM-CHN-118", at: new Date("2026-11-13T11:40:00Z") },
  { customer_id: 1005, event: "LOGIN",          channel: "web",     ip: "117.200.3.4", browser: "Firefox", at: new Date("2026-11-13T15:00:00Z") },
  { customer_id: 1001, event: "LOGIN",          channel: "web",     ip: "49.37.12.10", browser: "Chrome", at: new Date("2026-11-14T09:12:00Z") },
  { customer_id: 1003, event: "LOGIN",          channel: "web",     ip: "157.48.2.9", at: new Date("2026-11-14T09:30:00Z") },
  { customer_id: 1001, event: "BILL_PAYMENT",   channel: "mobile",  biller: "TNEB", amount: 1450, at: new Date("2026-11-15T07:55:00Z") },
  { customer_id: 1001, event: "LOGIN",          channel: "mobile",  ip: "49.37.12.12", at: new Date("2026-11-15T07:50:00Z") },
  { customer_id: 1006, event: "LOGIN",          channel: "mobile",  ip: "183.82.1.20", at: new Date("2026-11-16T12:00:00Z") },
  { customer_id: 1001, event: "LOGIN",          channel: "web",     ip: "49.37.12.10", browser: "Chrome", at: new Date("2026-11-16T20:45:00Z") },
  { customer_id: 1002, event: "LOGOUT",         channel: "web",     at: new Date("2026-11-16T21:00:00Z") },
  { customer_id: 1001, event: "LOGIN",          channel: "mobile",  ip: "49.37.12.13", at: new Date("2026-11-17T08:30:00Z") }
];
const res = db.activity_logs.insertMany(logs);
print("inserted: " + Object.keys(res.insertedIds).length);
print("total documents: " + db.activity_logs.countDocuments());

print("\n--- last five LOGIN events of customer 1001 ---");
printjson(db.activity_logs
  .find({ customer_id: 1001, event: "LOGIN" }, { _id: 0, customer_id: 1, event: 1, channel: 1, ip: 1, at: 1 })
  .sort({ at: -1 })
  .limit(5)
  .toArray());
