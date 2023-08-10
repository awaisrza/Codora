// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


//Contract Address: 0x94b8868D6dcE2531E99A20BF408A57b790233786

contract CodoraToken is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 public mintPrice = 0.001 ether;
    uint256 public transferFeePercentage = 5;

    constructor() ERC20("CodoraToken", "CODORA") {
        _mint(msg.sender, 100 * 10 ** uint256(decimals()));
    }

    function setMintPrice(uint256 price) public onlyOwner {
        mintPrice = price;
    }

    function mintTokens(uint256 amount) public payable {
        require(msg.value >= mintPrice.mul(amount), "Insufficient payment.");
        
        _mint(msg.sender, amount * 10 ** uint256(decimals()));

        // Refund any excess payment
        if (msg.value > mintPrice.mul(amount)) {
            payable(msg.sender).transfer(msg.value.sub(mintPrice.mul(amount)));
        }
    }

     function FreemintTokens(uint256 amount) public payable onlyOwner {
       
        _mint(msg.sender, amount * 10 ** uint256(decimals()));

    }

    function withdrawEther() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        payable(owner()).transfer(contractBalance);
    }

    function setTransferFeePercentage(uint256 percentage) public onlyOwner {
        require(percentage <= 100, "Percentage should be 100 or less.");
        transferFeePercentage = percentage;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        if (recipient == owner()) {
            uint256 transferFee = amount.mul(transferFeePercentage).div(100);
            super._transfer(sender, recipient, amount.sub(transferFee));
        } else {
            super._transfer(sender, recipient, amount);
        }
    }
}
