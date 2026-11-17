// Day 5 - Set 3 : Task 5
// clinical notes with variable structure (run: mongosh collections.js)

db = db.getSiblingDB("hospital_notes");
db.clinical_notes.drop();

print("--- create collection with validation ---");
printjson(db.createCollection("clinical_notes", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["patient_id", "visit_id", "doctor_id", "note_type", "diagnosis", "created_at"],
      properties: {
        patient_id: { bsonType: "int" },
        visit_id:   { bsonType: "int" },
        doctor_id:  { bsonType: "int" },
        note_type:  { enum: ["consultation", "lab_report"] },
        diagnosis:  { bsonType: "string" },
        created_at: { bsonType: "date" },
        symptoms:   { bsonType: "array", items: { bsonType: "string" } },
        vitals:     { bsonType: "object" },
        tests:      { bsonType: "array" }
      }
    }
  }
}));

print("\n--- shape 1 : consultation notes ---");
printjson(db.clinical_notes.insertMany([
  { patient_id: 5001, visit_id: 1, doctor_id: 101, note_type: "consultation",
    diagnosis: "Hypertension", created_at: new Date("2026-09-08T10:20:00Z"),
    symptoms: ["headache", "dizziness"],
    vitals: { bp: "158/96", pulse: 84, weight_kg: 78 },
    plan: "Start Amlodipine, reduce salt, review in 2 months" },
  { patient_id: 5002, visit_id: 4, doctor_id: 104, note_type: "consultation",
    diagnosis: "Viral Fever", created_at: new Date("2026-10-06T11:05:00Z"),
    symptoms: ["fever", "body ache"],
    vitals: { temp_f: 101.8, pulse: 96 },
    plan: "Paracetamol, fluids, rest 3 days" },
  { patient_id: 5006, visit_id: 6, doctor_id: 108, note_type: "consultation",
    diagnosis: "Viral Fever", created_at: new Date("2026-10-15T09:40:00Z"),
    symptoms: ["fever", "cough"],
    vitals: { temp_f: 100.9, weight_kg: 19 },
    guardian: "Mother", plan: "Syrup paracetamol 5ml" }
]));

print("\n--- shape 2 : lab report notes ---");
printjson(db.clinical_notes.insertMany([
  { patient_id: 5004, visit_id: 2, doctor_id: 105, note_type: "lab_report",
    diagnosis: "Type 2 Diabetes", created_at: new Date("2026-09-19T08:30:00Z"),
    lab: "Central Lab",
    tests: [ { name: "HbA1c", value: 8.1, unit: "%", range: "4.0-5.6" },
             { name: "Fasting Glucose", value: 162, unit: "mg/dL", range: "70-100" } ] },
  { patient_id: 5009, visit_id: 7, doctor_id: 105, note_type: "lab_report",
    diagnosis: "Type 2 Diabetes", created_at: new Date("2026-10-21T08:15:00Z"),
    lab: "Central Lab",
    tests: [ { name: "HbA1c", value: 7.2, unit: "%", range: "4.0-5.6" } ],
    remarks: "Better control than last test" }
]));

print("\n--- invalid note (note_type not allowed, created_at missing) ---");
try {
  db.clinical_notes.insertOne({ patient_id: 5003, visit_id: 8, doctor_id: 103,
                                note_type: "discharge", diagnosis: "Coronary Artery Disease" });
} catch (e) {
  print("Rejected -> " + e.name + ": " + e.message);
}

print("\n--- query by diagnosis : Type 2 Diabetes ---");
printjson(db.clinical_notes.find({ diagnosis: "Type 2 Diabetes" },
  { _id: 0, patient_id: 1, note_type: 1, diagnosis: 1, tests: 1 }).toArray());

print("\n--- query by diagnosis : Viral Fever ---");
printjson(db.clinical_notes.find({ diagnosis: "Viral Fever" },
  { _id: 0, patient_id: 1, note_type: 1, symptoms: 1, vitals: 1 }).toArray());
