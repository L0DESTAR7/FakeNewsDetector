import { NextFunction, Request, Response } from 'express';
import { spawn, ChildProcess } from 'child_process';


const startModel = (req: Request, res: Response, next: NextFunction) => {

  const query: string = res.locals.query;
  console.log(query);
  console.log(`EXECUTING MODEL ON QUERY = ${query}`);
  var payload: string = "";
  const modelProcess: ChildProcess = spawn('python', ['./server/model/code.py', query]);

  modelProcess.stdout!.on('data', (data: Buffer) => {
    console.log(`MODEL OUTPUT:\n${data.toString()}`);
    payload += data.toString();
  });

  modelProcess.stderr!.on('data', (data: Buffer) => {
    console.log(`Error executing model.\n\tERROR:${data.toString()}`);
  });

  modelProcess.on('close', (code: number) => {
    console.log(`Model process exited with code ${code}`);
    var lastTwoLines: string[] = payload.split('\n').slice(-3);
    console.log(lastTwoLines);
    lastTwoLines.pop();
    const extractedPredictions: (string | null)[] = lastTwoLines.flatMap(prediction => {
      const lrMatch = prediction.match(/LR Prediction: (.*)\r/);
      const dtMatch = prediction.match(/DT Prediction: (.*)\r/);

      const lrPrediction = lrMatch ? lrMatch[1].trim() : null;
      const dtPrediction = dtMatch ? dtMatch[1].trim() : null;


      return [lrPrediction, dtPrediction].filter(Boolean);
    });
    console.log(extractedPredictions);
    const predictionsObj = {
      lr: extractedPredictions[0] === "Not A Fake News" ? "REAL" : "FAKE",
      dt: extractedPredictions[1] === "Not A Fake News" ? "REAL" : "FAKE",
    }
    res.status(200).json(predictionsObj);
  });

}

/* function startModel(query: string) {
  const modelProcess: ChildProcess = spawn('python', ['./server/model/code.py', query]);

  modelProcess.stdout?.on('data', (data: Buffer) => {
    console.log(`MODEL OUTPUT:\n${data.toString()}`);
  });

  modelProcess.stderr?.on('data', (data: Buffer) => {
    console.log(`Error executing model.\n\tERROR:${data.toString()}`);
  });

  modelProcess.on('close', (code: number) => {
    console.log(`Model process exited with code ${code}`);
  });
} */


export default startModel;
