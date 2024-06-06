from django.urls import path, include
from . import views

urlpatterns = [
    path("user/info/", views.postUserInfo, name='postUserInfo'),
    path("user/login/", views.login, name='login'),
    path("user/userid_check/", views.userid_check, name='userid_check'),
    path("user/nickname_check/", views.nickname_check, name='nickname_check'),
    path('analyze/', views.analyze_image, name='analyze_image'),
]