
// Q4 Input:
// void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
// {
//     Player* player = g_game.getPlayerByName(recipient);
//     if (!player) {
//         player = new Player(nullptr);
//         if (!IOLoginData::loadPlayerByName(player, recipient)) {
//             return;
//         }
//     }

//     Item* item = Item::CreateItem(itemId);
//     if (!item) {
//         return;
//     }

//     g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

//     if (player->isOffline()) {
//         IOLoginData::savePlayer(player);
//     }
// }

// the main issue with the code is the memory managment. I would use smart pointers and ownership transfer to handle this properly.
// I assumed that g_game.getPlayerByName can return a smart pointer instead of a raw pointer.

#include <memory>

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId) {
    std::shared_ptr<Player> player = g_game.getPlayerByName(recipient);

    if (!player) {
        player = std::make_shared<Player>(nullptr);
        if (!IOLoginData::loadPlayerByName(player.get(), recipient)) {
            return; // Automatically deallocated if load fails
        }
    }

    std::shared_ptr<Item> item(Item::CreateItem(itemId));
    if (!item) {
        return; // Automatically deallocated if item creation fails
    }

    g_game.internalAddItem(player->getInbox(), item.get(), INDEX_WHEREEVER, FLAG_NOLIMIT);
    item.reset(); // Explicitly release the item to avoid deleting it after addition

    if (player->isOffline()) {
        IOLoginData::savePlayer(player.get());
        // No need to manually manage memory or release ownership
    }
}