import express, { Request, Response } from 'express';
import axios from 'axios'

const router = express.Router();

router.get('/', (req: Request, res: Response) => {


  // TODO: Add query parameter retrieval.
  var options = {
    method: 'GET',
    url: 'https://api.newscatcherapi.com/v2/search',
    params: { q: 'Zlatan', lang: 'en', sort_by: 'relevancy', page: '1' },
    headers: {
      'x-api-key': 'E5VxT_RDV2e8JZiEaxwp605SxgDCIGpNytwM4gwIXR8'
    }
  };

  axios.request(options).then(function(response) {
    console.log("Received data: ");
    console.log(response.data);
    console.log("Sending data to end user...");
    res.status(200).send(response.data);
  }).catch(function(error) {
    console.error(error);
  })
})

export default router;
