var Bank = artifacts.require("./Banknew.sol");
//var NewToken=artifacts.require("./NewToken.sol");
module.exports = function(deployer) {
deployer.deploy(Bank);

//deployer.link(Bank,NewToken);
//deployer.deploy(NewToken);


};