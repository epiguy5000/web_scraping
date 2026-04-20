# Import libraries
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from time import sleep
import pandas as pd
import requests
import csv

#venv\Scripts\activate

url = "https://example.com"
html = requests.get(url).text

soup = BeautifulSoup(html, "lxml")
print(soup.title.text)