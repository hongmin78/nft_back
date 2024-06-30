const HDWalletProvider = require('@truffle/hdwallet-provider');
const mnemonic = 'your mnemonic here';

module.exports = {
  networks: {
    bsc: {
      provider: () => new HDWalletProvider(mnemonic, `https://bsc-dataseed.binance.org/`),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    }
  },
  compilers: {
    solc: {
      version: "^0.8.0"
    }
  }
};

