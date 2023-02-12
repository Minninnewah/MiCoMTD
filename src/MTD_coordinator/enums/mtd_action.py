from enum import Enum
from action_executors.migration_executor import MigrationExecutor
from action_executors.empty_executor import EmptyExecutor
from action_executors.reinstantiation_executor import ReinstantiationExecutor

class MTDAction(Enum):
    DO_NOTHING = EmptyExecutor()
    MIGRATION = MigrationExecutor()
    REINSTANTIATION = ReinstantiationExecutor()

    def get_list():
        return [el.name for el in MTDAction]