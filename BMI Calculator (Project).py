# BMI = (weight in lbs * 703) / (height in inches x height in inches)
# UW = below 18.5 BMI NW = 18.5-24.9 OW = 25-29.9 Obese = 30- 34.9 Severely obese = 35-39.9 Morbidly Obese = 40 and above
name = input("Enter your name: ")

weight = int(input("enter your weight in lbs : "))
height = int(input("enter your height in inches: "))               #i am 74 inches

BMI = (weight * 703) / (height * height)
print("your BMI is :", BMI)

if BMI > 0:
    if BMI < 18.5:
        print(name+ ", you are Under Weight. eat some food brother/sister")
    elif BMI <= 24.9:
        print(name + ", you are Normal Weight. keep it up you're doing great brother/sister")
    elif BMI <= 29.9:
        print(name + ", you are Over Weight. might wanna dial it back a little bit brother/sister")
    elif BMI <= 34.9:
        print(name + ", you are Obese.")
    elif BMI <= 39.9:
         print(name + ", you are Severely Obese")
    else :
     print(name + ", you are Morbidly Obese")