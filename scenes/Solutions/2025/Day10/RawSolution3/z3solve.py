from itertools import combinations
import z3
import json

# this is the part 2 solution from https://github.com/rdas3-bths/Advent2025/blob/main/Day10.py.
# instead of making my own solution with a custom solution or... figuring out z3... i took the opportunity to learn how to run stuff outside of godot.
# this is also a case where solving a very specific kind of problem with the tools built for that problem is more suited than making something you can screw up on your own. Though, that can be said about a ton of other advent questions. Oh well. I played around with my own (unsuccessful) attempts, and this was just a lot more reliable than throwing myself at a wall.

def let_z3_do_the_work(json_data):
    #print(z3)
    data = json.loads(json_data)
    
    
    
    buttons = data["buttonArray"]
    joltages = data["joltageArray"]
    
    part_two_answer = 0
    for i in range(len(joltages)):
        current_buttons = buttons[i]
        current_joltage = joltages[i]

        variables = []
        equation = z3.Optimize()
        joltages_var = [0] * len(current_joltage)

        # using an equation solver
        # set up the equation
        for button_number, button in enumerate(current_buttons):
            variable = z3.Int(str(button_number))
            variables.append(variable)

            equation.add(variable >= 0)

            for number in button:
                if joltages_var[number] == 0:
                    joltages_var[number] = variable
                else:
                    joltages_var[number] = joltages_var[number] + variable


        for jolt_number, entry in enumerate(current_joltage):
            if joltages_var[jolt_number] == 0:
                continue
            equation.add(current_joltage[jolt_number] == joltages_var[jolt_number])

        total_presses = equation.minimize(sum(variables))

        if equation.check() == z3.sat:
            part_two_answer += total_presses.value().as_long()

    return part_two_answer

#let_z3_do_the_work('{"buttonArray": [[[0,1],[1,2],[2,3]], [[0,1,2],[1,2,3],[0,3]]], "joltageArray": [[1,1,1,0],[2,1,1,1]]}')