import logging, pkgutil, json

from dlpx.virtualization import libs

def _setup_logger(name):
    vsdkHandler = libs.PlatformHandler()
    vsdkHandler.setLevel(logging.DEBUG)
    vsdkFormatter = logging.Formatter('[%(asctime)s] [%(levelname)s] [%(filename)s:%(lineno)d] %(message)s',datefmt="%Y-%m-%d %H:%M:%S")
    vsdkHandler.setFormatter(vsdkFormatter)
    logger = logging.getLogger(name)
    logger.addHandler(vsdkHandler)
    logger.setLevel(logging.DEBUG)
    return logger
