pragma solidity ^0.8.4;
// Importing required libraries
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/591c12d22de283a297e2b551175ccc914c938391/contracts/token/ERC721/ERC721.sol";
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/591c12d22de283a297e2b551175ccc914c938391/contracts/access/Ownable.sol";
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/591c12d22de283a297e2b551175ccc914c938391/contracts/utils/Counters.sol";
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/591c12d22de283a297e2b551175ccc914c938391/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


 // This is a simple NFT contract
 //Start of a contract
 //INitialising contract as a ERC721, ERC721Enumerable, Ownable contract.
 contract NFTCollection is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.counter;

    // Specifing the maximum supply
    uint256 maxSupply = 10000;
    // Initiatina a counter to store to be able to use Counters on uint265 without impacting the rest of the uint256 in the contract.
    //Counter helps to find every function from a single library to a type to reduce gass fee.
    Counters.Counter private _tokenIDCounter;
    // Initialising a constructor.
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol){}
        // ERC721 interface is initialised and the _name, _symbol details aere passed in to hold.
        //End of constructor. 
        //Start of function mint.
        //This function is used to mint ERC721 tokens. 
        //Mint function adds the capability to mint ERC721 tokens and assign it to a address which accepts user address, number of tokens as arguments. 

        function mint(address _user, uint256 _amount) public {
            //Start of for loop
            for(uint256 i;i<_amount;i++)
            {
                //Incrementing the  _tokenIdCounter by 1 using increment function.
                _tokenIdCounter.increment();
                // Creating a variable which stores the current value of _tokenIdCounter.
                uint256 tokenId = _tokenIdcounter.current();
                //Using safemint to mint ERC721 Tokens.
                _safeMint(_user,tokenId);
            }
        }//End of function mint. 

 }
