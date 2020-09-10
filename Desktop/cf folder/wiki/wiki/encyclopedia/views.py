from django.shortcuts import render,redirect
from markdown2 import Markdown
import random


from . import util

markdowner = Markdown()

def index(request):
    return render(request, "encyclopedia/index.html", {
        "entries": util.list_entries()
    })

def get(request,title):
    err = 1
    valid = False

    for entry in util.list_entries():
        if title.lower() == entry.lower():
            valid = True

    if valid:
        data = util.get_entry(title)
        page = markdowner.convert(data) 

        return render(request, "encyclopedia/get.html", {
            "data":page,
            "title":title
        })
    else:
        return render(request, "encyclopedia/error.html",{
            "title":title,
            "err":err
        })
    

def search(request):
    q = request.GET.get("q")
    entry_list = util.list_entries()
    fil_list =[]
    len_search = len(q)

    for entry in entry_list:
        same = 0
        result = True
        if len(entry) < len_search:
            continue
        for i in range(len_search):
            if not(entry[i] == q[i].lower() or entry[i] == q[i].upper()):
                result = False
            if result == False:
                break
            else:
                same +=1
        if same == len(entry):
            return get(request,entry)
        if result == True:
            fil_list.append(entry)
    
    num_entry = len(fil_list)
    return render(request,"encyclopedia/search.html",{
        "entries" : fil_list,
        "num_entry": num_entry,
        "q":q
    })

def random_choice(request):
    entries = util.list_entries()
    choice = random.choice(entries)
    return get(request,choice)

def add(request):
    if request.method=="POST":
        err = 2
        valid = True
        title = request.POST.get("title")
        for entry in util.list_entries():
            if title.lower() == entry.lower():
                valid = False
                break
        if valid == False:
            return render(request,"encyclopedia/error.html",{
                "title":title,
                "err":err
            })

        else:
            content = request.POST.get("content")
            util.save_entry(title,content)
            return render(request,"encyclopedia/new.html")

    return render(request,"encyclopedia/new.html")

def edit(request,title):
    data = util.get_entry(title)
    
    if request.method =="POST":
        title=request.POST.get("title")
        content = request.POST.get("content")
        util.save_entry(title,content)
        return redirect("get", title)

    return render(request,"encyclopedia/edit.html",{
        "title":title,
        "content":data
    })