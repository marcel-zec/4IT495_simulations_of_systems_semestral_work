; CODE START ;
extensions [array]

globals [building-x building-y water-x water-y-min food-x food-y-max mud-x-max mud-y-min COUNTER NIGHT CHILDREN_MALES CHILDREN_FEMALES MALES FEMALES DAY-TICKS DAYS DEATHS CRUSHED SOLD_MALES SOLD_FEMALES SOLD_CHILDREN_FEMALES SOLD_CHILDREN_MALES MONEY]


; agents
breed [people person]
people-own [pace headx heady move goalx goaly]

breed [pigs pig]
pigs-own [pace
  headx heady
  move reverse-move standing sleep
  goalx goaly achieved
  age male
  death
  old-color
  pregnant pregnancy-duration
  estrus estrus-duration estrus-cycle
  mother
  sexual-maturity sexual-puberty sexual-admission maturity
  no-sex-days
]

undirected-link-breed [pregnancies pregnancy]
undirected-link-breed [children child]

to go
  sell-pigs
  ;DAY/NIGHT has 500 ticks
  if COUNTER mod DAY-TICKS = 0 [
    set DAYS DAYS + 1
    set NIGHT not NIGHT
    setup-farm
    if NIGHT = false [
      wake-up-pigs
    ]
  ]
  ;EVERY DAY
  if COUNTER mod (DAY-TICKS * 2) = 0 [
    set-pigs-older
    pigs-death
  ]

  ;EVERY 2/3 DAY
  if COUNTER mod (DAY-TICKS + (DAY-TICKS / 2)) = 0 [
    set-pigs-pregnant
    get-pigs-childbirth
    sell-pigs
  ]

  ;EVERY MONTH
  if COUNTER mod (DAY-TICKS * 2 * 31) = 0 [
    sell-pigs
    buy-food
  ]

;  if random-boolean and random-boolean [
;    animate-water
;  ]
  set COUNTER COUNTER + 1
  make-step
  crush-pigs
end

to make-step
  ask pigs[
    change-pig-color-in-building who
    grow-up-pig who

    if sleep = false [

      if standing > 10 and achieved = false [
        set reverse-move reverse-move + 1
      ]

    ifelse achieved [
      ifelse standing < 10 [
        set standing standing + 1
      ] ;standing a while when goal spo achieved
      [
        set standing 0
        ifelse NIGHT or (pregnant = true and pregnancy-duration <= 2) [
          pig-goal-building who
        ] [
          random-pig-goal who
        ]
        set achieved false
      ] ;else
    ] ;ifelse achieved
    [ ;else
      ifelse reverse-move > 0 [
      ;reverse when blocked by other agents
        ifelse(reverse-move <= 3)[
          set reverse-move reverse-move + 1
          jump (-1 * pace)
        ] ;ifelse  ifelse(reverse-move < 3)
        [
          set reverse-move 0
           set standing 0
        ] ;else
      ] ;ifelse  reverse-move > 0
      [ ;else
        facexy goalx goaly
        let moved false;
        ifelse(patch-ahead pace != nobody) and ;je v smere vobec nieco (dlazdica)?
        ((not any? turtles-on patch-ahead pace) or ;nikto z mnoziny vsetkych agentov nie je pred nim vo vzdialenosti
          ((count turtles-on patch-ahead pace = 1) and;ak je na dlazdici len jeden agent, som to asi ja
            (one-of turtles-on patch-ahead pace = self)) ;overim ci to teda nie som ja
        )[
          set moved true;
          jump pace       ;poskocenie
         ] [        ;else
          let angle 45
          if random-boolean [
            set angle 65
          ]
        ifelse(patch-right-and-ahead angle pace != nobody) and ;je v smere vobec nieco (dlazdica)?
        ((not any? turtles-on patch-right-and-ahead angle pace) or ;nikto z mnoziny vsetkych agentov nie je pred nim vo vzdialenosti
          ((count turtles-on patch-right-and-ahead angle pace = 1) and;ak je na dlazdici len jeden agent, som to asi ja
            (one-of turtles-on patch-right-and-ahead angle pace = self)) ;overim ci to teda nie som ja
          )[
            set moved true;
            right angle
            jump pace       ;poskocenie
          ] [ ;else
            set angle 45
            if random-boolean [
              set angle 65
            ]
          if(patch-left-and-ahead angle pace != nobody) and ;je v smere vobec nieco (dlazdica)?
          ((not any? turtles-on patch-left-and-ahead angle pace) or ;nikto z mnoziny vsetkych agentov nie je pred nim vo vzdialenosti
            ((count turtles-on patch-left-and-ahead angle pace = 1) and;ak je na dlazdici len jeden agent, som to asi ja
              (one-of turtles-on patch-left-and-ahead angle pace = self)) ;overim ci to teda nie som ja
            )[
              set moved true;
              left angle
              jump pace       ;poskocenie
            ]
          ]
      ]

      ifelse moved = true [
        let x round pxcor
        let y round pycor
        ;achieved goal destination
        if (x < (goalx + 3)) and (x > (goalx - 3))
         and
         (y < (goaly + 3)) and (y > (goaly - 3))
         [
            set achieved true
            set standing standing + 1

            ;inside building at night
            if (pxcor <= (building-x - 1)) and (pycor <= (building-y - 1)) and NIGHT [
              set sleep true
            ]
         ]
        ][;else moved
          set standing standing + 1
          ]

    ] ;else reverse-move > 0
   ] ;else achieved

  ] ;if sleep = false
 ]
