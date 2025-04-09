require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Connect to MongoDB Atlas
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB Atlas'))
  .catch((err) => console.error(err));

// User Schema
const userSchema = new mongoose.Schema({
  username: String,
  password: String,
});

const User = mongoose.model('User', userSchema);

// Note Schema
const noteSchema = new mongoose.Schema({
  userId: String,
  note: String,
});

const Note = mongoose.model('Note', noteSchema);

// Signup Route
app.post('/signup', async (req, res) => {
  const { username, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    const newUser = new User({ username, password: hashedPassword });
    await newUser.save();
    res.status(201).json({ message: 'User created successfully!' });
  } catch (err) {
    res.status(400).json({ message: 'User already exists!' });
  }
});

// Login Route
app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  const user = await User.findOne({ username });
  if (!user) return res.status(400).json({ message: 'Invalid credentials!' });

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) return res.status(400).json({ message: 'Invalid credentials!' });

  res.status(200).json({ message: 'Login successful!', userId: user._id }); // Return user ID for future use
});

// Get Note Route
app.get('/get-note', async (req, res) => {
  const userId = 'loggedInUserId'; // Replace with actual user ID (e.g., from JWT or session)
  const note = await Note.findOne({ userId });
  res.json({ note: note?.note || '' });
});

// Save Note Route
app.post('/save-note', async (req, res) => {
  const { note } = req.body;
  const userId = 'loggedInUserId'; // Replace with actual user ID (e.g., from JWT or session)

  try {
    await Note.findOneAndUpdate(
      { userId },
      { note },
      { upsert: true }
    );

    res.status(200).json({ message: 'Note saved successfully!' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to save note.' });
  }
});

// Serve Static Files
app.use(express.static('public'));

// Serve Notepad Page
app.get('/notepad', (req, res) => {
  res.sendFile(__dirname + '/public/notepad.html');
});

// Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
