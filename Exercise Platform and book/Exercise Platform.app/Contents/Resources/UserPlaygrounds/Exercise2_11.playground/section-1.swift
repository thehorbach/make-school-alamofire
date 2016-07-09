var hp = 75

// your code here




if hp >= 10 && hp % 10 != 0 {
    let k = hp % 10
    hp = hp - k + 10
} else if hp < 20 && hp > 0 {
    hp = 20
}

print(hp)





