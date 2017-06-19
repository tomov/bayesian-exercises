# alternative: boxes are indistinguishable, balls ARE distinguishable
#

v = dict()

def rec(m, k):
    if m == 1:
        return 1
    elif k == 0:
        return 1
    if (m, k) in v:
        return v[(m, k)]

    print 'F(', m, k, ')'
    s = 0
    for j in range(0, k):
        print '   ', j
        s += rec(m - 1, k - 1 - j)
    print 'F(', m, k, ') = ', s
    v[(m, k)] = s
    return s

print rec(4, 4)
