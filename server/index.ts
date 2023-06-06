import express from 'express';
import checkRouter from './routes/check';

const app = express();
app.use('/check', checkRouter);


app.listen(8080, () => {
  console.log("Server is listening on port 8080");
})
