from random import randrange

from django.http import HttpResponse, HttpRequest
from django.shortcuts import render


def a_function():
    return "beans"


def index_view(request):
    return HttpResponse("I am the index.")


def test_view(request):
    return HttpResponse("Hello! Please visit a page.")


def random_numbers(request):
    random_nums = [randrange(0, 101)
                   for i in range(10)]  # List of 10 random numbers

    return render(request, 'test.html',
                  {
                      'numbers': random_nums,
                      'params': {'foo', 'bar'}
                  })
