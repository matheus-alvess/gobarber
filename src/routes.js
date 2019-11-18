import { Router } from 'express';

const routes = new Router();

routes.get('/ping', (req, res) => {
  res.json({ message: 'ping' });
});

export default routes;
