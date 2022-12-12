const PollShip = artifacts.require('PollShip');

module.exports = (deployer) => {
  deployer.deploy(PollShip);
}