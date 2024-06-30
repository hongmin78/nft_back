// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketplace is ReentrancyGuard {
    struct Listing {
        uint256 price;
        address seller;
    }

    event Listed(uint256 tokenId, address seller, uint256 price);
    event Sold(uint256 tokenId, address buyer, uint256 price);

    IERC721 public immutable nftContract;
    mapping(uint256 => Listing) public listings;

    constructor(address _nftContract) {
        nftContract = IERC721(_nftContract);
    }

    function list(uint256 tokenId, uint256 price) external nonReentrant {
        require(price > 0, "Price must be greater than zero");
        require(nftContract.ownerOf(tokenId) == msg.sender, "You are not the owner");

        nftContract.transferFrom(msg.sender, address(this), tokenId);
        listings[tokenId] = Listing(price, msg.sender);

        emit Listed(tokenId, msg.sender, price);
    }

    function buy(uint256 tokenId) external payable nonReentrant {
        Listing memory listing = listings[tokenId];
        require(msg.value == listing.price, "Incorrect price");

        delete listings[tokenId];
        nftContract.transferFrom(address(this), msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);

        emit Sold(tokenId, msg.sender, listing.price);
    }

    function cancel(uint256 tokenId) external nonReentrant {
        Listing memory listing = listings[tokenId];
        require(listing.seller == msg.sender, "You are not the seller");

        delete listings[tokenId];
        nftContract.transferFrom(address(this), msg.sender, tokenId);
    }
}

