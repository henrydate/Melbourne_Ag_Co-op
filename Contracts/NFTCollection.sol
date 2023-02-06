pragma solidity ^0.8.9;
//Importing required Libraries

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

 // This is a simple NFT contract
 //Start of a contract
 //INitialising contract as a ERC721, Ownable contract.
 contract NFTCollection is Ownable, ERC721 {
     // Address of staking contract.
    address public staking;
    //Constructor holds the value of staking address. 
    // The name of the token is set to "Fruit" which holds the symbol "FRUIT"
    constructor(address _staking) ERC721("Fruit", "FRUIT") {
        staking = _staking;
    }
    

 }
    