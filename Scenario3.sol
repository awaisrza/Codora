// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract debug{
    mapping(address => uint) public assets;

    function depositEther() public payable {
        assets[msg.sender] += msg.value;
    }

    function withdrawEther() public {
        uint asset = assets[msg.sender];
        require(asset > 0);

        (bool sent, ) = msg.sender.call{value: asset}("");
        require(sent, "Failed to send Ether");

        assets[msg.sender] = 0;
    }

    function getAssets() public view returns (uint) {
        return address(this).balance;
    }

}
//Fixed Code
//Reentracy Vulnerability
//Assets were updating after interaction
// Updated state before external interaction
function withdrawEther() public {
    uint asset = assets[msg.sender];
    require(asset > 0);

    assets[msg.sender] = 0;  

    (bool sent, ) = msg.sender.call{value: asset}("");
    require(sent, "Failed to send Ether");
}

//Must check the amount before deposit
function depositEther() public payable {
    require(msg.value > 0, "You must deposit some Ether");
    assets[msg.sender] += msg.value;
}
