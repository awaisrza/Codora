// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UseLessContract {
    string text;

    constructor() {
        text = "I Do Nothing";
    }

    function getText() public view returns (string memory) {
        return text;
    }
}

contract DeployerContract {
    address public UseLessContractAddress;
    UseLessContract public deployedUseLessContract;

    constructor() {}

    function deployUseLessContract() public {
        // Deploy the UseLessContract and store its address
        deployedUseLessContract = new UseLessContract();
        UseLessContractAddress = address(deployedUseLessContract);
    }

    function getUselessContractText() public view returns (string memory) {
        // Call the getText function of the deployed UseLessContract
        return deployedUseLessContract.getText();
    }
}