end

to buy-food
  let babies-count count pigs with [age <= 50]
  let price-for-babies count-price-for-food babies-count 1 20 15

  let children-count count pigs with [age > 50 and age <= 90]
  let price-for-children count-price-for-food children-count 1.5 20 15

  let pregnant-count count pigs with [pregnant = true]
  let price-for-pregnant count-price-for-food pregnant-count 3 20 16

  let maturity-count count pigs with [pregnant = false and maturity = true]
  let price-for-maturity count-price-for-food maturity-count 3 20 16

  set MONEY (MONEY - price-for-babies - price-for-children - price-for-pregnant - price-for-maturity)
end

to-report count-price-for-food [amount-of-pigs kilo-for-pig weight-of-package price-for-package]
  if amount-of-pigs = 0 [
    report 0
  ]
  let kilos (amount-of-pigs * kilo-for-pig)
  let packages (kilos / weight-of-package) + 1
  report packages * price-for-package
end

to sell-pigs
  let sell-children-males false
  if CHILDREN_MALES > 12 and CHILDREN_FEMALES > 8 and count pigs with [pregnant = true] >= 1[
    set sell-children-males true
  ]

  if sell-children-males = true [
    let potencional count pigs with [male = true and maturity = false and age >= sexual-puberty]
    while [potencional > 0 and potencional <= 4] [
      sell-young-male-in-puberty-pig
      set potencional count pigs with [male = true and maturity = false and age >= sexual-puberty]
    ]
  ]

  set sell-children-males false
  if (CHILDREN_MALES + CHILDREN_FEMALES) > 50 and CHILDREN_MALES > (CHILDREN_FEMALES / 2) and count pigs with [pregnant = true] >= 1[
    set sell-children-males true
  ]

  if sell-children-males = true [
    let potencional count pigs with [male = true and maturity = false]
    while [potencional > 6] [
      sell-young-male-pig
      set potencional count pigs with [male = true and maturity = false]
    ]
  ]

  if FEMALES > 8 and count pigs with [pregnant = true] >= 6 [
    let potencional count pigs with [male = false and pregnant = false and maturity = true]
    while [potencional > 0] [
      sell-female-pig
      set potencional count pigs with [male = false and pregnant = false and maturity = true]
    ]
  ]

   while [CHILDREN_FEMALES > 18 and count pigs with [pregnant = true] >= 1] [
     sell-young-female-pig
   ]

  while [MALES > FEMALES / 2] [
     sell-male-pig
   ]


end

to sell-young-male-in-puberty-pig
      let min-age 999999999999999
      let id -1
      ask pigs with [male = true and maturity = false and age >= sexual-puberty] [
        if age < min-age [
          set min-age age
          set id who
        ]
      ]
  if id > -1 [
      ask pig id [
        set CHILDREN_MALES CHILDREN_MALES - 1
        set SOLD_CHILDREN_MALES SOLD_CHILDREN_MALES + 1
        set MONEY (MONEY + get-sell-price age)
        die
      ]
  ]
end

to sell-male-pig
      let max-age -1
      let id -1
      ask pigs with [male = true and maturity = true] [
        if age > max-age [
          set max-age age
          set id who
        ]
      ]
  if id > -1 [
      ask pig id [
        set MALES MALES - 1
        set SOLD_MALES SOLD_MALES + 1
        set MONEY (MONEY + get-sell-price age)
        die
      ]
  ]
