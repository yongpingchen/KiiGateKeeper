import setup
import sys

if __name__ == '__main__':
    helper = setup.ApiHelper()
    groupsOfSecurity = helper.getGroupsOfSecurity()
    if len(groupsOfSecurity) > 0:
    	group = groupsOfSecurity[0]
    	helper.addUserToGroupOfSecurity(sys.argv[1], group['groupID'])
    	helper.listMembersOfGroup(group['groupID'])
