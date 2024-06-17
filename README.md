# ZK-RockPaperScissors

**ZK-RockPaperScissors** is a blockchain-based decentralized game that implements the classic "Rock, Paper, Scissors" game. Players can compete against each other, place bets, and use Zero-Knowledge Proofs (ZKP) to hide their moves until they are revealed. The project is built on the StarkNet ecosystem and uses the Cairo programming language for smart contract implementation.

## Key Features

- **1 on 1 Game:** Players compete against each other in the classic "Rock, Paper, Scissors" game.
- **Betting:** Optionally, the game can be played for money, where each player places a bet, and the platform takes a 10% commission.
- **Use of ZKP:** Players' moves are hidden using Zero-Knowledge Proofs until they are revealed.
- **Move Timer:** Players have 1 minute to make a move. If no move is made within the time limit, the smart contract randomly selects a card.
- **Prize Distribution:** The winner receives the total bet amount minus the platform commission.
- **Statistics and Leaderboard:** Track game statistics and ranking system.
- **Play with Friends or Random Opponents:** Invite a specific opponent or play against a random opponent from the common pool.

## Installation and Setup

### Prerequisites

- [Cairo-lang](https://www.cairo-lang.org/docs/quickstart.html)

### Clone the Repository

```bash
git clone https://github.com/VadimLarinTech/ZK-RockPaperScissors.git
cd ZK-RockPaperScissors
