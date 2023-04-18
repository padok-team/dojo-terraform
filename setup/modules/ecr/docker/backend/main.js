const express = require('express')
const cors = require('cors')
const app = express()
app.use(cors())

const port = process.env.PORT
const user = process.env.APPLICATION_USER

app.get('/', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.send(JSON.stringify({user:`${String(user)}`}));
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
