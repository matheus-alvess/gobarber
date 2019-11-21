import { Router } from 'express';

import UserController from './app/controllers/UserController';

const routes = new Router();

routes.get('/ping', (req, res) => {
  res.json({ message: 'ping' });
});

routes.post('/users', UserController.store);

export default routes;
