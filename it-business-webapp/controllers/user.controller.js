const db = require("../models");
const User = db.user;

exports.create = (req, res) => {
  if (!req.body.username) {
    res.status(400).send({ message: "Content can not be empty!" });
    return;
  }

  const user = {
    username: req.body.username,
    email: req.body.email,
    password: req.body.password
  };

  User.create(user)
    .then(data => res.send(data))
    .catch(err => res.status(500).send({ message: err.message }));
};

exports.findAll = (req, res) => {
  User.findAll()
    .then(data => res.send(data))
    .catch(err => res.status(500).send({ message: err.message }));
};

exports.findOne = (req, res) => {
  const id = req.params.id;

  User.findByPk(id)
    .then(data => res.send(data))
    .catch(err => res.status(500).send({ message: err.message }));
};

exports.update = (req, res) => {
  const id = req.params.id;

  User.update(req.body, { where: { id: id } })
    .then(num => {
      if (num == 1) {
        res.send({ message: "User was updated successfully." });
      } else {
        res.send({ message: `Cannot update User with id=${id}.` });
      }
    })
    .catch(err => res.status(500).send({ message: err.message }));
};

exports.delete = (req, res) => {
  const id = req.params.id;

  User.destroy({ where: { id: id } })
    .then(num => {
      if (num == 1) {
        res.send({ message: "User was deleted successfully!" });
      } else {
        res.send({ message: `Cannot delete User with id=${id}.` });
      }
    })
    .catch(err => res.status(500).send({ message: err.message }));
};
