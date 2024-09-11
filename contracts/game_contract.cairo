use starknet::ContractAddress;
use starknet_crypto::pedersen_hash;

#[starknet::interface]
trait IGameContract<TContractState> {
    /// Initializes a new game with two players
    fn create_game(ref self: TContractState, player1: felt252, player2: felt252);

    /// Commits a player's move with a hashed value
    fn commit_move(ref self: TContractState, game_id: felt252, player: felt252, move_hash: felt252);

    /// Reveals a player's move and nonce to validate the commitment
    fn reveal_move(ref self: TContractState, game_id: felt252, player: felt252, move: felt252, nonce: felt252);

    /// Returns the winner of the game (player1, player2, or draw)
    fn get_winner(self: @TContractState, game_id: felt252) -> felt252;

    /// Determines the winner based on both players' revealed moves
    fn determine_winner(ref self: TContractState, move1: felt252, move2: felt252) -> felt252;
}

#[starknet::contract]
mod GameContract {
    use starknet_crypto::pedersen_hash;
    use starknet::{ContractAddress, get_caller_address, storage_access::StorageBaseAddress};

    /// Storage for the game data
    #[storage]
    struct Storage {
        player1: felt252,
        player2: felt252,
        move1_commitment: felt252,
        move2_commitment: felt252,
        move1: felt252,
        move2: felt252,
        nonce1: felt252,
        nonce2: felt252,
        winner: felt252,
    }

    #[abi(embed_v0)]
    impl GameContract of super::IGameContract<ContractState> {
        /// Initializes a new game with two players.
        fn create_game(ref self: ContractState, player1: felt252, player2: felt252) {
            // Store player1 and player2 addresses
            self.player1.write(player1);
            self.player2.write(player2);
        }

        /// Commits a player's move by storing the hashed value.
        fn commit_move(ref self: ContractState, game_id: felt252, player: felt252, move_hash: felt252) {
            // Store the move commitment for the respective player
            let player2: felt252 = self.player2.read();
            let player1: felt252 = self.player1.read(); 

            if player == player1 {
                self.move1_commitment.write(move_hash);
            } else if player == player2 {
                self.move2_commitment.write(move_hash);
            } else {
                panic!("Invalid player");
            }
        }

        /// Reveals a player's move and checks if it matches their commitment.
        fn reveal_move(ref self: ContractState, game_id: felt252, player: felt252, move: felt252, nonce: felt252) {
            // Calculate the hash of the move and nonce
            let commitment = pedersen_hash(move, nonce);

            // Verify the commitment and store the revealed move
            if player == self.player1.read() {
                assert!(self.move1_commitment.read() == commitment, "Invalid commitment");
                self.move1.write(move);
                self.nonce1.write(nonce);
            } else if player == self.player2.read() {
                assert!(self.move2_commitment.read() == commitment, "Invalid commitment");
                self.move2.write(move);
                self.nonce2.write(nonce);
            } else {
                panic!("Invalid player");
            }

            // Determine the winner if both moves have been revealed
            if self.move1.read() != 0 && self.move2.read() != 0 {
                let winner = self.determine_winner(self.move1.read(), self.move2.read());
                self.winner.write(winner);
            }
        }

        /// Returns the winner of the game.
        fn get_winner(self: @ContractState, game_id: felt252) -> felt252 {
            // Return the game winner (player1, player2, or draw)
            self.winner.read()
        }

        /// Determines the winner based on the revealed moves.
        fn determine_winner(ref self: ContractState, move1: felt252, move2: felt252) -> felt252 {
            // Standard rock-paper-scissors logic:
            // 1: Rock, 2: Paper, 3: Scissors
            if move1 == move2 {
                0 // Draw
            } else if (move1 == 1 && move2 == 3) || (move1 == 2 && move2 == 1) || (move1 == 3 && move2 == 2) {
                self.player1.read() // Player 1 wins
            } else {
                self.player2.read() // Player 2 wins
            }
        }
    }
}
