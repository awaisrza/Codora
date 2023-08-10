// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract CodoraNFT is ERC721URIStorage, Ownable {
    string private _baseTokenURI;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


    address public codoraTokenAddress;
    uint256 public nftPrice = 10 * 10**18; // 10 CodoraTokens

    constructor(string memory name, string memory symbol, string memory baseTokenURI, address _codoraTokenAddress) ERC721(name, symbol) {
        _baseTokenURI = baseTokenURI;
        codoraTokenAddress = _codoraTokenAddress;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function mint() external {
        require(codoraTokenAddress != address(0), "CodoraToken address not set");
        IERC20 codoraToken = IERC20(codoraTokenAddress);
        require(codoraToken.balanceOf(msg.sender) >= nftPrice, "Insufficient CodoraTokens");

        codoraToken.transferFrom(msg.sender, owner(), nftPrice);

         uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(msg.sender, tokenId);
    }

    function setBaseURI(string memory newBaseTokenURI) external onlyOwner {
        _baseTokenURI = newBaseTokenURI;
    }

    function setNFTPrice(uint256 newPrice) external onlyOwner {
        nftPrice = newPrice;
    }

    function setCodoraTokenAddress(address newAddress) external onlyOwner {
        codoraTokenAddress = newAddress;
    }
}
