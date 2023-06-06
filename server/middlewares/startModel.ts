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
    res.status(200).send(lastTwoLines[0] + "| " + lastTwoLines[1]);
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
