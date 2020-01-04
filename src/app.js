import 'dotenv/config';
import express from 'express';
import { resolve } from 'path';
import 'express-async-errors';
import * as Sentry from '@sentry/node';
import Youch from 'youch';
import routes from './routes';
import sentryConfig from './config/sentry';

import './database';

class App {
  constructor() {
    this.server = express();

    Sentry.init(sentryConfig);

    this.middlewares();
    this.routes();
    this.exceptionHandler();
  }

  middlewares() {
    this.server.use(Sentry.Handlers.requestHandler());
    this.server.use(express.json());
    this.server.use(
      '/files',
      express.static(resolve(__dirname, '..', 'tmp', 'uploads'))
    );
    this.server.use(this.requestLogger);
  }

  requestLogger(req, res, next) {
    console.log(`${new Date().toLocaleString()} - ${req.method} - ${req.url}`);
    next();
  }

  routes() {
    this.server.use(routes);
    this.server.use(Sentry.Handlers.errorHandler());
  }

  exceptionHandler() {
    this.server.use(async (err, req, res, next) => {
      if (process.env.NODE_ENV === 'development') {
        const errors = await new Youch(err, req).toJSON();
        return res.status(500).json(errors);
      }

      return res.status(500).json({ message: 'Internal server error' });
    });
  }
}

export default new App().server;
