#!/usr/bin/env python3
from pysmt.shortcuts import Symbol, And, LE, GE, LT, Not, Equals, Int, AllDifferent, Select, write_smtlib, Solver
from pysmt.typing import INT, ARRAY_INT_INT

grid1 = Symbol("grid", ARRAY_INT_INT)
grid2 = Symbol("grid2", ARRAY_INT_INT)
clues = Symbol("clues", ARRAY_INT_INT)
w = Symbol("w", INT)
N = 28
asserts = []
for i in range(81):
    lb = GE(Select(grid1, Int(i)), Int(1))
    ub = LE(Select(grid1, Int(i)), Int(9))
    lb2 = GE(Select(grid2, Int(i)), Int(1))
    ub2 = LE(Select(grid2, Int(i)), Int(9))
    asserts.append(lb)
    asserts.append(ub)
    asserts.append(lb2)
    asserts.append(ub2)

for i in range(9):
    rowinds = range(9*i, 9*i + 8)
    asserts.append(AllDifferent([Select(grid1, Int(c)) for c in rowinds]))
    asserts.append(AllDifferent([Select(grid2, Int(c)) for c in rowinds]))

for j in range(9):
    colinds = range(i, 81, 9)
    asserts.append(AllDifferent([Select(grid1, Int(c)) for c in colinds]))
    asserts.append(AllDifferent([Select(grid2, Int(c)) for c in colinds]))

for i in [10, 13, 16, 37, 40, 43, 64, 67, 70]:
    boxinds = [j-1, j, j+1, j-10, j-9, j-8, j+8, j+9, j+10]
    asserts.append(AllDifferent([Select(grid1, Int(c)) for c in boxinds]))
    asserts.append(AllDifferent([Select(grid2, Int(c)) for c in boxinds]))

for i in range(N):
    lb = GE(Select(clues, Int(i)), Int(0))
    ub = LE(Select(clues, Int(i)), Int(80))
    asserts.append(lb)
    asserts.append(ub)
    asserts.append(Equals(Select(grid1, Select(clues, Int(i))), Select(grid2, Select(clues, Int(i)))))

asserts.append(Not(Equals(Select(grid1, w), Select(grid2, w))))
fml = And(asserts)
write_smtlib(fml, "sudo" + str(N) + ".smt2")

# solver = Solver(logic=logic, name="z3")
