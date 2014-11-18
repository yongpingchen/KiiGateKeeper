'''
Created on 2014/11/18
@author: Yongping Chen
Copyright (c) 2014 Kii Corporation. All rights reserved.
'''
import ConfigParser
import logging
import httplib
import json
import time

CONFIG_FILE = 'setting.ini'

def getLogger():
    logger = logging.getLogger('debug')
    ch = logging.StreamHandler();
    ch.setLevel(logging.DEBUG)
    logger.addHandler(ch)
    logger.setLevel(logging.DEBUG)
    return logger

class ApiHelper(object):

    def __init__(self):
        conf = ConfigParser.SafeConfigParser()
        conf.read(CONFIG_FILE)
        self.appId = conf.get('app', 'app-id')
        self.appKey = conf.get('app', 'app-key')
        self.clientId = conf.get('app', 'client-id')
        self.clientSecret = conf.get('app', 'client-secret')
        self.host = conf.get('app', 'host')
        self.securityUserId = conf.get('app','security-user-id')
        self.logger = getLogger()
        self.logger.debug('app id: ' + self.appId)
        self.logger.debug('app key: ' + self.appKey)
        self.logger.debug('base uri: ' + self.host)
        self.logger.debug('client id: ' + self.clientId)
        self.logger.debug('client secret: ' + self.clientSecret)
        self.getAppAdminToken()

    def getAppAdminToken(self):
        self.logger.debug('get token')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/oauth2/token'
        body = {'client_id': self.clientId, 'client_secret': self.clientSecret}
        jsonBody = json.dumps(body)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey,
                'content-type': 'application/json'}
        conn.request('POST', path, jsonBody, headers)
        response = conn.getresponse()
        respDict = json.load(response)
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', respDict)
        token = respDict['access_token']
        self.logger.debug('access-token: ' + token)
        self.token = token

    def createAppBucketObjectEmployee(self):
        self.logger.debug('create app bucket')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/buckets/Employees/objects'\
            .format(self.appId)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] = 'application/json'

        # need to create a user as security on developer portal, then put the userID in the following calling
        obj = {'userID':self.securityUserId, 'role': 'security'}
        jsonObj = json.dumps(obj)
        self.logger.debug('path: %s', path)
        self.logger.debug('data %s', jsonObj)
        conn.request('POST', path, jsonObj, headers)
        response = conn.getresponse()
        self.logger.debug("status: %d", response.status)
        dictionary = json.load(response)
        self.logger.debug("body: %s", dictionary)

    def createEmployeesGroup(self):
        self.logger.debug('create normal employees group')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/groups/'\
            .format(self.appId)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] = 'application/vnd.kii.GroupCreationRequest+json'

        body = {'name': 'Emplyees', 'owner': self.securityUserId}
        jsonBody = json.dumps(body)
        conn.request('POST', path, jsonBody, headers)
        response = conn.getresponse()
        respDict = json.load(response)
        self.logger.debug('response: %s', response)        
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', respDict)

    def getGroupsOfSecurity(self):
        self.logger.debug('get groups')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/groups?owner={1}'\
            .format(self.appId, self.securityUserId)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] = 'application/vnd.kii.GroupRetrievalResponse+json'

        # need to create a user as security on developer portal, then put the userID in the following calling
        jsonBody = json.dumps('')
        conn.request('GET', path, jsonBody, headers)
        response = conn.getresponse()
        respDict = json.load(response)
        self.logger.debug('request: %s', conn)        
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', respDict)
        return respDict['groups']

    def deleteAllGroupOfSecurity(self):
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/groups?owner={1}'\
            .format(self.appId, self.securityUserId)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] = 'application/vnd.kii.GroupRetrievalResponse+json'

        jsonBody = json.dumps('')
        conn.request('GET', path, jsonBody, headers)
        response = conn.getresponse()
        respDict = json.load(response)
        groups = respDict['groups']

        for group in groups:
            self.logger.debug('groupid: %s', group['groupID'])    
            path = '/api/apps/{0}/groups/{1}'\
                .format(self.appId, group['groupID'])
            jsonBody = json.dumps('')
            conn.request('DELETE', path, jsonBody, headers)

    def addUserToGroupOfSecurity(self, userID, groupID):
        self.logger.debug('get groups')
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/groups/{1}/members/{2}'\
            .format(self.appId, groupID, userID)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token

        # need to create a user as security on developer portal, then put the userID in the following calling
        jsonBody = json.dumps('')
        conn.request('PUT', path, jsonBody, headers)
        # response = conn.getresponse()
        # respDict = json.load(response)
        # self.logger.debug('request: %s', conn)        
        # self.logger.debug('status: %d', response.status)
        # self.logger.debug('body: %s', respDict)

    def listMembersOfGroup(self, groupID):
        conn = httplib.HTTPConnection(self.host)
        path = '/api/apps/{0}/groups/{1}/members'\
            .format(self.appId, groupID)
        headers = {'x-kii-appid': self.appId, 'x-kii-appkey': self.appKey}
        headers['authorization'] = 'Bearer ' + self.token
        headers['content-type'] = 'application/vnd.kii.MembersRetrievalResponse+json'

        # need to create a user as security on developer portal, then put the userID in the following calling
        jsonBody = json.dumps('')
        conn.request('GET', path, jsonBody, headers)
        response = conn.getresponse()
        respDict = json.load(response)
        self.logger.debug('request: %s', conn)        
        self.logger.debug('status: %d', response.status)
        self.logger.debug('body: %s', respDict)

if __name__ == '__main__':
    helper = ApiHelper()
    helper.createAppBucketObjectEmployee()
    helper.createEmployeesGroup()
    # helper.deleteAllGroupOfSecurity()
    # helper.getGroupsOfSecurity()

