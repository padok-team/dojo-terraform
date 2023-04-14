const express = require('express')

const app = express()
const port = process.env.PORT
const user = process.env.APPLICATION_USER

app.get('/', (req, res) => {
  res.send(`${String(user)}`)
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
