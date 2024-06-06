# SQL 사용 버전
from django.db import connection
from django.conf import settings
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view
# from .models import UserInfo
import json

import numpy as np
from PIL import Image
import io
from fastai.vision.all import *
import os

@csrf_exempt
@api_view(['POST'])
def postUserInfo(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        userid = data.get('userid')
        password = data.get('password')
        name = data.get('name')
        nickname = data.get('nickname')
        gender = data.get('gender')
        phone = data.get('phone')
        email = data.get('email')
        
        with connection.cursor() as cursor:
            cursor.execute(
                "INSERT INTO member (userid, password, name, nickname, gender, phone, email) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                [userid, password, name, nickname, gender, phone, email]
            )
        return JsonResponse({'message': '신규 등록이 정상적으로 성공'}, status=201)
    return JsonResponse({'message': '신규 등록이 실패'}, status=400)
    
# 아이디 중복 체크
@csrf_exempt
@api_view(['POST'])
def userid_check(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        userid = data.get('userid')
        
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM member WHERE userid = %s", [userid])
            user = cursor.fetchone()
        if user:
            return JsonResponse({'message': '아이디가 이미 사용 중입니다.'}, status=400)
        return JsonResponse({'message': '사용 가능한 아이디입니다.'}, status=200)

# 닉네임 중복 체크
@csrf_exempt
@api_view(['POST'])
def nickname_check(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        nickname = data.get('nickname')
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM member WHERE nickname = %s", [nickname])
            user = cursor.fetchone()
        if user:
            return JsonResponse({'message': '닉네임이 이미 사용 중입니다.'}, status=400)
        return JsonResponse({'message': '사용 가능한 닉네임입니다.'}, status=200)
    

# 로그인시 세션 생성
@csrf_exempt
@api_view(['POST'])
def login(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        userid = data.get('userid')
        password = data.get('password')

        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT * FROM member WHERE userid = %s AND password = %s",
                [userid, password]
            )
            user = cursor.fetchone()

        if user:
            request.session['userid'] = user[0]
            return JsonResponse({'message': '로그인 성공', 'userid': user[0]}, status=200)
        else:
            return JsonResponse({'message': '로그인 실패'}, status=401)

    return JsonResponse({'message': 'Invalid request method'}, status=400)

# 모델 불러오기
learn = os.path.join(settings.BASE_DIR, 'static/model/face_type_model2.pkl')

@csrf_exempt
def analyze_image(request):
    if request.method == 'POST' and request.FILES['image']:
        image_file = request.FILES['image']
        image = PILImage.create(io.BytesIO(image_file.read()))
        
        # 이미지 예측
        prediction = learn.predict(image)
        result = {
            'predicted_category': prediction[0],
            'probability': prediction[2].numpy().max().item()
        }
        return JsonResponse(result)
    return JsonResponse({'error': 'Invalid request'}, status=400)