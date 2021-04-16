const Catalog = artifacts.require("Catalog");

module.exports = function (deployer) {
  deployer.deploy(Catalog);
};
