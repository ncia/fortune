import json

keys = {
  "profileEditEmptyNickname": "닉네임을 입력해주세요.",
  "profileEditDuplicateNickname": "이미 사용 중인 닉네임입니다. 다른 닉네임을 입력해주세요.",
  "profileEditEmptyPassword": "이메일 변경을 위해 현재 비밀번호를 입력해주세요.",
  "profileEditEmailSent": "인증 메일이 발송되었습니다. 새 이메일함에서 인증을 완료해주세요.",
  "profileEditSuccess": "프로필이 저장되었습니다.",
  "profileEditErrorDefault": "오류가 발생했습니다.",
  "profileEditErrorWrongPassword": "비밀번호가 틀렸습니다.",
  "profileEditErrorInvalidEmail": "유효하지 않은 이메일 형식입니다.",
  "profileEditErrorEmailInUse": "이미 사용 중인 이메일입니다.",
  "profileEditErrorRecentLogin": "보안을 위해 다시 로그인 후 시도해주세요.",
  "profileEditErrorUnknown": "저장 중 알 수 없는 오류가 발생했습니다: {error}",
  "@profileEditErrorUnknown": {
    "placeholders": {
      "error": {
        "type": "String"
      }
    }
  },
  "profileEditTitle": "프로필 수정",
  "profileEditPhoto": "프로필 사진",
  "profileEditNickname": "닉네임",
  "profileEditEmail": "이메일 주소",
  "profileEditEmailSocialHint": "구글/애플 연동 계정은 이메일을 변경할 수 없습니다.",
  "profileEditEmailChangeHint": "이메일 변경 시 확인 메일이 발송됩니다.",
  "profileEditPassword": "현재 비밀번호 (이메일 변경 확인용)",
  "profileEditCancel": "취소",
  "profileEditSave": "저장"
}

en_keys = {
  "profileEditEmptyNickname": "Please enter a nickname.",
  "profileEditDuplicateNickname": "Nickname is already in use. Please enter a different nickname.",
  "profileEditEmptyPassword": "Please enter your current password to change your email.",
  "profileEditEmailSent": "Verification email has been sent. Please complete verification in your new email inbox.",
  "profileEditSuccess": "Profile has been saved.",
  "profileEditErrorDefault": "An error occurred.",
  "profileEditErrorWrongPassword": "Incorrect password.",
  "profileEditErrorInvalidEmail": "Invalid email format.",
  "profileEditErrorEmailInUse": "Email is already in use.",
  "profileEditErrorRecentLogin": "For security reasons, please log in again and try.",
  "profileEditErrorUnknown": "Unknown error occurred while saving: {error}",
  "@profileEditErrorUnknown": {
    "placeholders": {
      "error": {
        "type": "String"
      }
    }
  },
  "profileEditTitle": "Edit Profile",
  "profileEditPhoto": "Profile Photo",
  "profileEditNickname": "Nickname",
  "profileEditEmail": "Email Address",
  "profileEditEmailSocialHint": "Google/Apple linked accounts cannot change email.",
  "profileEditEmailChangeHint": "A verification email will be sent when changing email.",
  "profileEditPassword": "Current Password (for email change verification)",
  "profileEditCancel": "Cancel",
  "profileEditSave": "Save"
}

def update_file(filepath, data_dict):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    for k, v in data_dict.items():
        data[k] = v
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

update_file('lib/l10n/app_ko.arb', keys)
update_file('lib/l10n/app_en.arb', en_keys)
print("Updated app_ko.arb and app_en.arb")
