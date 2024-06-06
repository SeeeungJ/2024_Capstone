from rest_framework import serializers
from .models import UserInfo


class UserInfoSerializers(serializers.ModelSerializer):
    class Meta:
        model = UserInfo
        fields = ('userid', 'password', 'name', 'nickname', 'gender', 'phone', 'email', 'createtime')