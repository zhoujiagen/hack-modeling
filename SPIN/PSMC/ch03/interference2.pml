byte n = 0;

proctype P() {
  byte temp;
  int i;
  for(i: 1 .. 10) {
    temp = n + 1;
    n = temp
  }
}

init {
  atomic {
    run P();
    run P()
  }
  (_nr_pr == 1) ->
    printf("The value is %d\n", n)
}