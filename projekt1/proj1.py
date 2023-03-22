import numpy as np
import matplotlib.pyplot as plt

gamesCount= input('how many games? ')
gc = int(gamesCount)
game = 1

#possible states
states = ['Rock','Paper','Scissors']

#all probabilities
prob = np.array([[0.34, 0.33, 0.33],
                  [0.34, 0.33, 0.33],
                  [0.34, 0.33, 0.33]])
#learning rate
alfa = 0.02

#all points
indiv_points = np.zeros(gc)
sum_points = [0]*gc

#previous choice
prev = ''

#result
result = 0

def fight(com,user):
  #draw
  if(com == user):
    print('it is a draw (0)')
  #win
  if((com == 'r' and user == 'p') or (com == 'p' and user == 's') or (com == 's' and user == 'r')):
    print('you won (+1)')
    indiv_points[game -2] = 1
  #lose
  if((com == 'p' and user == 'r') or (com == 's' and user == 'p') or (com == 'r' and user == 's')):
    print('you lose (-1)')
    indiv_points[game -2] = -1

def learn(i, now):
    if(now == 'r' and prob[i][0] < 1-(2*alfa) ):
      prob[i][0] += alfa
      prob[i][1] -= alfa/2
      prob[i][2] -= alfa/2
    if(now == 'p' and prob[i][1] < 1-(2*alfa) ):
      prob[i][1] += alfa
      prob[i][0] -= alfa/2
      prob[i][2] -= alfa/2
    if(now == 's' and prob[i][2] < 1-(2*alfa) ):
      prob[i][2] += alfa
      prob[i][1] -= alfa/2
      prob[i][0] -= alfa/2

def learn2(prev, now):
  #rock
  if(prev == 'r'):
    if(now == 'r'):
      prob[0][0] += alfa
      prob[0][1] -= alfa/2
      prob[0][2] -= alfa/2
    if(now == 'p'):
      prob[0][1] += alfa
      prob[0][0] -= alfa/2
      prob[0][2] -= alfa/2
    if(now == 's'):
      prob[0][2] += alfa
      prob[0][1] -= alfa/2
      prob[0][0] -= alfa/2
  #paper
  if(prev == 'p'):
    if(now == 'r'):
      prob[1][0] += alfa
      prob[1][1] -= alfa/2
      prob[1][2] -= alfa/2
    if(now == 'p'):
      prob[1][1] += alfa
      prob[1][0] -= alfa/2
      prob[1][2] -= alfa/2
    if(now == 's'):
      prob[1][2] += alfa
      prob[1][1] -= alfa/2
      prob[1][0] -= alfa/2
  #scissors
  if(prev == 's'):
    if(now == 'r'):
      prob[2][0] += alfa
      prob[2][1] -= alfa/2
      prob[2][2] -= alfa/2
    if(now == 'p'):
      prob[2][1] += alfa
      prob[2][0] -= alfa/2
      prob[2][2] -= alfa/2
    if(now == 's'):
      prob[2][2] += alfa
      prob[2][1] -= alfa/2
      prob[2][0] -= alfa/2

def firstGame():
  return np.random.choice(['r','p','s'], p=[1/3,1/3,1/3])

def comChoice(i):
    index = np.argmax(prob[i])
    print('table: ', prob[i])
    if(index == 0):
      return 'p'
    if(index == 1):
      return 's'
    if(index == 2):
      return 'r'

def getIndex(x):
    if(x == 'r'):
        return 0
    if(x == 'p'):
        return 1
    if(x == 's'):
        return 2

def getName(i):
    return states[i]

while game <= gc:
    print('\nGame number: ', game)
    game = game + 1
    user= input('choose r,p,s? ')

    if(prev == ''):
        com = firstGame()
        print('you   vs   comp')
        print(getName(getIndex(user)), ' vs ', getName(getIndex(com))) 
        fight(com, user)
        prev = user
    else:
        com = comChoice(getIndex(prev))
        print('you   vs   comp')
        print(getName(getIndex(user)), ' vs ', getName(getIndex(com)))
        fight(com, user)
        learn(getIndex(prev), user)
        prev = user
    result = result + indiv_points[game -2]
    sum_points[game-2] = result
    print('your score: ', result)

print('THE END')
print('individual points')
print(indiv_points)
print('the course of the game')
print(sum_points)
print('your score: ', result)

#graph for sum
plt.plot(sum_points, 'ro')
plt.ylabel('Points')
plt.xlabel('Games')
plt.show()

#graph for individual points
sts = ('win', 'draw', 'lose')
 
win = np.count_nonzero(indiv_points == 1)
draw =np.count_nonzero(indiv_points == 0)
lose =np.count_nonzero(indiv_points == -1)
print('W: ',win,', D: ',draw, ', L: ', lose)
count = {
    'count': (win,draw,lose)
}
x = np.arange(len(sts))  # the label locations
width = 0.25  # the width of the bars
multiplier = 0

fig, ax = plt.subplots(layout='constrained')

for attribute, measurement in count.items():
    offset = width * multiplier
    rects = ax.bar(x + offset, measurement, width, label=attribute)
    ax.bar_label(rects, padding=3)
    multiplier += 1

ax.set_ylabel('how many')
ax.set_title('')
ax.set_xticks(x + width, sts)
ax.legend(loc='upper left', ncols=3)
ax.set_ylim(0, (max(win,draw,lose)+2))

plt.show()