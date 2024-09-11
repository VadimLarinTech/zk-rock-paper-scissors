import subprocess

# Configuration for the test
CONTRACT_ADDRESS = "0xYourContractAddress"  # Replace with your contract address
PLAYER1_ADDRESS = 123456789  # Replace with player 1 address
PLAYER2_ADDRESS = 987654321  # Replace with player 2 address
GAME_ID = 1  # Replace with the game ID
MOVE_HASH = 0xHashOfMove  # Replace with the move hash
MOVE = 1  # Replace with the move to be revealed
NONCE = 123456  # Replace with the nonce
PROVIDER_URL = "https://testnet.starknet.io"  # Replace with the URL of your StarkNet provider

def main():
    # Form the command to run the test
    command = [
        "python", "contracts/tests/test_game_contract.py",
        CONTRACT_ADDRESS,
        str(PLAYER1_ADDRESS),
        str(PLAYER2_ADDRESS),
        str(GAME_ID),
        hex(MOVE_HASH),  # Convert MOVE_HASH to hex string
        str(MOVE),
        str(NONCE),
        PROVIDER_URL
    ]

    # Run the test
    subprocess.run(command)

if __name__ == "__main__":
    main()
