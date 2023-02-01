# importing NFTCollection,  RewardToken, ERC721Staking, accounts, config from Brownie.
from brownie import NFTCollection, RewardToken, ERC721Staking, accounts, config

def main():
    account = accounts.add(config["wallets"]["from_key"])
    # Deploying RewardToken contract.
    token = RewardToken.deploy("RewardsToken", "RT", {"from": account}, publish_source=True)
    # Dpploying NFTCollection contract
    nft = NFTCollection.deploy("NFTCollection", "NFTC", {"from": account}, publish_source=True)
    #Deploying ERC721Staking Contract
    staking = ERC721Staking.deploy(nft.address, token.address, {"from": account}, publish_source=True)