end

to sell-young-male-pig
      let min-age 999999999999999
      let id -1
      ask pigs with [male = true and maturity = false] [
        if age < min-age [
          set min-age age
          set id who
        ]
      ]
  if id > -1 [
      ask pig id [
        set CHILDREN_MALES CHILDREN_MALES - 1
        set SOLD_CHILDREN_MALES SOLD_CHILDREN_MALES + 1
        set MONEY (MONEY + get-sell-price age)
        die
      ]
  ]
end

to sell-young-female-pig
      let min-age 999999999999999
      let id -1
      ask pigs with [male = false and size = 2] [
        if age < min-age [
          set min-age age
          set id who
        ]
      ]
  if id > -1 [
      ask pig id [
        set CHILDREN_FEMALES CHILDREN_FEMALES - 1
        set SOLD_CHILDREN_FEMALES SOLD_CHILDREN_FEMALES + 1
        set MONEY (MONEY + get-sell-price age)
        die
      ]
   ]
end


to sell-female-pig
      let max-age -1
      let id -1
      ask pigs with [male = false and pregnant = false and maturity = true] [
        if age > max-age [
          set max-age age
          set id who
        ]
      ]
  if id > -1 [

    if any? turtles with [mother = id] [
      ask pigs with [mother = id][
        set mother -1
      ]
    ]

      ask pig id [
        set FEMALES FEMALES - 1
        set SOLD_FEMALES SOLD_FEMALES + 1
        set MONEY (MONEY + get-sell-price age)
        die
      ]
  ]
end

to-report get-sell-price [pig-age]
  if pig-age < 124 [
    report 1 * random-normal 35 3
  ]
  if pig-age > 124 and pig-age <= 155 [
    report 1.2 * random-normal 60 3
  ]
  if pig-age > 155 and pig-age <= 217 [
    report 1.5 * random-normal 90 3
  ]
  if pig-age > 217 and pig-age <= 240 [
    report 1.75 * random-normal 90 3
  ]
  if pig-age > 240 and pig-age <= 730 [
    report 2 * random-normal 160 5
  ]
  if pig-age > 730 [
    report 3 * random-normal 260 9
  ]
end

to crush-pigs
ask pigs [
    let pig-size size
    let pig-male male
    ask patch-here [
      if count turtles-on neighbors >= 8 and pig-size = 2 [
        ask myself [
          die
        ]
        set DEATHS DEATHS + 1
        set CRUSHED CRUSHED + 1
        ifelse pig-male [
          set CHILDREN_MALES CHILDREN_MALES - 1
        ][
          set CHILDREN_FEMALES CHILDREN_FEMALES - 1
        ]
       ]

      if count turtles-on neighbors >= 9 and pig-size = 3 [
        ask myself [
          die
        ]
        set DEATHS DEATHS + 1
        set CRUSHED CRUSHED + 1
        ifelse pig-male [
          set CHILDREN_MALES CHILDREN_MALES - 1
        ][
          set CHILDREN_FEMALES CHILDREN_FEMALES - 1
        ]
       ]
      ]
    ]
end

to setup
  clear-all        ;global reset
  set COUNTER 0
  set DEATHS 0
  set CRUSHED 0
  set MONEY 500
  set SOLD_MALES 0
  set SOLD_FEMALES 0
  set SOLD_CHILDREN_FEMALES 0
  set SOLD_CHILDREN_MALES 0
  set NIGHT true
  set DAY-TICKS 500
  set building-x 60
  set building-y 15
  set water-x 74
  set water-y-min 14
  set food-x 74
  set food-y-max 15
  set mud-x-max 36
  set mud-y-min 18

  setup-farm
  setup-pigs
end

to setup-farm
  ask patches [
    ifelse NIGHT [set pcolor green - 4][set pcolor green - 3]
    let x pxcor    ; x = Patches.thisPatchXcor
    let y pycor

    setup-building x y
    setup-water x y
    setup-mud x y
    setup-food x y
  ]
end

to animate-water
  ask patches [
    let x pxcor
    let y pycor
    setup-water x y
  ]
end

