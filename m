From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 3/3] kvm: arm64: handle single-step of userspace mmio
 instructions
Date: Thu,  9 Nov 2017 17:00:21 +0000
Message-ID: <20171109170021.2984-4-alex.bennee@linaro.org>
References: <20171109170021.2984-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30A5549D59
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Nov 2017 11:58:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oIBz8XuVRM4c for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Nov 2017 11:58:25 -0500 (EST)
Received: from mail-wr0-f193.google.com (mail-wr0-f193.google.com
 [209.85.128.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 463F449D52
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Nov 2017 11:58:25 -0500 (EST)
Received: by mail-wr0-f193.google.com with SMTP id l22so6204776wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Nov 2017 09:00:26 -0800 (PST)
In-Reply-To: <20171109170021.2984-1-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

VGhlIHN5c3RlbSBzdGF0ZSBvZiBLVk0gd2hlbiB1c2luZyB1c2Vyc3BhY2UgZW11bGF0aW9uIGlz
IG5vdCBjb21wbGV0ZQp1bnRpbCB3ZSByZXR1cm4gaW50byBLVk1fUlVOLiBUbyBoYW5kbGUgbW1p
byByZWxhdGVkIHVwZGF0ZXMgd2Ugd2FpdAp1bnRpbCB0aGV5IGhhdmUgYmVlbiBjb21taXR0ZWQg
YW5kIHRoZW4gc2NoZWR1bGUgb3VyIEtWTV9FWElUX0RFQlVHLgoKVGhlIGt2bV9hcm1faGFuZGxl
X3N0ZXBfZGVidWcoKSBoZWxwZXIgdGVsbHMgdXMgaWYgd2UgbmVlZCB0byByZXR1cm4KYW5kIHNl
dHMgdXAgdGhlIGV4aXRfcmVhc29uIGZvciB1cy4KClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOp
ZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCi0tLQp2MgogIC0gY2FsbCBoZWxwZXIgZGlyZWN0
bHkgZnJvbSBrdm1fYXJjaF92Y3B1X2lvY3RsX3J1bgotLS0KIHZpcnQva3ZtL2FybS9hcm0uYyB8
IDMgKysrCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvdmly
dC9rdm0vYXJtL2FybS5jIGIvdmlydC9rdm0vYXJtL2FybS5jCmluZGV4IDk1Y2JhMDc5OTgyOC4u
Mjk5MWFkZmFjYTlkIDEwMDY0NAotLS0gYS92aXJ0L2t2bS9hcm0vYXJtLmMKKysrIGIvdmlydC9r
dm0vYXJtL2FybS5jCkBAIC02MjUsNiArNjI1LDkgQEAgaW50IGt2bV9hcmNoX3ZjcHVfaW9jdGxf
cnVuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9ydW4gKnJ1bikKIAkJcmV0ID0g
a3ZtX2hhbmRsZV9tbWlvX3JldHVybih2Y3B1LCB2Y3B1LT5ydW4pOwogCQlpZiAocmV0KQogCQkJ
cmV0dXJuIHJldDsKKwkJaWYgKGt2bV9hcm1faGFuZGxlX3N0ZXBfZGVidWcodmNwdSwgdmNwdS0+
cnVuKSkKKwkJCXJldHVybiAxOworCiAJfQogCiAJaWYgKHJ1bi0+aW1tZWRpYXRlX2V4aXQpCi0t
IAoyLjE0LjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
