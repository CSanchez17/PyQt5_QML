import json

def saveToJson(clickedList):
    data = []
    #data['clicks'] = clickedList
    data = clickedList
    with open('data.txt', 'w') as outfile:
        json.dump(data,outfile) 



def readFromJson():
    data = {}
    with open('data.txt') as json_file:
        data = json.load(json_file)
        #for p in data['clicks']:
        #    print(p)
    return data