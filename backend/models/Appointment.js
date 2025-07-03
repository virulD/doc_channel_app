const mongoose = require('mongoose');

const appointmentSchema = new mongoose.Schema({
  patientId: String,
  doctorId: String,
  dispensaryId: String,
  bookingDate: Date,
  timeSlot: String,
  appointmentNumber: Number,
  estimatedTime: String,
  status: String,
  symptoms: String,
  isPaid: Boolean,
  isPatientVisited: Boolean,
  patientName: String,
  patientPhone: String,
  patientEmail: String,
  createdAt: Date,
  updatedAt: Date,
});

module.exports = mongoose.model('Appointment', appointmentSchema, 'bookings'); 