from utils import setupLogger, executeScript
from generated.definitions import RepositoryDefinition, SourceConfigDefinition
import json


def find_repos(source_connection):
    logger = setupLogger._setup_logger(__name__)

    env = {
            "DLPX_TOOLKIT_NAME" : "Oracle on Windows"
            }

    delphixToolkitPath = executeScript.execute_powershell(source_connection,'writeLibrary.ps1',env).strip('"')
    logger.debug("Delphix Toolkit path: {}".format(delphixToolkitPath))
    env = {
            "DLPX_TOOLKIT_NAME" : "Oracle on Windows",
            "DLPX_TOOLKIT_WORKFLOW" : "repository_discovery",
            "DLPX_TOOLKIT_PATH": delphixToolkitPath
           }

    repoDiscovery = executeScript.execute_powershell(source_connection,'repoDiscovery.ps1',env)
    logger.debug("Repository discovered: {}".format(repoDiscovery))
    parsedRepositories = json.loads(repoDiscovery)
    logger.debug("parsedRepositories: {}".format(parsedRepositories))
    return [RepositoryDefinition(toolkit_name=installedRepository["toolkitName"],delphix_tookit_path=installedRepository["delphixToolkitPath"],pretty_name=installedRepository["prettyName"],ora_base=installedRepository["oraBase"],ora_edition=installedRepository["oraEdition"],ora_home=installedRepository["oraHome"]) for installedRepository in parsedRepositories]
    #return [RepositoryDefinition(toolkit_name=installedRepository["toolkitName"],delphix_tookit_path=installedRepository["delphixToolkitPath"],pretty_name=installedRepository["prettyName"],ora_home_name=installedRepository["oraHomeName"],ora_home=installedRepository["oraHome"],ora_edition=installedRepository["oraEdition"],ora_base=installedRepository["oraBase"]) for installedRepository in parsedRepositories]
    #return [RepositoryDefinition(toolkit_name=env['DLPX_TOOLKIT_NAME'],delphix_tookit_path=env['DLPX_TOOLKIT_PATH'])]

def find_source(source_connection,repository):
    env = {
        "DLPX_TOOLKIT_WORKFLOW" : "sourceConfig_discovery"
    }
    executeScript.execute_powershell(source_connection,'sourceConfigDiscovery.ps1',env)