to setup-building [x y]

    if ((x > -1) and (x < building-x) and (y > -1) and (y < building-y))
    [
     set pcolor brown + 3
    ]
    if ((x > -1) and (x < building-x) and (y > 1) and (y < 13))
    [
     set pcolor brown + 2
    ]
    if ((x > -1) and (x < building-x) and (y > 4) and (y < 10))
    [
     set pcolor brown + 1
    ]
     if ((x > -1) and (x < building-x) and (y > 6) and (y < 8))
    [
     set pcolor black + 3
    ]
end

to setup-water [x y]
  if ((x > water-x) and (x < 81) and (y > water-y-min) and (y < 34))[
     ifelse random-boolean [
      ifelse NIGHT [set pcolor blue - 1][set pcolor blue + 1]
     ][
      ifelse NIGHT [set pcolor blue - 2][set pcolor blue + 2]
     ]
  ]
end

to setup-food [x y]
  if ((x > food-x) and (x < 81) and (y > -1) and (y < 15))
  [
    ifelse random-boolean [
       ifelse NIGHT [set pcolor yellow - 2][set pcolor yellow + 2]
    ][
       ifelse NIGHT [set pcolor yellow - 3][set pcolor yellow + 3]
    ]
  ]
end

to setup-mud [x y]
     if ((x > -2) and (x < mud-x-max) and (y > 20) and (y < 34))
    [
     ifelse NIGHT [set pcolor brown - 4][set pcolor brown - 2]
    ]
    if ((x > 32) and (x < mud-x-max) and (y > 20) and (y < 34))
    or
    (((x > -2) and (x < mud-x-max) and (y > mud-y-min) and (y < 22)))
    [
     ifelse NIGHT [set pcolor brown - 3][set pcolor brown - 1]
    ]
end

to setup-people
  create-people 1
  ask people [
    set color blue
    setxy random-pxcor random-pycor
    set size 3
    set pace random-normal 1 0.2
    set move true
  ]
end

;Create pigs. Order of creation is important. Females needs to be first, because they can be mother of chilren.
to setup-pigs

  set FEMALES INIT_FEMALES
  create-pigs INIT_FEMALES [
    set color pink - 1
    set old-color color
    let x random-pxcor mod (building-x - 1)
    let y random-pycor mod (building-y - 1)
    setxy x y
    set size 4
    set pace random-normal 0.8 0.2
    set move true
    set standing 0
    set achieved false
    set sleep false
    set male false
    set death false
    set age (1460 + (add-random-in-range 1460 2920))
    set maturity true
    set estrus-cycle get-new-estrus-cycle-number maturity
    set estrus-duration 0
    set estrus false
    set sexual-maturity get-new-sexual-maturity-number
    set sexual-puberty round sexual-maturity / 1.75
    set sexual-admission get-new-sexual-admission-number
    set pregnancy-duration get-new-pregnancy-duration-number
    set pregnant false
    set no-sex-days 0
    random-pig-goal who
  ]

  set CHILDREN_MALES INIT_CHILDREN_MALES
   create-pigs INIT_CHILDREN_MALES [
    set color pink
    set old-color color
    let x random-pxcor mod (building-x - 1)
    let y random-pycor mod (building-y - 1)
    setxy x y
    set size 2
    set pace random-normal 0.8 0.2
    set move true
    set standing 0
    set achieved false
    set sleep false
    set male true
    set death false
    set maturity false
    set estrus-cycle 0
    set estrus-duration 0
    set estrus false
    set pregnant false
    set sexual-maturity get-new-sexual-maturity-number
    set sexual-puberty round sexual-maturity / 1.75
    set age random-poisson 30
    if age >= sexual-puberty [
      set size 3
    ]
    set sexual-admission get-new-sexual-admission-number
    set mother random INIT_FEMALES
    set no-sex-days 0
    random-pig-goal who
  ]

  set CHILDREN_FEMALES INIT_CHILDREN_FEMALES
  create-pigs INIT_CHILDREN_FEMALES [
    set color pink + 1
    set old-color color
    let x random-pxcor mod (building-x - 1)
    let y random-pycor mod (building-y - 1)
    setxy x y
    set size 2
    set pace random-normal 0.8 0.2
    set move true
    set standing 0
    set achieved false
    set sleep false
    set male false
    set death false
    set maturity false
    set estrus-cycle get-new-estrus-cycle-number maturity
    set estrus-duration 0
    set estrus false
    set pregnant false
    set sexual-maturity get-new-sexual-maturity-number
    set sexual-puberty round sexual-maturity / 1.75
    set age random-poisson 30
    if age >= sexual-puberty [
      set size 3
    ]
    set sexual-admission get-new-sexual-admission-number
    set mother random INIT_FEMALES
    set pregnancy-duration get-new-pregnancy-duration-number
    set pregnant false
    set no-sex-days 0
    random-pig-goal who
  ]

  set MALES INIT_MALES
  create-pigs INIT_MALES [
    set color pink - 2
    set old-color color
    let x random-pxcor mod (building-x - 1)
    let y random-pycor mod (building-y - 1)
    setxy x y
    set size 4
    set pace random-normal 0.8 0.2
    set move true
    set standing 0
    set achieved false
    set sleep false
    set male true
    set death false
    set maturity true
    set age (1460 + (add-random-in-range 1460 2920))
    set estrus-cycle 0
    set estrus-duration 0
    set estrus false
    set pregnant false
    set sexual-maturity get-new-sexual-maturity-number
    set sexual-puberty round sexual-maturity / 1.75
    set sexual-admission get-new-sexual-admission-number
    set no-sex-days 0
    random-pig-goal who
  ]
