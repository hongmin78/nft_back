// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    address public admin;

    constructor() ERC721("MyNFT", "MNFT") {
        admin = msg.sender;
    }

    function mint(address to, string memory _tokenURI) external onlyOwner {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        nextTokenId++;
    }
}

