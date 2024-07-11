#!/usr/bin/env python3
from pysmt.shortcuts import (GE, LE, LT, AllDifferent, And, Equals, Int, Not,
                             Select, Solver, Symbol, write_smtlib)
from pysmt.typing import ARRAY_INT_INT, INT

grid1 = Symbol("grid", ARRAY_INT_INT)
grid2 = Symbol("grid2", ARRAY_INT_INT)
clues = Symbol("clues", ARRAY_INT_INT)
w = Symbol("w", INT)
N = 28
asserts = []

# grid1 and grid2 have cells that range from 1-9
for i in range(81):
    lb = GE(Select(grid1, Int(i)), Int(1))
    ub = LE(Select(grid1, Int(i)), Int(9))
    lb2 = GE(Select(grid2, Int(i)), Int(1))
    ub2 = LE(Select(grid2, Int(i)), Int(9))
    asserts.append(lb)
    asserts.append(ub)
    asserts.append(lb2)
    asserts.append(ub2)

# grid1 and grid2 have rows with unique values
for i in range(9):
    rowinds = range(9*i, 9*i + 8)
    asserts.append(AllDifferent([Select(grid1, Int(c)) for c in rowinds]))
    asserts.append(AllDifferent([Select(grid2, Int(c)) for c in rowinds]))

# grid1 and grid2 have columns with unique values
for j in range(9):
    colinds = range(i, 81, 9)
    asserts.append(AllDifferent([Select(grid1, Int(c)) for c in colinds]))
    asserts.append(AllDifferent([Select(grid2, Int(c)) for c in colinds]))

# grid1 and grid2 have boxes with unique values
for i in [10, 13, 16, 37, 40, 43, 64, 67, 70]:
    boxinds = [j-1, j, j+1, j-10, j-9, j-8, j+8, j+9, j+10]
    asserts.append(AllDifferent([Select(grid1, Int(c)) for c in boxinds]))
    asserts.append(AllDifferent([Select(grid2, Int(c)) for c in boxinds]))

# grid1 and grid2 have the same starting clues
#TODO: Ensure that there are at least 8 distinct numbers used in clues
#TODO: smartly distribute the clues
#TODO: https://pi.math.cornell.edu/~mec/Summer2009/Mahmood/More.html
for i in range(N):
    lb = GE(Select(clues, Int(i)), Int(0))
    ub = LE(Select(clues, Int(i)), Int(80))
    asserts.append(lb)
    asserts.append(ub)
    asserts.append(Equals(Select(grid1, Select(clues, Int(i))), Select(grid2, Select(clues, Int(i)))))

# grid1 and grid2 are ..
asserts.append(Not(Equals(Select(grid1, w), Select(grid2, w))))
fml = And(asserts)
write_smtlib(fml, "sudo" + str(N) + ".smt2")

# solver = Solver(logic=logic, name="z3")
