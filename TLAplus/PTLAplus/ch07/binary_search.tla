Property of binary search algorithm.

---- MODULE binary_search ----
EXTENDS TLC, Integers, Sequences
PT == INSTANCE PT

MaxInt == 4
Range(f) == {f[x]: x \in DOMAIN f}

OrderedSeqOf(set, n) ==
    {seq \in PT!SeqOf(set, n):
        \A x \in 2..Len(seq):
            seq[x] >= seq[x-1]}

Pow2(n) ==
    LET f[x \in 0..n] ==
        IF x = 0
        THEN 1
        ELSE 2 * f[x-1]
    IN f[n]        
        
(**--algorithm binary_search
\* VarDecls
variables
    low = 1,
    seq \in OrderedSeqOf(1..MaxInt, MaxInt),
    high = Len(seq),
    lh = high - low,
    m = high - (lh \div 2),
    target \in 1..MaxInt,
    found_index = 0,
    counter = 0;

define 
    NoOverflows ==
        \A x \in {m,lh,low,high}: x <= MaxInt
end define;

begin
    Search:
        while low <= high do
            counter := counter + 1;
            \* with
                \* m = (high + low) \div 2
                lh := high - low;
                m := high - (lh \div 2);
            \* do
                if seq[m] = target then
                    found_index := m;
                    goto Result;
                elsif seq[m] < target then
                    low := m + 1;
                else
                    high := m - 1;
                end if;
            \* end with;
        end while;
    Result:
        if Len(seq) > 0 then
            assert Pow2(counter - 1) <= Len(seq)
        end if;
        if target \in Range(seq) then
            assert seq[found_index] = target
        else
            assert found_index = 0;
        end if;
end algorithm;*)
\* BEGIN TRANSLATION (chksum(pcal) = "e9a6802b" /\ chksum(tla) = "4beb1719")
VARIABLES low, seq, high, lh, m, target, found_index, counter, pc

(* define statement *)
NoOverflows ==
    \A x \in {m,lh,low,high}: x <= MaxInt


vars == << low, seq, high, lh, m, target, found_index, counter, pc >>

Init == (* Global variables *)
        /\ low = 1
        /\ seq \in OrderedSeqOf(1..MaxInt, MaxInt)
        /\ high = Len(seq)
        /\ lh = high - low
        /\ m = high - (lh \div 2)
        /\ target \in 1..MaxInt
        /\ found_index = 0
        /\ counter = 0
        /\ pc = "Search"

Search == /\ pc = "Search"
          /\ IF low <= high
                THEN /\ counter' = counter + 1
                     /\ lh' = high - low
                     /\ m' = high - (lh' \div 2)
                     /\ IF seq[m'] = target
                           THEN /\ found_index' = m'
                                /\ pc' = "Result"
                                /\ UNCHANGED << low, high >>
                           ELSE /\ IF seq[m'] < target
                                      THEN /\ low' = m' + 1
                                           /\ high' = high
                                      ELSE /\ high' = m' - 1
                                           /\ low' = low
                                /\ pc' = "Search"
                                /\ UNCHANGED found_index
                ELSE /\ pc' = "Result"
                     /\ UNCHANGED << low, high, lh, m, found_index, counter >>
          /\ UNCHANGED << seq, target >>

Result == /\ pc = "Result"
          /\ IF Len(seq) > 0
                THEN /\ Assert(Pow2(counter - 1) <= Len(seq), 
                               "Failure of assertion at line 58, column 13.")
                ELSE /\ TRUE
          /\ IF target \in Range(seq)
                THEN /\ Assert(seq[found_index] = target, 
                               "Failure of assertion at line 61, column 13.")
                ELSE /\ Assert(found_index = 0, 
                               "Failure of assertion at line 63, column 13.")
          /\ pc' = "Done"
          /\ UNCHANGED << low, seq, high, lh, m, target, found_index, counter >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Search \/ Result
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
====
