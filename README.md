## Objective

Jackpot! You've landed a summer gig in Las Vegas! Unfortunately, it's 2020, and the casinos are closed due to COVID-19. Your boss wants to move some of the business online and asks you to build a full-stack app — a simple slot machine game, with a little twist. Build it to ensure that the house always wins!

### Brief

When a player starts a game/session, they are allocated 10 credits.
Pulling the machine lever (rolling the slots) costs 1 credit.
The game screen has 1 row with 3 blocks.a
For players to win the roll, they have to get the same symbol in each block.
There are 4 possible symbols: cherry (10 credits reward), lemon (20 credits reward), orange (30 credits reward), and watermelon (40 credits reward).
The game (session) state has to be kept on the server.
If the player keeps winning, they can play forever, but the house has something to say about that...
There is a CASH OUT button on the screen, but there's a twist there as well.

### Tasks

-   Implement the assignment using any language or framework you feel comfortable with
-   When a user opens the app, a session is created on the server, and they have 10 starting credits.
-   **Server-side:**

    -   When a user has less than 40 credits in the game session, their rolls are truly random.
    -   If a user has between 40 and 60 credits, then the server begins to slightly cheat:
        -   For each winning roll, before communicating back to the client, the server does one 30% chance roll which decides if the server will re-roll that round.
        -   If that roll is true, then the server re-rolls and communicates the new result back.
    -   If the user has above 60 credits, the server acts the same, but in this case the chance of re-rolling the round increases to 60%.
        -   If that roll is true, then the server re-rolls and communicates the new result back.
    -   There is a cash-out endpoint that moves credits from the game session to the user's account and closes the session.

-   **Client side:**
    -   Include a super simple, minimalistic table with 3 blocks in 1 row.
    -   Include a button next to the table that starts the game.
    -   The components for each sign can be a starting letter (C for cherry, L for lemon, O for orange, W for watermelon).
    -   After submitting a roll request to the server, all blocks should enter a spinning state (can be 'X' character spinning).
    -   After receiving a response from the server, the first sign should spin for 1 second more and then display the result, then display the second sign at 2 seconds, then the third sign at 3 seconds.
    -   If the user wins the round, their session credit is increased by the amount from the server response, else it is deducted by 1.
    -   Include a button on the screen that says "CASH OUT", but when the user hovers it, there is a 50% chance that the button moves in a random direction by 300px, and a 40% chance that it becomes unclickable (this roll should be done on the client-side). If they succeed to hit it, credits from the session are moved to their account.
-   Write tests for your business logic

### Evaluation Criteria

-   Completeness: did you complete the features as briefed?
-   Correctness: Does the solution perform in sensible, thought-out ways?
-   Maintainability: is the code written in a clean, maintainable way?
-   Testing: was the system adequately tested?

### CodeSubmit

Please organize, design, test, and document your code as if it were going into production - then push your changes to the master branch. After you have pushed your code, you may submit the assignment on the assignment page.

All the best and happy coding,

The SignWell Team

# Implementation Plan 

## Tech Stack
  - Backend: Ruby 3 - Rails 8
  - Frontend: React JS + Vite(vite_rails) for bundling - Vite is fast dev, small prod build
  - Testing : Rspec for backentd , Jest/React testing for frontend
  - Database: PostgreSQL
  - Auth/Session: Cookie reveal auth later: server session data in DB
  - Deploy: Kamal 2

## Architecture
  - MVC 
  - Domain Service
    - Slot Machine Service -> handles roll logic + symbols RNG (random number generation)
    - Reward Service  -> calculates reward
    - Cheat Logic Service -> applies re-roll cheat rules
    - Cash Out Service -> payout session credits to player, then close session
  - Controller (JSON) - 
    - Home (root)
    - API Only Mode : 
        - Game Sessions
        - Rolls
        - Cashouts
  - Models
    - Player (id, account_credits)
    - GameSession (id, player_id, credits, status, last_roll_at )
    - Roll (id, game_session_id, syboml:json ,reward, cheated:boolean)
    - Cashout (amount)

## Data Rules (brief)
  - Start credits = 10
  - 1 roll costs 1 credit
  - Symbol: C(10), L(20), O(30), W(40)
  - Win only when all 3 same
  - Cheat Rules:
    - if credit < 40 --> honest RNG
    - if 40..60: if roll is winning, 30% chance to re-roll
    - if > 60: if roll is winning, 60% chance to re-roll
  - Cash out moves game_session.credits --> player.account_credits and closes session. 

## API sketch (JSON)
  - POST /game_sessions => start a new game. return {id, credits}
  - GET /game_sessions/:id => show current game info. return { id, credits, status}
  - POST /rolls (session_id) => do one roll. cost 1 credit. return {symbols, win:boolean ,reward, credits}
  - POST /cash_outs (session_id) => move session credits to account. return { moved, account_credits}

## Client (React minimal)
  - 1x3 table of blocks. Letters: C/L/O/W
  - Buttons: Start, Roll, Cash Out
  - UX: after server reply, get calls at 1s,2s,3s. Spin with X while waiting.
  - CASHOUT hover trick (client only): 50% move by 300px random dir, 40% disable button temp.

    ### UI mockup

    ```
        Credits: 10         [Start Game]    [Roll]

        +---+---+---+
        | C | L | O |    (spins as 'X' while waiting)
        +---+---+---+

        [CASH OUT]      (hover prank: move/disable)
    ```



## End-to-end flow 
 - Player -> React UI -> POST /game_sessions (create) -> { credits: 10 }
 - Player clicks Roll -> React POST /rolls
 - Server: SlotMachineService.roll -> RewardService.check -> CheatLogicService.maybe_reroll
 - Server: Update GameSession.credits -> persists Roll
 - Server: JSON { symbols, win, reward, credits }
 - React: Show spinning -> reveal 1s/2s/3s -> update credits
 - Player hovers CASH OUT -> client prank: %50 move, %40 disable
 - Player clicks CASH OUT -> POST /cash_out -> session closes , player.account_credits += credits  updated.

## React Components 
  - App 
    - Header credits
       - Board
        - Cell (Symbol1 - X)
        - Cell (Symbol2 - X)
        - Cell (Symbol3 - X)
      - StartButton
      - RollButton
      - CashOutButton

## Testing 

 - Ruby on Rails - RSpec : 

    ```
    rspec spec
    ```

 - React JS  - Jest 
    ```
    npx jest 
    ```
