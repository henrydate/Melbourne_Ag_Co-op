//SPDX-License-Identifier: UNLISENCED
pragma solidity ^0.8.9;
//Importing required Libraries

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

 // This is a simple NFT contract
 //Start of a contract
 //INitialising contract as a ERC721, Ownable contract.
 contract NFTCollection is Ownable, ERC721 {
     // Address of staking contract.
    address public staking;
    //Constructor holds the value of staking address. 
    // The name of the token is set to "Nut" which holds the symbol "NUT"
    //Start of Constructor
    constructor(address _staking) ERC721("Nut", "NUT") {
        staking = _staking;
    }//End of Constructor.
    // The function mint allows us to add NUT Tokens into the supply which can only be done by owner.
    //Start of function
    function mint(address to, uint256 amount) external {
        //Using require clause to check the address is owners address.
        require(msg.sender == staking,"Nut::mint: only staking contract can mint");
        _mint(to, amount);
    }//End of function. 
    //This function is used to take NUT Tokens out of circulation. 
    //Start of function
    function burn(uint256 amount)external onlyOwner {
        _burn(amount);
    }//End of function mint
}//End of Contract
/* 
        |------------         |-----------------|           |--------------
        |                     |                 |           |
        |                     |                 |           |   
        |                     |                 |           |
        |                     |                 |           |
        |------------         |                 |           |---------------
        |                     |                 |           |           
        |                     |                 |           |               
        |                     |                 |           |           
        |                     |                 |           | 
        |-------------        |-----------------|           |


*/
    