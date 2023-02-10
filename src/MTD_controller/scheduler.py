from enums.scheduler_mode import SchedulerMode
from enums.mtd_action import MTDAction
import random

class Scheduler:
    mode = SchedulerMode.MANUEL
    manuel_action = MTDAction.DO_NOTHING
    auto_action = MTDAction.DO_NOTHING
    auto_timer = 30

    def set_mode(self, schedulerMode):
        self.mode = schedulerMode
    
    def get_mode(self):
        return self.mode

    def set_manuel_MTD_action(self, action):
        self.manuel_action = action
    
    def schedule (self):
        if self.mode == SchedulerMode.MANUEL:
            if not self.manuel_action.value.isReady():
                self.manuel_action.value.generate_random_values()
            self.manuel_action.value.execute()
            self.manuel_action = MTDAction.DO_NOTHING
            pass
        elif self.mode == SchedulerMode.AUTO:
            print(self.auto_timer)
            self.auto_timer -= 5
            if self.auto_timer <= 0:
                self.auto_action.value.execute()

                #define next action
                self.auto_action = MTDAction.REINSTANTIATION #Chose a random one or listen to event's would be a better choice
                self.auto_action.value.generate_random_values()
                self.auto_timer = random.randint(30, 90)
            
            pass
        else:
            raise Exception("Mode is not allowed")