end

to random-pig-goal [id]
  ask pig id [
    ifelse age < 7 [
      pig-goal-building who
    ][
      ifelse age < sexual-puberty and mother > -1 and random-boolean = true [
        let x 0
        let y 0
        ifelse any? turtles with [who = mother][
          ask pig mother [
            set x goalx
            set y goaly
          ]
          set goalx x
          set goaly y
        ][
          pig-goal-random who
        ]
      ][
        let number random 55;
        ifelse random-boolean [
          pig-goal-random who
        ][
          ifelse number mod 2 = 0 [
            pig-goal-mud who
          ][
            ifelse number mod 3 = 0 [
              pig-goal-food who
            ][
              pig-goal-water who
            ] ;else number mod 3 = 0
          ] ;else number mod 2 = 0
        ] ;else random-boolean
      ]; else age < 120
    ] ;else age < 30
  ]
end

to change-pig-color-in-building [id]
  ask pig id [
    ifelse (pxcor <= (building-x - 1)) and (pycor <= (building-y - 1))[
      ifelse NIGHT [
          set color old-color
      ]
        [
          set color pink - 4
        ]
      ]
    [
      ifelse NIGHT [
       set color pink - 4
    ][
        set color old-color
      ]
    ]
  ]
end

to set-pigs-pregnant
  ask pigs with [maturity = true and male = false and estrus = true and pregnant = false] [
    if MALES > 0 [
      let sex false;
      let success false;
      if any? pigs with [maturity = true and male = true and no-sex-days > 3] [
        ask one-of pigs with [maturity = true and male = true and no-sex-days > 3] [
          let probability (70 + random 30)
          if no-sex-days > 6 [
            set probability (probability - (no-sex-days * 1.1))
          ]
          ifelse random 100 <= probability [
            set success true
            set sex true
            create-pregnancy-with myself
            set no-sex-days 0
            ask my-pregnancies [
              set color yellow
            ]
          ][
            set no-sex-days 0
            set sex true
          ]
        ]

        if sex = true [
          set no-sex-days 0
        ]

        if success = true [
          set pregnant true
        ]
      ]
    ]
  ]
end

to pigs-death
  ask pigs [
    if death [
      ifelse age >= 220 [
        ifelse male = true [
          set MALES MALES - 1
        ][
          set FEMALES FEMALES - 1
        ]
      ][
        ifelse male = true [
          set CHILDREN_MALES CHILDREN_MALES - 1
        ][
          set CHILDREN_FEMALES CHILDREN_FEMALES - 1
        ]
      ]
     set DEATHS DEATHS + 1
     ask my-pregnancies [ die ]
    ]

    if ( age / 365 ) > 15 [
      ifelse ( age / 365 ) > 20[
      if random 25 = 1 [
        set death true
      ]
      ][
        if random 80 = 1 [
          set death true
        ]
      ]
    ]
  ]
end

to grow-up-pig [id]
  ask pig id [
    if maturity = false [

     if sexual-puberty <= age [
       set size 3
     ]

     if sexual-maturity <= age [
      set maturity true
      set size 4
        ifelse male = true [
          set color pink - 2
          set old-color color
          set MALES MALES + 1
          set CHILDREN_MALES CHILDREN_MALES - 1
        ][
          set color pink - 1
          set old-color color
          set FEMALES FEMALES + 1
          set CHILDREN_FEMALES CHILDREN_FEMALES - 1
        ]
      ]
    ]
  ]
