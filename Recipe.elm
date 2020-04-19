module Recipe exposing (recipes)


recipes :
    List
        { id : String
        , title : String
        , small_photo_src : String
        , photo_src : String
        , description : String
        , path : String
        }
recipes =
    [ { id = "1"
      , title = "Kung Pao"
      , small_photo_src = "photos/3-23-2018.JPG"
      , photo_src = "photos/3-23-2018.JPG"
      , path = "kung-pao"
      , description = """

# Kung Pao with Shrimp and Chicken

## Ingredients

### Aromatic
- thumbnail size ginger, minced
- 3 large cloves  garlic, minced
- tablespoon sichuan pepper corns, ground

### Meat
- 3 chicken breasts cut into 1/2 inch cubes
- 1/2 pound shrimp, optional

### Vegetable
- 2 green bell peppers, chopped
- 1 pound white mushrooms, chopped
- 2 sticks celery, chopped

### Sauce
- 1/4 cup black vinegar
- 1/4 cup white cooking wine
- 2 tablespoons corn starch
- 1/8 cup soy sauce

### Garnish
- salted peanuts

### Description
Add ginger and garlic and to wok and saute over medium heat. When garlic is golden brown, add wine and reduce. Push garlic/ginger mixture to the side and place chicken under oven burner with high heat until the outside it white. While the chicken cooks, add soy sauce and black vinegar. Make room in center of wok; add corn starch to liquid and mix until thick. Add the bell peppers and cook for two minutes, then add mushrooms/shrimp and cook for an additional minute. Turn off the burner and immediately add celery. Serve with peanuts and pepper corns.

### Other Notes
- between 5 - 7 servings
"""
      }
    ]
