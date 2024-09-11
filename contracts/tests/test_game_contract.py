from starknet_py import Contract
from starknet_py.net import Provider
import asyncio

async def test_game_contract(contract_address, player1, player2, game_id, move_hash, move, nonce, provider_url):
    """
    Tests the game contract by creating a game, committing a move, revealing a move, and getting the winner.

    Parameters:
    - contract_address: Address of the deployed game contract.
    - player1: Address of player 1.
    - player2: Address of player 2.
    - game_id: Identifier for the game.
    - move_hash: Hash of the player's move.
    - move: The move being revealed.
    - nonce: Nonce used for the commitment.
    - provider_url: URL of the StarkNet provider.
    """
    # Initialize the provider with the given URL
    provider = Provider(provider_url)

    # Load the contract at the specified address
    contract = Contract.from_address(contract_address, provider)

    # Create a new game with two players
    await contract.invoke(
        "create_game",
        (player1, player2),
    )
    print("Game created successfully.")

    # Commit a move for player 1
    await contract.invoke(
        "commit_move",
        (game_id, player1, move_hash),
    )
    print("Move committed successfully.")

    # Reveal the move for player 1
    await contract.invoke(
        "reveal_move",
        (game_id, player1, move, nonce),
    )
    print("Move revealed successfully.")

    # Get the winner of the game
    winner = await contract.call("get_winner", (game_id,))
    print(f"The winner is: {winner}")

# Run the test if the script is executed directly
if __name__ == "__main__":
    import sys
    if len(sys.argv) != 9:
        print("Usage: python test_game_contract.py <contract_address> <player1_address> <player2_address> <game_id> <move_hash> <move> <nonce> <provider_url>")
        sys.exit(1)

    contract_address = sys.argv[1]
    player1 = int(sys.argv[2])
    player2 = int(sys.argv[3])
    game_id = int(sys.argv[4])
    move_hash = int(sys.argv[5], 16)  # Convert hex string to int
    move = int(sys.argv[6])
    nonce = int(sys.argv[7])
    provider_url = sys.argv[8]

    # Run the test function
    asyncio.run(test_game_contract(contract_address, player1, player2, game_id, move_hash, move, nonce, provider_url))
