import express from 'express';
import routes from './routes';

class App {
  constructor() {
    this.server = express();

    this.middlewares();
    this.routes();
  }

  middlewares() {
    this.server.use(express.json());
    this.server.use(this.requestLogger);
  }

  requestLogger(req, res, next) {
    console.log(`${new Date().toLocaleString()} - ${req.method} - ${req.url}`);
    next();
  }

  routes() {
    this.server.use(routes);
  }
}

export default new App().server;
