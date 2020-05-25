+++
title = "Global Variables and Namespaces in python"
date = 2011-04-25T09:45:13-05:00
sort_by = date
tags = [
  'development',
]
+++
Recently I had someone come ask me for a bit more information about working with global variables. For those new to python, this might be something helpful, so I figured I'd share.   Personally, for ease of reference, I specify my global variables names in ALLUPPERCASE. This helps distinguish them since I use that naming standard nowhere else in my code.

In a python application you have multiple namespaces. Each namespace is intended to be completely isolated, so you can use the same name in multiple namespaces without conflict. The global namespace is the only one where this does not hold strictly true.  If the below is not enough, a good and more in depth explanation is available here: [A Guide to Python Namespaces](http://bytebaker.com/2008/07/30/python-namespaces/ "A Guide to Python Namespaces").

A global variable can be called from inside any namespace, but without a special call any changes stay inside that local namespace. If you state inside your function/class/whatever that you are using the global variable as a global, then you changes take place in the global name space.

Here is some sample code that show this in action:

```python
#!/usr/bin/python
GLOBAL = True
def changesGlobal(newval):
    global GLOBAL
    GLOBAL=newval
    print "Inside 'changesGlobal' function GLOBAL is %s" % GLOBAL
    return

def doesntChangeGlobal(newval):
    GLOBAL=newval
    print "Inside 'doesntChangeGlobal' function GLOBAL is %s" % GLOBAL
    return

print "We start with GLOBAL as %s" % GLOBAL

changesGlobal(False)
print "After 'changesGlobal' GLOBAL is %s" % GLOBAL

doesntChangeGlobal(True)
print "After 'doesntChangeGlobal' GLOBAL is %s" % GLOBAL
```
