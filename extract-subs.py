import sys

fname = sys.argv[1]


def is_in_last_two_lines(subs, line):
    if len(subs) >= 1 and line == subs[-1]:
        return True
    if len(subs) >= 2 and line == subs[-2]:
        return True
    return False


def extract(lines):
    subs = []
    for idx, line in enumerate(lines):
        if line.strip() == "":
            continue
        if is_in_last_two_lines(subs, line):
            continue
        subs.append(line)
    return subs


with open(fname) as f:
    lines = f.read().splitlines()
    lines = extract(lines)

for line in lines:
    print(line)
