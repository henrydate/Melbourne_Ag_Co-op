pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

//The Contract is built ti be cimpatible with ERC721 and ERC20 Tokens
// The contract ERC20Staking avoinds the most common problem of reentrancy and can pause the functionality is remediation is pending. 
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
    }
    // Creating a variable to hold the number of tokens accured per hour.
    uint256 private rewardsPerHour = 100000;
    // Mapping buyers/stakers to theie buying/staking info.
    mapping(address => Staker) public stakers;
    // Mapping Token ID to staker Address
    mapping(uint256=> address) public stakerAddress;
    // Creating a variable which holds the Array of stakers/buyers address
    address[] public stakersArray;
    


}