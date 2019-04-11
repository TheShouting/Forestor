# Forrester Design Document

## Controls

- Navigate character in the 4 cardinal directions by touching the edge of the screen
- Press the center of the screen to wait a turn
- Any actor can pick up an item directly underneath them by waiting. If the are already holding an item in the same slot then the items or swapped.


## Weapons and Items

### Item Stats

* **Integrity**
Starts at 100 and degrades each time the item is used. When integrity reaches 0 then the item is removed from the player (and game).
* **Strength**
The amount of strength required in order for the actor to fully use the weapon.
* **Attack**
The amount of damage dealt to an actor with a successful hit
* **Defense**
The amount of damage reduced if the wielder is hit
* **Effect**
What effect is applied to the actor that holds this
* **"Consume** 
Is immediately consumed when picked up by an actor
* **Hand**
This is the slot from which the player wields the item (right, left, and hold)

Attack = weapon.attack + random(str)


### Right-Hand Items
+ Sword -increases the wielders attack (*hit action*)
+ Axe - can chop down trees (*key action*)
+ Pick - can mine through cliffs (*key action*)
+ Hammer - knocks an enemy back a space
+ Club - stuns attacker
+ Staff - has minimal effect by itself but can amplify any magical properties applied to it.

### Left-Hand Items
+ Shield - reduces the amount of damaged received 
(*defend action*)
+ Cloak - reduce environment effects (*passive action*)
+ Hand Axe - can chop down trees (*key action*)
+ Hand pick - can mine through cliffs (*key action*)
+ Charm - amplifies magical properties applied to it
+ Dagger - counter-attack (*defend action*)

## Effects

### Positive Effects
* War - increase damage based on wielders strength
Requires actor, prop (*attack*)

* Deadly - add bleeding damage
(*attack action / add effect*)

* Terrible - causes enemies to flee when struck
(*attack action / swap controller*)

* Heirloom - item does not degrade (or degrades much slower)
(*Degrade Action* `integrity += 1`)

* Hooked - random change for enemy to drop one off their items
(*Attack action*)

* Powerful - degrades enemy items
(*Attack action*)

### Negative Effects
* Heavy - requires a higher strength level

* Trapped - cannot be unequipped

* Brittle - item degrades faster
* Broken - All other effects are disabled
* Rusty - reduced damage
* Infuriating - makes the defender hyper-aggressive

# Level Generation

Levels are structurally a connected graph. Each node in the graph is assigned a stage depending on how many connections it has.

* Endpoint - only one connection
* Passage - two connections (one in and one out)
* Crossroads - three or more connections




