//Task 1: Emergency Fuel Report
//The Operations Team needs a list of all vehicles (regardless of type) that are currently "In Transit" and have a fuelLevel below 50%.
db.vehicles.aggregate([
  {
    $match: {
      status: "In Transit",
      fuelLevel: { $lt: 50 },
    },
  },
  {
    $project: {
      _id: 0,
      vin: 1,
      type: 1,
      fuelLevel: 1,
    },
  },
]);

//Task 2: Maintenance Prioritization
//Identify vehicles that are in "Maintenance".
db.vehicles.aggregate([
  { $match: { status: "Maintenance" } },
  {
    $project: {
      _id: 0,
      vin: 1,
      issues: "$activeAlerts",
      lastServiceDate: 1,
    },
  },
  { $sort: { lastServiceDate: 1 } },
]);

//Task 3: Electric Fleet Geo-Audit
//The manager wants to check the location of all Electric vehicles.
db.vehicles.aggregate([
  { $match: { isElectric: true } },
  {
    $project: {
      _id: 0,
      vin: 1,
      lon: { $arrayElemAt: ["$location.coordinates", 0] },
      lat: { $arrayElemAt: ["$location.coordinates", 1] },
    },
  },
]);

//Task 4: The Mastery Challenge (Multi-Stage Complexity)
//Generate a "High-Risk Truck Report" with the following requirements:
db.vehicles.aggregate([
  { $match: { type: "Semi-Truck" } },
  {
    $addFields: {
      alertCount: { $size: "$activeAlerts" },
      needsUrgentRefuel: { $lt: ["$fuelLevel", 20] },
    },
  },
  {
    $project: {
      _id: 0,
      vin: 1,
      alertCount: 1,
      needsUrgentRefuel: 1,
    },
  },
  { $sort: { alertCount: -1 } },
  { $limit: 3 },
]);