end

to wake-up-pigs
  ask pigs [
     set sleep false
  ]
end

;Pigs gets older. Count estrus duration for maturity females and no-sex days fro maturity males.
to set-pigs-older
  ask pigs [
    set age age + 1
  ]

  ask pigs with [male = false and maturity = true][
    if estrus-cycle > 0 [ ;has estrus cycle
      if estrus-duration > 0 [
        ;estrus starts between 4,5 - 5,5 days after sex cycle started
        ifelse estrus-duration >= 4 and estrus-duration <= 6 [
          set estrus true
        ][
          set estrus false
        ]
      ]
      ifelse estrus-duration > estrus-cycle [
          ;renew estrus cycle
          set estrus-duration 0
          set estrus-cycle get-new-estrus-cycle-number maturity
      ][
        set estrus-duration estrus-duration + 1
      ]
    ]

    if pregnant = true [
      set pregnancy-duration (pregnancy-duration - 1)
    ]
  ]

  ask pigs with [maturity = true][
    set no-sex-days no-sex-days + 1
  ]
end

to get-pigs-childbirth

  ask pigs with [pregnant = true and pregnancy-duration = 0] [
    let mother-id who
   set estrus-cycle get-new-estrus-cycle-number maturity
   set estrus-duration 0
   set estrus false
   set pregnant false
   set pregnancy-duration get-new-pregnancy-duration-number
   set no-sex-days 0
   ask my-pregnancies [ die ]
   let number-of-newborn round random-normal 12 1
    hatch number-of-newborn [
    ifelse random-boolean [
      set color pink + 1
      set old-color color
      let x random-pxcor mod (building-x - 1)
      let y random-pycor mod (building-y - 1)
      setxy x y
      set size 2
      set pace random-normal 0.8 0.2
      set move true
      set standing 0
      set achieved false
      set sleep false
      set male false
      set death false
      set age 0
      set maturity false
      set estrus-cycle get-new-estrus-cycle-number maturity
      set estrus-duration 0
      set estrus false
      set sexual-maturity get-new-sexual-maturity-number
      set sexual-puberty round sexual-maturity / 1.75
      set sexual-admission get-new-sexual-admission-number
      set pregnancy-duration get-new-pregnancy-duration-number
      set pregnant false
      set no-sex-days 0
      set mother mother-id
      set CHILDREN_FEMALES CHILDREN_FEMALES + 1
    ][
      set color pink
      set old-color color
      let x random-pxcor mod (building-x - 1)
      let y random-pycor mod (building-y - 1)
      setxy x y
      set size 2
      set pace random-normal 0.8 0.2
      set move true
      set standing 0
      set achieved false
      set sleep false
      set male true
      set death false
      set age 0
      set maturity false
      set estrus-cycle 0
      set estrus-duration 0
      set estrus false
      set pregnant false
      set sexual-maturity get-new-sexual-maturity-number
      set sexual-puberty round sexual-maturity / 1.75
      set sexual-admission get-new-sexual-admission-number
      set no-sex-days 0
      set mother mother-id
      set CHILDREN_MALES CHILDREN_MALES + 1
      ]
   ]
  ]
end


;Set goalx and goaly attributes to 'water' destiantion for pig with given ID.
;[id] - pig who attribute
to pig-goal-water [id]
  ask pig id [
    set goalx water-x
    set goaly water-y-min + (add-random-in-range (water-y-min + 1) 31)
  ]
end

;Set goalx and goaly attributes to 'food' destiantion for pig with given ID.
;[id] - pig who attribute
to pig-goal-food [id]
  ask pig id [
     set goalx food-x
     set goaly 1 + (add-random-in-range 1 (food-y-max - 1))
  ]
end

;Set goalx and goaly attributes to 'mud' destiantion for pig with given ID.
;[id] - pig who attribute
to pig-goal-mud [id]
  ask pig id [
     set goalx (1 + (add-random-in-range 1 (mud-x-max - 1)))
     set goaly (mud-y-min + (add-random-in-range (mud-y-min + 1) 31))
  ]
end

;Set goalx and goaly attributes to 'random' destiantion for pig with given ID.
;[id] - pig who attribute
to pig-goal-random [id]
  ask pig id [
     set goalx (1 + (add-random-in-range 1 63))
     set goaly (1 + (add-random-in-range 1 31))
  ]
end

