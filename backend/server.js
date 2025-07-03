const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const Appointment = require('./models/Appointment');

const app = express();
app.use(cors());
app.use(express.json());

// Replace with your actual MongoDB Atlas URI
const mongoUri = 'mongodb+srv://myclinicuser:welcome!23@myclinic-cluster.ht5hi.mongodb.net/?retryWrites=true&w=majority&appName=myclinic-cluster';

mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

  app.post('/bookings', async (req, res) => {
  console.log('Received body:', req.body);
  try {
    const appointment = new Appointment(req.body);
    await appointment.save();
    res.status(201).json({ message: 'Appointment saved', appointment });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`)); 