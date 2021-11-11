const express = require('express');
const app = express();
const port = 3000;
const cors = require('cors');
var admin = require('firebase-admin');

var serviceAccount = require('./node-firebase-api-d6245-firebase-adminsdk-rmjjh-702d403d2d.json');

admin.initializeApp({
	credential: admin.credential.cert(serviceAccount),
	databaseURL: 'https://node-firebase-api-d6245-default-rtdb.asia-southeast1.firebasedatabase.app'
});

app.use(express.json());
app.use(express.static('public'));
app.use(
	cors({
		origin: '*'
	})
);

const database = admin.database();
const notesRef = database.ref('/notes');

app.get('/', (req, res) => {
	res.send('index');
});

app.post('/save', (req, res) => {
	console.log(req.body);
	console.log('SAVING...');
	notesRef.child(req.body.note_id).set({
		title: req.body.title,
		description: req.body.description,
		user: req.body.user
	});
	res.status(200).json({ message: 'Successfully added' });
	console.log('Successfully added!');
});

app.put('/update', (req, res) => {
	console.log(req.body);
	console.log('UPDATING...');
	const newData = {
		title: req.body.title,
		description: req.body.description,
		user: req.body.user
	};
	notesRef.child(req.body.note_id).update(newData);
	res.status(200).json({ message: 'Successfully updated' });
	console.log('Successfully updated!');
});

app.delete('/remove', (req, res) => {
	console.log(req.body);
	console.log('DELETING...');
	notesRef.child(req.body.note_id).remove();
	res.status(200).json({ message: 'Successfully removed' });
	console.log('Successfully removed!');
});

app.get('/getNotes', (req, res) => {
	notesRef.once('value', function(snap) {
		res.status(200).json(snap.val());
	});
});

app.listen(port, () => {
	console.log(`App is listening to port ${port}`);
});
