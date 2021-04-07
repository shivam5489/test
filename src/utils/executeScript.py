#
# Copyright (c) 2021 by Delphix. All rights reserved.
#

import pkgutil, json
from dlpx.virtualization import libs
from dlpx.virtualization.libs import exceptions
from utils import setupLogger

def execute_powershell(source_connection, script_name,env):
    logger = setupLogger._setup_logger(__name__)
    command = pkgutil.get_data('resources', script_name)
    env['DLPX_LIBRARY_SOURCE'] = pkgutil.get_data('resources','library.ps1')
    env['ORA_LIBRARY_SOURCE'] = pkgutil.get_data('resources','oralibrary.ps1')
    result = libs.run_powershell(source_connection,command,variables=env)

    logger.debug("Powershell Result: {}".format(result))

    if result.exit_code != 0:
        message = """The script {} failed with exit code {}. An exception {} was raised along with the message:
        {}""".format(script_name,result.exit_code,result.stdout,result.stderr)
        logger.exception(message)
        raise exceptions.PluginScriptError(message)

    return result.stdout.strip()