;Set goalx and goaly attributes to 'building' destiantion for pig with given ID.
;[id] - pig who attribute
to pig-goal-building [id]
  ask pig id [
     set goalx (0 + (add-random-in-range 1 (building-x - 1)))
     set goaly (0 + (add-random-in-range 1 (building-y - 1)))
  ]
end

to-report get-new-estrus-cycle-number [pig-maturity]
  let number 21
  let difference random-normal 2 0.5
  ifelse pig-maturity = true [
    set number (number + difference)
  ][
    set number (number - difference)
  ]
  report round number
end

to-report get-new-sexual-maturity-number
  let number 201
  let difference random-normal 5 0.5
  ifelse random-boolean = true [
    set number (number + difference)
  ][
    set number (number - difference)
  ]
  report round number
end

to-report get-new-sexual-admission-number
  let number 230
  let difference random-normal 8 0.5
  ifelse random-boolean = true [
    set number (number + difference)
  ][
    set number (number - difference)
  ]
  report round number
end

to-report get-new-pregnancy-duration-number
  let number 115
  let difference random 5
  ifelse random-boolean = true [
    set number (number + difference)
  ][
    set number (number - difference)
  ]
  report round number
end

to-report get-new-insemination-probability-number
  let number 70
  let difference random 30
  report number + difference
end

;Get random boolean.
to-report random-boolean
 let number random 10
  let boolean number mod 2 = 0
  report boolean
end

to-report add-random-in-range [min-range max-range]
  let number random max-range
  let modulo-number number mod max-range
;  print "range min"
;  print min-range
;  print "range max"
;  print max-range
  if modulo-number + min-range > max-range [
;    print modulo-number
    report modulo-number - min-range
  ]
;  print modulo-number
  report modulo-number
end


; CODE END ;
@#$#@#$#@
GRAPHICS-WINDOW
210
10
1352
481
-1
-1
14.0
1
10
1
1
1
0
0
0
1
0
80
0
32
0
0
1
ticks
30.0

BUTTON
143
269
206
302
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
142
443
206
477
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
34
194
206
227
INIT_CHILDREN_MALES
INIT_CHILDREN_MALES
0
4
0.0
1
1
NIL
HORIZONTAL

MONITOR
33
12
102
57
NIL
COUNTER
0
1
11

MONITOR
106
11
163
56
NIL
NIGHT
17
1
11

SLIDER
34
157
206
190
INIT_FEMALES
INIT_FEMALES
0
10
2.0
1
1
NIL
HORIZONTAL

SLIDER
34
120
206
153
INIT_MALES
INIT_MALES
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
33
232
207
265
INIT_CHILDREN_FEMALES
INIT_CHILDREN_FEMALES
0
4
0.0
1
1
NIL
HORIZONTAL

MONITOR
27
311
84
356
NIL
MALES
17
1
11

MONITOR
89
311
203
356
NIL
CHILDREN_MALES
17
1
11

MONITOR
29
362
85
407
NIL
FEMALES
17
1
11

MONITOR
89
361
201
406
NIL
CHILDREN_FEMALES
17
1
11

MONITOR
13
412
71
457
DEATH
DEATHS
17
1
11

MONITOR
9
64
66
109
DAYS
DAYS
17
1
11

MONITOR
77
411
134
456
ALIVE
MALES + FEMALES + CHILDREN_MALES + CHILDREN_FEMALES
17
1
11

MONITOR
82
508
176
553
PREGNANCIES
count pigs with [pregnant = true]
17
1
11

MONITOR
15
460
82
505
NIL
CRUSHED
17
1
11

MONITOR
73
63
135
108
MONTHS
DAYS / 31
1
1
11

MONITOR
142
62
192
107
YEARS
(DAYS / 31) / 12
1
1
11

MONITOR
346
519
450
564
NIL
SOLD_MALES
17
1
11

MONITOR
346
566
450
611
NIL
SOLD_FEMALES
17
1
11

MONITOR
451
519
602
564
NIL
SOLD_CHILDREN_MALES
17
1
11

MONITOR
451
566
602
611
NIL
SOLD_CHILDREN_FEMALES
17
1
11

MONITOR
604
544
671
589
SOLD
SOLD_MALES + SOLD_FEMALES + SOLD_CHILDREN_FEMALES + SOLD_CHILDREN_MALES
17
1
11

MONITOR
1396
45
1502
90
NIL
MONEY
2
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
