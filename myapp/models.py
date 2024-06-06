from django.db import models
import datetime

# Create your models here.
class UserInfo(models.Model):
    
    GENDER_CHOICES = [
        ('male', '남성'),
        ('female', '여성'),
    ]
    
    userid = models.CharField(max_length=40)
    password = models.CharField(max_length=30)
    name = models.CharField(max_length=15)
    nickname = models.CharField(max_length=40)
    gender = models.CharField(max_length=10, null=False)
    phone = models.CharField(max_length=20)
    email = models.CharField(max_length=50)
    createtime = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        managed = True
        db_table = 'member'