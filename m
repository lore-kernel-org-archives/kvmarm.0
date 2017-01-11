From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH 2/6] lib/pci: fix BAR format strings
Date: Wed, 11 Jan 2017 16:28:37 +0000
Message-ID: <20170111162841.15569-3-alex.bennee@linaro.org>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FFDA4027C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:27:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ay0O3AqA6Sfe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 11:27:10 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E920B40665
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:27:09 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id r144so33820151wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 08:28:54 -0800 (PST)
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

VXNpbmcgJXggYXMgYSBmb3JtYXQgc3RyaW5nIGlzIG5vdCBwb3J0YWJsZSBhY3Jvc3MgMzIvNjQg
Yml0IGJ1aWxkcy4KVXNlIGV4cGxpY2l0IFBSSXgzMiBmb3JtYXQgc3RyaW5ncyBsaWtlIHRoZSA2
NCBiaXQgdmVyc2lvbiBhYm92ZS4KClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5i
ZW5uZWVAbGluYXJvLm9yZz4KLS0tCiBsaWIvcGNpLmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbGliL3BjaS5j
IGIvbGliL3BjaS5jCmluZGV4IDY0MTYxOTEuLjU5N2Q4ZjIgMTAwNjQ0Ci0tLSBhL2xpYi9wY2ku
YworKysgYi9saWIvcGNpLmMKQEAgLTY3LDcgKzY3LDcgQEAgYm9vbCBwY2lfc2V0dXBfbXNpKHN0
cnVjdCBwY2lfZGV2ICpkZXYsIHVpbnQ2NF90IG1zaV9hZGRyLCB1aW50MzJfdCBtc2lfZGF0YSkK
IAkJcGNpX2NvbmZpZ193cml0ZWwoYWRkciwgb2Zmc2V0ICsgUENJX01TSV9EQVRBXzMyLCBtc2lf
ZGF0YSk7CiAJCXByaW50ZigiTVNJOiBkZXYgMHgleCBpbml0IDMyYml0IGFkZHJlc3M6ICIsIGFk
ZHIpOwogCX0KLQlwcmludGYoImFkZHI9MHglbHgsIGRhdGE9MHgleFxuIiwgbXNpX2FkZHIsIG1z
aV9kYXRhKTsKKwlwcmludGYoImFkZHI9MHglIiBQUkl4NjQgIiwgZGF0YT0weCUiIFBSSXgzMiAi
XG4iLCBtc2lfYWRkciwgbXNpX2RhdGEpOwogCiAJbXNpX2NvbnRyb2wgfD0gUENJX01TSV9GTEFH
U19FTkFCTEU7CiAJcGNpX2NvbmZpZ193cml0ZXcoYWRkciwgb2Zmc2V0ICsgUENJX01TSV9GTEFH
UywgbXNpX2NvbnRyb2wpOwpAQCAtMjM3LDcgKzIzNyw3IEBAIHZvaWQgcGNpX2Jhcl9wcmludChz
dHJ1Y3QgcGNpX2RldiAqZGV2LCBpbnQgYmFyX251bSkKIAkJcHJpbnRmKCJCQVIjJWQsJWQgWyUi
IFBSSXg2NCAiLSUiIFBSSXg2NCAiICIsCiAJCSAgICAgICBiYXJfbnVtLCBiYXJfbnVtICsgMSwg
c3RhcnQsIGVuZCk7CiAJfSBlbHNlIHsKLQkJcHJpbnRmKCJCQVIjJWQgWyUwMngtJTAyeCAiLAor
CQlwcmludGYoIkJBUiMlZCBbJSIgUFJJeDMyICItJSIgUFJJeDMyICIgIiwKIAkJICAgICAgIGJh
cl9udW0sICh1aW50MzJfdClzdGFydCwgKHVpbnQzMl90KWVuZCk7CiAJfQogCi0tIAoyLjExLjAK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
