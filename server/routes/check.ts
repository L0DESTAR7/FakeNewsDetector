import express, { NextFunction, Request, Response } from 'express';
import axios from 'axios'
import fs from 'fs';
import startModel from '../middlewares/startModel';

const router = express.Router();

router.get('/', (req: Request, res: Response, next: NextFunction) => {

  var query = req.query.q;
  res.locals.query = query as string;
  console.log(res.locals.query);
  // TODO: Add query parameter retrieval.
  var options = {
    method: 'GET',
    url: 'https://api.newscatcherapi.com/v2/search',
    params: { q: query, lang: 'en', sort_by: 'relevancy', page: '1' },
    headers: {
      'x-api-key': 'OIIJBgXnEJ48epfhkjhCi5bqjclZXoM-w0nF5h6Gr4w'
    }
  };

  axios.request(options).then(function(response) {
    console.log("Received data: ");
    console.log(response.data);

    // Looping over articles and writing into True.csv
    response.data.articles.forEach((element: { title: string, summary: string, topic: string, published_date: string }) => {

      // Not sure about writeFileSync since it blocks the event look (not Async).
      fs.writeFileSync("./server/model/True.csv", `${element.title.replace(/[,\n]/g, "")},${element.summary.replace(/[,\n]/g, "")},${element.topic.replace(/[,\n]/g, "")},${element.published_date.replace(/[,\n]/g, "").split(" ")[0]}` + "\n", { flag: 'a' });
    });

  }).catch(function(error) {
    console.error(error);
  });
  next();
},
  startModel
);

export default router;
