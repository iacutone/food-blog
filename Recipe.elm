module Recipe exposing (..)

recipes : List{id: String, title: String, photo_src: String, description: String}
recipes =
    [ { id = "1"
      , title = "Kung Pao"
      , photo_src = "photos/kung-pao.webp"
      , description = """
# Kung Pao with Shrimp and Chicken

Checkout [this](https://www.youtube.com/watch?v=0KkkPZIDvj8) video by Kenji Alt-Lopez.

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

### Instructions
Add ginger and garlic and to wok and saute over medium heat. When garlic is golden brown, add wine and reduce. Push garlic/ginger mixture to the side and place chicken under oven burner with high heat until the outside it white. While the chicken cooks, add soy sauce and black vinegar. Make room in center of wok; add corn starch to liquid and mix until thick. Add the bell peppers and cook for two minutes, then add mushrooms/shrimp and cook for an additional minute. Turn off the burner and immediately add celery. Serve with peanuts and pepper corns.
"""
      }
    , { id = "2"
      , title = "Instant Pot: Eggs"
      , photo_src = "photos/eggs.webp"
      , description = """
# Tools
- [An Instant Pot](https://www.amazon.com/Instant-Pot-Multi-Use-Programmable-Pressure/dp/B00FLYWNYQ/ref=sr_1_3?dchild=1&keywords=instant+pot&qid=1588445648&sr=8-3)
- I like [this](https://www.amazon.com/gp/product/B078YP92Y6/ref=ppx_yo_dt_b_asin_title_o00_s02?ie=UTF8&psc=1) stackable egg steamer

# Ingredients
- eggs

# Instructions
- Time: 6 minutes
- Pressure: low
- Natural release for 5 minutes
- Place eggs in cold water bath for 4 minutes
"""
      }
    , { id = "3"
      , title = "Cold Brew Coffee"
      , photo_src = "photos/coffee.webp"
      , description = """
# Tools
- [One Gallon Ball Jar](https://www.target.com/p/ball-128oz-commemorative-glass-mason-jar-with-lid-super-wide-mouth/-/A-12794404)
- [Beverage Containier](https://www.amazon.com/gp/product/B00D04I6K4/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- [Cold Brew Bags](https://www.amazon.com/gp/product/B077YFNF6Q/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)

# Instructions
- coarsely grind 6 ounces of coffee
- fill Ball jar with water
- steep for 48 hours in a cool and dark location

"""
      }
    , { id = "4"
      , title = "Instant Pot: Yogurt"
      , photo_src = "photos/yogurt.webp"
      , description = """
# Tools
- [An Instant Pot](https://www.amazon.com/Instant-Pot-Multi-Use-Programmable-Pressure/dp/B00FLYWNYQ/ref=sr_1_3?dchild=1&keywords=instant+pot&qid=1588445648&sr=8-3)

# Ingredients
- whole milk
- plain yogurt

# Instructions
- Click Yogurt button, then click Adjust button to 'Boil' setting -- 1 hour
- Let milk cool for around two hours to 100 degreed Farhenheit
- Skim off milk skin
- Whisk in 2 spoonfuls of plain yogurt
- Click Adjust button to 8 or 24 hours
  - 8 hours for drinkable yogurt (I have not tried the 24 hour setting)
"""
      }
    ]
