\* max: the largest element in a sequence
---- MODULE max ----
EXTENDS TLC, Integers, Sequences
CONSTANTS IntSet, MaxSeqLen
ASSUME IntSet \subseteq Int
ASSUME MaxSeqLen > 0

PT == INSTANCE PT

Max(seq) == 
    LET set == {seq[i]: i \in 1..Len(seq)}
    IN CHOOSE x \in set: \A y \in set: y <= x

MaxIndex(seq) ==
    LET index == CHOOSE x \in 1..Len(seq):
                    \A y \in 1..Len(seq): seq[y] <= seq[x]
    IN index

AllInputs == PT!SeqOf(IntSet, MaxSeqLen) \ {<<>>}

(**--algorithm max
variables seq \in AllInputs,
    i = 1,
    max;

begin
    assert Len(seq) > 0;
    max := seq[1];
    while i <= Len(seq) do
        if max < seq[i] then
            max := seq[i]
        end if;
        i := i + 1;
    end while;

    assert max = Max(seq)
end algorithm;*)
\* BEGIN TRANSLATION (chksum(pcal) = "b70f0b56" /\ chksum(tla) = "e9c0cc60")
CONSTANT defaultInitValue
VARIABLES seq, i, max, pc

vars == << seq, i, max, pc >>

Init == (* Global variables *)
        /\ seq \in AllInputs
        /\ i = 1
        /\ max = defaultInitValue
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(Len(seq) > 0, 
                   "Failure of assertion at line 27, column 5.")
         /\ max' = seq[1]
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << seq, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(seq)
               THEN /\ IF max < seq[i]
                          THEN /\ max' = seq[i]
                          ELSE /\ TRUE
                               /\ max' = max
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(max = Max(seq), 
                              "Failure of assertion at line 36, column 5.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, max >>
         /\ seq' = seq

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
====
