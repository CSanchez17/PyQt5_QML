import json

def saveToJson(clickedList, nameAG, projectsPath, ulyssesPID, nameOfExcelTable):
    
    data = [
        clickedList,
        nameAG,
        projectsPath,
        ulyssesPID,
        nameOfExcelTable
    ]

    with open('data.txt', 'w') as outfile:
        json.dump(data,outfile) 


def readFromJson():
    data = []
    with open('data.txt') as json_file:
        data = json.load(json_file)
        #for p in data['clicks']:
        #    print(p)
    return data