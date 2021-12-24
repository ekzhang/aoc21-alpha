"""Wrapper script that runs Boolector and dynamically generates BTOR programs.

See the paper "BTOR: Bit-Precise Modelling of Word-Level Problems for Model
Checking" for reference about the BTOR language grammar, available at
http://fmv.jku.at/papers/BrummayerBiereLonsing-BPR08.pdf.
"""

import subprocess
import sys


def to_hex32(x: int) -> str:
    return hex(x & 0xFFFFFFFF)[2:]


def to_btor(program: list[str]) -> str:
    return "\n".join([f"{i + 1} {line}" for i, line in enumerate(program)])


def load(state: dict[str, int], consts: dict[int, int], val: str) -> int:
    if val in state:
        return state[val]
    return consts[int(val)]


lines = [line.strip().split() for line in sys.stdin]
literals = set([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

for line in lines:
    if len(line) == 3 and not line[2][0].isalpha():
        literals.add(int(line[2]))

program: list[str] = []
consts: dict[int, int] = {}

# Declare constants first
for x in literals:
    program.append(f"consth 32 {to_hex32(x)}")
    consts[x] = len(program)

inputs: list[int] = []
state = {c: consts[0] for c in "xyzw"}
binops = {"add": "add", "mul": "mul", "div": "sdiv", "mod": "smod"}

for line in lines:
    if line[0] == "inp":
        program.append(f"var 32")
        state[line[1]] = len(program)
        inputs.append(len(program))
    elif line[0] in binops:
        bop = binops[line[0]]
        dest, src = line[1:]
        program.append(f"{bop} 32 {state[dest]} {load(state, consts, src)}")
        state[dest] = len(program)
    elif line[0] == "eql":
        dest, src = line[1:]
        program.append(f"eq 1 {state[dest]} {load(state, consts, src)}")
        n = len(program)
        program.append(f"cond 32 {n} {consts[1]} {consts[0]}")
        state[dest] = len(program)
    else:
        raise ValueError(f"Invalid operation {line[0]} in input")

assert len(inputs) == 14, "should have 14 inputs"


def test_prefix(vals: list[int]) -> bool:
    assert 0 <= len(vals) <= len(inputs)
    prog = program.copy()
    prog.append(f"eq 1 {state['z']} {consts[0]}")
    root = len(prog)
    for i, val in enumerate(vals):
        # inputs[i] == val
        prog.append(f"eq 1 {inputs[i]} {consts[val]}")
        prog.append(f"and 1 {root} {len(prog)}")
        root = len(prog)
    for j in range(len(vals), len(inputs)):
        # 0 < inputs[j] <= 9
        prog.append(f"sgt 1 {inputs[j]} {consts[0]}")
        prog.append(f"and 1 {root} {len(prog)}")
        root = len(prog)
        prog.append(f"slte 1 {inputs[j]} {consts[9]}")
        prog.append(f"and 1 {root} {len(prog)}")
        root = len(prog)
    prog.append(f"root 1 {root}")
    btor = to_btor(prog) + "\n"

    handle = subprocess.run(
        ["boolector"],
        input=btor.encode("utf-8"),
        stdout=subprocess.PIPE,
    )
    output = handle.stdout.decode("utf-8").strip()
    if output == "sat":
        return True
    elif output == "unsat":
        return False
    else:
        raise RuntimeError("Output from boolector was not `sat` or `unsat`: " + output)


def find_solution(ordering: list[int]) -> str:
    solution: list[int] = []
    for _ in range(len(inputs)):
        for val in ordering:
            if test_prefix(solution + [val]):
                solution.append(val)
                break
        else:
            raise RuntimeError(f"Unable to expand prefix {solution}")
    return "".join(str(x) for x in solution)


assert test_prefix([]), "unsat instance"
print(find_solution([9, 8, 7, 6, 5, 4, 3, 2, 1]))
print(find_solution([1, 2, 3, 4, 5, 6, 7, 8, 9]))
