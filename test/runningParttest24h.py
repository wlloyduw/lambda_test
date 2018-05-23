import datetime, csv, sched, time
from subprocess import check_output

s = sched.scheduler(time.time, time.sleep)

class RunningPartest(object):
  def __init__(self):
    self.startTime = datetime.datetime.now()
    self.endTime = self.startTime + datetime.timedelta(hours=9)
    self.csvFileName = "192MB_stressLevel5b_sleep5_30min.csv"
    self.sleepingTime = 330

  def runningPartestFunction(self):
    if self.startTime < self.endTime:
      result = check_output('./partestrecyjq.sh 100 100 2 2 | tail -1', shell=True)
      result = result.split(',')
      result.insert(0, self.startTime.strftime("%m/%d/%Y %H:%M %p"))
      with open(self.csvFileName, 'a') as f:
        writer = csv.writer(f)
        writer.writerow(result)
        f.close()
    self.startTime += datetime.timedelta(seconds=self.sleepingTime)
    s.enter(self.sleepingTime, 1, self.runningPartestFunction, ())

result = check_output('./partestrecyjq.sh 100 100 1 1 | tail -2', shell=True)
name, number = result[:-1].split("\n")
runningPartest = RunningPartest()
with open(runningPartest.csvFileName, 'w') as f:
  name = name.split(",")
  name.insert(0, "datetime")
  writer = csv.writer(f)
  writer.writerow(name)
  f.close()
s.enter(runningPartest.sleepingTime, 1, runningPartest.runningPartestFunction, ())
s.run() 
