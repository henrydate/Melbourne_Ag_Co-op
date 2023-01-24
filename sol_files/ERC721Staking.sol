pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

//The Contract is built to be compatible with ERC721 and ERC20 Tokens
// The contract ERC20Staking avoids the most common problem of reentrancy and can pause the functionality is remediation is pending.
// The contract is iniatialised aas a OWnable contract to inherit and grant the basic authorization control functions which simplifies the implementation of "user permissions".
contract ERC721Staking is Ownable, ReentrancyGaurd, Pausable {
    // Inheriting the properties of SafeERC20 withing the contract
    using SafeERC20 for IERC20;
    // ERC20 token which will be redistributed to owners as a dividen
    IERC20 public immutable rewardToken;
    // ERC721 Token which will be used to buy the property.
    IERC721 public immutable coinCollection;
    //Declaring a constant which holds the number of seconds in a hour
    uint256 constant SECONDS_PER_HOUR = 3600;
    //Creating a Struct which holds the buy/staking details of the users
    struct Staker {
        //Creating a variable which stores the array of TokenId's staked by the users.
        unit256[] stakedTokenIds;
        // Creating the variable which shows the number of Tokens which are not claimed by the user
        uint256 unclaimedRewards;
        // Creating a variable which holds the timestamp of last update of the rewards
        uint256 timeOfLastUpdate;
    }
    // Creating a variable to hold the number of tokens accured per hour.
    uint256 private rewardsPerHour = 100000;
    // Mapping buyers/stakers to theie buying/staking info.
    mapping(address => Staker) public stakers;
    // Mapping Token ID to staker Address
    mapping(uint256=> address) public stakerAddress;
    // Creating a variable which holds the Array of stakers/buyers address
    address[] public stakersArray;
    // Cfreating a constructor to initialise ERC20 and ERC721 Interfaces. 
    constructor(IERC721 _coinCollection, IERC20 _rewardToken){
        //parameter _coinCollection holds the address iof the ERC721 collection
        coinCollection = _coinCollection;
        // parameter _rewardToken holds the address of ERC20 Reward Tokens
        rewardToken = _rewardToken;
    }
    // Creating a function to stake/buy ERC721 Tokens
    // Parameter _tokenIDs holds the information of the array of Token IDs to stake
    // Clause whenNotPaused helps the modifier throw when the contract is paused by calling pause function
    function stake(uint256[] calldata _tokenIds) external whenNotPaused {
        // Using storage to hold the data between the function calls.
        Staker storage staker = stakers[msg.sender];
        // Writing a if-else statement to stake.
        if (staker.stakedTokenIds.length > 0) {
            // Updating the rewards and returning a message to sender if the number of stakedTokenIDs are morethan 0
            updateRewards(msg.sender);
        } else {
            // Sending a message to staker of the length of staked TokenIds are less then 0 and updating the timestamp of the block
            stakersArray.push(msg.sender);
            staker.timeOfLastUpdate = block.timestamp;
        }
        // Creating a variable which holds the length of number of TokenIds
        uint256 len = _tokenIds.length;
        //Using a iterative for loop
        for (uint256 i; i < len; ++i) {
            // passing in a require condition(For better Error Handeling)
            require(
                // If the user isnt the owner of token, a "Can't stake tokens you don't own!" message is sent to the user.
                //If the user is the owner of the Token the information the condition is fuilfilled and moves on to next step.
                coinCollection.ownerOf(_tokenIds[i]) == msg.sender,
                "Can't stake tokens you don't own!"
            );
            // If theuser is the  owner of the Token, the token will be transferred from users address to the DAO address for the purpose of staking. 
            coinCollection.transferFrom(msg.sender, address(this), _tokenIds[i]);
            // appending _tokenIds[i] to a dynamic storage array at the end
            staker.stakedTokenIds.push(_tokenIds[i]);
            stakerAddress[_tokenIds[i]] = msg.sender;
        }
    } // Function End



    


}