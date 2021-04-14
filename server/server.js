const express = require('express')
const app = express()

const mongoose = require("mongoose")

const dotenv = require('dotenv').config();
const connectionString = 'mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@finditcluster.b7xew.mongodb.net/test?authSource=admin&replicaSet=atlas-jly7ul-shard-0&readPreference=primary&appname=MongoDB%20Compass&ssl=true'
const dbusername = process.env.DB_USERNAME
const dbpassword = process.env.DB_PASSWORD
const port = process.env.PORT

var jwt = require('jsonwebtoken');


//db
async function connectDB() {
    await mongoose.connect(connectionString, {
      dbName: process.env.DB_NAME,
      user: process.env.DB_USERNAME,
      pass: process.env.DB_PASSWORD,
      useNewUrlParser: true,
      useUnifiedTopology: true,
      useFindAndModify: false,
      useCreateIndex: true
    });
        console.log("db connected");
}
connectDB()

// this takes the post body
app.use(express.json({extended: false}));
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', '*');
  next();
});

app.get('/', (req, res) => {
  res.send('Hello World!')
})

const schema = new mongoose.Schema({ email: 'string', password: 'string' });
const User = mongoose.model('User', schema);

// signup route api
app.post('/signup', async (req, res) => {
    const {email, password} = req.body;
    console.log(email);
    console.log(password);

    let user = await User.findOne({email});

    if(user) {
      return res.json({msg:"Email already taken"});
    }

    user = new User({
        email,
        password,
    });
    console.log(user)

    await user.save();
    var token = jwt.sign({ id: user.id }, "password");
    res.json({token:token});
  })

  // signup route api
app.post('/login', async (req, res) => {
  const {email, password} = req.body;
  console.log(email);
  console.log(password);

  let user = await User.findOne({email});
  console.log(user);

  if(!user) {
    return res.json({msg:"no user found with that email"});
  }

  if(user.password !== password) {
    return res.json({msg: "Password is not correct"});
  }

  var token = jwt.sign({ id: user.id }, "password");
  return res.json({token:token});

})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})