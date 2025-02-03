import json
from web3 import Web3
from web3.exceptions import InvalidAddress


# Connect to a blockchain provider (e.g., Infura, Alchemy, or local node)
def connect_to_blockchain(provider_url):
    """
    Connect to a blockchain via Web3.
    
    :param provider_url: URL of the Ethereum node (Infura, Alchemy, or local node)
    :return: Web3 instance
    """
    try:
        # Initialize the Web3 connection
        w3 = Web3(Web3.HTTPProvider(provider_url))

        # Check if connected successfully
        if not w3.isConnected():
            raise ConnectionError("Unable to connect to the blockchain.")
        return w3
    except Exception as e:
        print(f"Error connecting to the blockchain: {e}")
        return None


def validate_wallet_address(w3, wallet_address):
    """
    Validate if the given wallet address is a valid Ethereum address.

    :param w3: Web3 instance
    :param wallet_address: The wallet address to validate
    :return: Boolean indicating if the address is valid
    """
    try:
        # Check if the address is valid
        return w3.isAddress(wallet_address)
    except InvalidAddress:
        return False


def get_token_balance(w3, wallet_address, token_contract_address, decimals=18):
    """
    Get the token balance of the specified wallet.

    :param w3: Web3 instance
    :param wallet_address: The wallet address to check
    :param token_contract_address: The contract address of the token
    :param decimals: The number of decimals of the token (default is 18 for most ERC20 tokens)
    :return: Token balance (in the smallest unit)
    """
    try:
        # ABI for ERC-20 token contract
        abi = json.loads(
            '[{"constant":true,"inputs":[{"name":"","type":"address"}],'
            '"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],'
            '"payable":false,"stateMutability":"view","type":"function"}]'
        )

        # Initialize contract
        contract = w3.eth.contract(address=token_contract_address, abi=abi)

        # Call the balanceOf function to get the balance
        balance = contract.functions.balanceOf(wallet_address).call()

        # Convert balance to a human-readable format (assuming 18 decimals for most tokens)
        return balance / (10 ** decimals)
    except Exception as e:
        print(f"Error getting token balance: {e}")
        return None


# Example usage:
if __name__ == "__main__":
    # Replace with actual provider URL (Infura, Alchemy, or local node)
    provider_url = "https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID"

    # Replace with actual wallet address
    wallet_address = "0xYourWalletAddress"

    # Replace with actual token contract address (e.g., for USDT or any ERC-20 token)
    token_contract_address = "0xTokenContractAddress"

    # Connect to blockchain
    w3 = connect_to_blockchain(provider_url)

    if w3:
        # Validate wallet address
        if validate_wallet_address(w3, wallet_address):
            print(f"Wallet address {wallet_address} is valid.")

            # Get token balance
            token_balance = get_token_balance(w3, wallet_address, token_contract_address)
            if token_balance is not None:
                print(f"Token balance: {token_balance}")
            else:
                print("Could not retrieve token balance.")
        else:
            print(f"Invalid wallet address: {wallet_address}")
