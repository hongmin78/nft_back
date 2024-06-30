require('dotenv').config();
const express = require('express');
const Web3 = require('web3');
const app = express();
const port = 3000;

const web3 = new Web3(new Web3.providers.HttpProvider(process.env.INFURA_URL));
const contractABI = require('./MyNFT.json').abi;
const contractAddress = process.env.CONTRACT_ADDRESS;
const contract = new web3.eth.Contract(contractABI, contractAddress);
const account = web3.eth.accounts.privateKeyToAccount(process.env.PRIVATE_KEY);
web3.eth.accounts.wallet.add(account);
web3.eth.defaultAccount = account.address;

app.use(express.json());

app.post('/mint', async (req, res) => {
  const { to, tokenURI } = req.body;
  try {
    const tx = contract.methods.mint(to, tokenURI);
    const gas = await tx.estimateGas({ from: account.address });
    const gasPrice = await web3.eth.getGasPrice();
    const data = tx.encodeABI();
    const nonce = await web3.eth.getTransactionCount(account.address);

    const signedTx = await web3.eth.accounts.signTransaction(
      {
        to: contractAddress,
        data,
        gas,
        gasPrice,
        nonce,
        chainId: 56,
      },
      process.env.PRIVATE_KEY
    );

    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    res.send(receipt);
  } catch (error) {
    res.status(500).send(error.toString());
  }
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});

