const MyNFT = artifacts.require("MyNFT");
const NFTMarketplace = artifacts.require("NFTMarketplace");

module.exports = async function (deployer) {
  await deployer.deploy(MyNFT);
  const myNFT = await MyNFT.deployed();
  await deployer.deploy(NFTMarketplace, myNFT.address);
};

