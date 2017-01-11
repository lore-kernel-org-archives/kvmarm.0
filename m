From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH 5/6] docs: mention modifying env vars in README
Date: Wed, 11 Jan 2017 16:28:40 +0000
Message-ID: <20170111162841.15569-6-alex.bennee@linaro.org>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB575407ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:27:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DTIxaXA1VpnR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 11:27:11 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8D8A407EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:27:10 -0500 (EST)
Received: by mail-wm0-f42.google.com with SMTP id c206so116281079wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 08:28:55 -0800 (PST)
In-Reply-To: <20170111162841.15569-1-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

SSBoYWQgc3RhcnRlZCBhZGRpbmcgYSBzZXJpZXMgb2YgZmxhZ3MgdG8gY29udHJvbCB0aGUgcnVu
LXRpbWUKYmVoYXZpb3VyIG9mIHRoZSB0ZXN0cyBidXQgaXQgd2FzIHBvaW50ZWQgb3V0IGVudiB2
YXJzIGNhbiBhbHJlYWR5IGRvCnRoYXQuIE1lbnRpb24gdGhlbSBpbiB0aGUgUkVBRE1FIHNvIG90
aGVycyBjYW4gZmluZCBvdXQgdG8uCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXgu
YmVubmVlQGxpbmFyby5vcmc+Ci0tLQogUkVBRE1FLm1kIHwgOCArKysrKysrKwogMSBmaWxlIGNo
YW5nZWQsIDggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL1JFQURNRS5tZCBiL1JFQURNRS5t
ZAppbmRleCA5NDYyODI0Li5mYTNhNDQ1IDEwMDY0NAotLS0gYS9SRUFETUUubWQKKysrIGIvUkVB
RE1FLm1kCkBAIC00Nyw2ICs0NywxNCBAQCBlbnZpcm9ubWVudCB2YXJpYWJsZToKIAogICAgIFFF
TVU9L3RtcC9xZW11L3g4Nl82NC1zb2Z0bW11L3FlbXUtc3lzdGVtLXg4Nl82NCAuL3g4Ni1ydW4g
Li94ODYvbXNyLmZsYXQKIAorVG8gZm9yY2UgdGhlIGFjY2VsZXJhdGlvbiBtb2RlOgorCisgICAg
QUNDRUw9dGNnIC4vcnVuX3Rlc3RzLnNoCisKK1RvIGV4dGVuZCBvciBkaXNhYmxlIHRoZSB0aW1l
b3V0czoKKworICAgIFRJTUVPVVQ9MCAuL3J1bl90ZXN0cy5zaAorCiAjIENvbnRyaWJ1dGluZwog
CiAjIyBEaXJlY3Rvcnkgc3RydWN0dXJlCi0tIAoyLjExLjAKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
