From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v1 1/2] kvm: arm64: handle single-step during SError exceptions
Date: Thu, 23 Nov 2017 12:11:33 +0000
Message-ID: <20171123121134.11050-2-alex.bennee@linaro.org>
References: <20171123121134.11050-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21A6249D7B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 07:09:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f1oD-SsCSPuQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Nov 2017 07:09:00 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDF4D49D75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 07:08:59 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id u83so16489889wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 04:11:37 -0800 (PST)
In-Reply-To: <20171123121134.11050-1-alex.bennee@linaro.org>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, open list <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

V2hlbiBhbiBTRXJyb3IgYXJyaXZlcyBkdXJpbmcgc2luZ2xlLXN0ZXAgaXQgbWF5IGJlIGRlbGl2
ZXJlZCBiZWZvcmUKdGhlIHN0ZXAgY29tcGxldGVzLiBJbiB0aGF0IGNhc2UgdGhlIERCR19TUFNS
X1NTIGJpdCB3aWxsIGhhdmUgZmxpcHBlZAphcyB0aGUgaW5zdHJ1Y3Rpb24gZXhlY3V0ZWQuIEFm
dGVyIGhhbmRsaW5nIHRoZSBhYm9ydCBpbiBoYW5kbGVfZXhpdCgpCndlIHRlc3QgdG8gc2VlIGlm
IHRoZSBiaXQgaXMgY2xlYXIgYW5kIHdlIHdlcmUgc2luZ2xlLXN0ZXBwaW5nIGJlZm9yZQpkZWNp
ZGluZyBpZiB3ZSBuZWVkIHRvIGV4aXQgdG8gdXNlciBzcGFjZS4KClNpZ25lZC1vZmYtYnk6IEFs
ZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KLS0tCiBhcmNoL2FybTY0L2t2bS9o
YW5kbGVfZXhpdC5jIHwgOCArKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0
LmMgYi9hcmNoL2FybTY0L2t2bS9oYW5kbGVfZXhpdC5jCmluZGV4IDNlNjQ1ZWM5ZTc1MS4uM2Jh
OGM0YTNiY2ZmIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS9oYW5kbGVfZXhpdC5jCisrKyBi
L2FyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmMKQEAgLTI4LDYgKzI4LDcgQEAKICNpbmNsdWRl
IDxhc20va3ZtX2VtdWxhdGUuaD4KICNpbmNsdWRlIDxhc20va3ZtX21tdS5oPgogI2luY2x1ZGUg
PGFzbS9rdm1fcHNjaS5oPgorI2luY2x1ZGUgPGFzbS9kZWJ1Zy1tb25pdG9ycy5oPgogCiAjZGVm
aW5lIENSRUFURV9UUkFDRV9QT0lOVFMKICNpbmNsdWRlICJ0cmFjZS5oIgpAQCAtMjUwLDcgKzI1
MSwxMiBAQCBpbnQgaGFuZGxlX2V4aXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3Zt
X3J1biAqcnVuLAogCQlyZXR1cm4gMTsKIAljYXNlIEFSTV9FWENFUFRJT05fRUwxX1NFUlJPUjoK
IAkJa3ZtX2luamVjdF92YWJ0KHZjcHUpOwotCQlyZXR1cm4gMTsKKwkJLyogV2UgbWF5IHN0aWxs
IG5lZWQgdG8gcmV0dXJuIGZvciBzaW5nbGUtc3RlcCAqLworCQlpZiAoISgqdmNwdV9jcHNyKHZj
cHUpICYgREJHX1NQU1JfU1MpCisJCQkmJiBrdm1fYXJtX2hhbmRsZV9zdGVwX2RlYnVnKHZjcHUs
IHJ1bikpCisJCQlyZXR1cm4gMDsKKwkJZWxzZQorCQkJcmV0dXJuIDE7CiAJY2FzZSBBUk1fRVhD
RVBUSU9OX1RSQVA6CiAJCXJldHVybiBoYW5kbGVfdHJhcF9leGNlcHRpb25zKHZjcHUsIHJ1bik7
CiAJY2FzZSBBUk1fRVhDRVBUSU9OX0hZUF9HT05FOgotLSAKMi4xNS4wCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
