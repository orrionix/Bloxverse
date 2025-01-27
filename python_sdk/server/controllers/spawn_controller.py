from flask import jsonify
import random

# This function simulates spawning a coin character in Roblox
def spawn_coin_character(behavior):
    """
    Simulate the spawning of a coin character with specific behavior in the Roblox game world.
    
    :param behavior: The behavior of the coin character predicted by the AI model.
    :return: A dictionary with details about the spawned coin character.
    """

    # Simulate coin character properties (You can expand these based on your game mechanics)
    character_id = random.randint(10000, 99999)  # Simulating a unique character ID
    spawn_location = generate_random_spawn_location()
    
    # You can add more properties for the coin character based on the behavior
    character_attributes = {
        'behavior': behavior,  # This can be used to determine actions like movement or interaction
        'size': random.choice(['small', 'medium', 'large']),
        'color': random.choice(['gold', 'silver', 'bronze']),
        'rarity': 'common' if behavior[0][0] > 0.5 else 'rare',  # Example of behavior-based rarity
    }
    
    # Simulate the spawn action (in a real game, this would interface with Roblox or the game engine)
    spawn_details = {
        'character_id': character_id,
        'attributes': character_attributes,
        'spawn_location': spawn_location,
        'spawned_at': 'Roblox Game World'
    }
    
    return spawn_details

def generate_random_spawn_location():
    """
    Simulates the generation of a random spawn location within the game world.
    """
    # In a real scenario, this would be a random or predetermined point in the Roblox game world
    x = random.uniform(-100, 100)  # Random x coordinate
    y = random.uniform(0, 50)     # Random y coordinate (height or ground level)
    z = random.uniform(-100, 100)  # Random z coordinate
    
    return {'x': x, 'y': y, 'z': z}
