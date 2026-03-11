# 🛹 Skate Rush            
           
**Skate Rush** is a fully on-chain arcade racing game built with Solidity. No tokens, no gambling — just pure decentralized skateboarding competition.        
        
Players register, join races, and compete on virtual tracks where both **skill and luck** determine the winner.      
          
> 💡 Inspired by retro racing vibes and modern blockchain tech.        
        
---       
        
## 🎮 Gameplay     
       
- ⛹️ Players register with a **skill level** from 1 to 10           
- 🏁 Create or join races with up to 10 players          
- 🎲 The winner is determined by **skill + randomness**       
- 📈 Compete for fun, bragging rights, and the leaderboard         
- 🔒 100% on-chain logic — transparent and immutable       
       
---      
     
## 🔧 Smart Contract Features    
   
| Feature        | Description                                       |
|----------------|---------------------------------------------------|
| Register       | Set your wallet and skill level (1-10)            |
| Create Race    | Launch a race with a custom player limit          |
| Join Race      | Enter a race before it starts                     |
| Auto Start     | Races start automatically when full               |
| Fair Finish    | Winner is chosen via `skill + randomness`         |
| No Tokens      | No payments, tokens, or bets involved             |
  
---

## 📦 Tech Stack

- **Solidity** (v0.8.24)
- EVM-compatible
- No dependencies
- Gas-efficient, simple logic

---

## 🚀 Deploy & Test

```bash
# Compile
npx hardhat compile

# Deploy to local/testnet
npx hardhat run scripts/deploy.js --network hardhat

# Run tests
npx hardhat test
