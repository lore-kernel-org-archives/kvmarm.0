From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 1/4] arm64: KVM: Add braces to multi-line if statement in
 virtual PMU code
Date: Fri,  8 Apr 2016 11:52:12 +0200
Message-ID: <1460109135-6612-2-git-send-email-christoffer.dall@linaro.org>
References: <1460109135-6612-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5249F4053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 05:50:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H2EWUbkxcIcD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 05:50:45 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C0DD40F9B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 05:50:45 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id l6so57844026wml.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 02:52:11 -0700 (PDT)
In-Reply-To: <1460109135-6612-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogV2lsbCBEZWFjb24gPHdpbGwuZGVhY29uQGFybS5jb20+CgpUaGUga2VybmVsIGlzIHdy
aXR0ZW4gaW4gQywgbm90IHB5dGhvbiwgc28gd2UgbmVlZCBicmFjZXMgYXJvdW5kCm11bHRpLWxp
bmUgaWYgc3RhdGVtZW50cy4gR0NDIDYgYWN0dWFsbHkgd2FybnMgYWJvdXQgdGhpcywgdGhhbmtz
IHRvIHRoZQpmYW50YXN0aWMgbmV3ICItV21pc2xlYWRpbmctaW5kZW50YXRpb24iIGZsYWc6Cgog
fCB2aXJ0L2t2bS9hcm0vcG11LmM6IEluIGZ1bmN0aW9uIOKAmGt2bV9wbXVfb3ZlcmZsb3dfc3Rh
dHVz4oCZOgogfCB2aXJ0L2t2bS9hcm0vcG11LmM6MTk4OjM6IHdhcm5pbmc6IHN0YXRlbWVudCBp
cyBpbmRlbnRlZCBhcyBpZiBpdCB3ZXJlIGd1YXJkZWQgYnkuLi4gWy1XbWlzbGVhZGluZy1pbmRl
bnRhdGlvbl0KIHwgICAgcmVnICY9IHZjcHVfc3lzX3JlZyh2Y3B1LCBQTUNOVEVOU0VUX0VMMCk7
CiB8ICAgIF5+fgogfCBhcmNoL2FybTY0L2t2bS8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vcG11LmM6
MTk2OjI6IG5vdGU6IC4uLnRoaXMg4oCYaWbigJkgY2xhdXNlLCBidXQgaXQgaXMgbm90CiB8ICAg
aWYgKCh2Y3B1X3N5c19yZWcodmNwdSwgUE1DUl9FTDApICYgQVJNVjhfUE1VX1BNQ1JfRSkpCiB8
ICAgXn4KCkFzIGl0IHR1cm5zIG91dCwgdGhpcyBwYXJ0aWN1bGFyIGNhc2UgaXMgaGFybWxlc3Mg
KHdlIGp1c3QgZG8gc29tZSAmPQpvcGVyYXRpb25zIHdpdGggMCksIGJ1dCB3b3J0aCBmaXhpbmcg
bm9uZXRoZWxlc3MuCgpTaWduZWQtb2ZmLWJ5OiBXaWxsIERlYWNvbiA8d2lsbC5kZWFjb25AYXJt
LmNvbT4KU2lnbmVkLW9mZi1ieTogQ2hyaXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBs
aW5hcm8ub3JnPgotLS0KIHZpcnQva3ZtL2FybS9wbXUuYyB8IDMgKystCiAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvdmlydC9rdm0v
YXJtL3BtdS5jIGIvdmlydC9rdm0vYXJtL3BtdS5jCmluZGV4IGI1NzU0YzYuLjU3NWM3YWEgMTAw
NjQ0Ci0tLSBhL3ZpcnQva3ZtL2FybS9wbXUuYworKysgYi92aXJ0L2t2bS9hcm0vcG11LmMKQEAg
LTE5MywxMSArMTkzLDEyIEBAIHN0YXRpYyB1NjQga3ZtX3BtdV9vdmVyZmxvd19zdGF0dXMoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQogewogCXU2NCByZWcgPSAwOwogCi0JaWYgKCh2Y3B1X3N5c19y
ZWcodmNwdSwgUE1DUl9FTDApICYgQVJNVjhfUE1VX1BNQ1JfRSkpCisJaWYgKCh2Y3B1X3N5c19y
ZWcodmNwdSwgUE1DUl9FTDApICYgQVJNVjhfUE1VX1BNQ1JfRSkpIHsKIAkJcmVnID0gdmNwdV9z
eXNfcmVnKHZjcHUsIFBNT1ZTU0VUX0VMMCk7CiAJCXJlZyAmPSB2Y3B1X3N5c19yZWcodmNwdSwg
UE1DTlRFTlNFVF9FTDApOwogCQlyZWcgJj0gdmNwdV9zeXNfcmVnKHZjcHUsIFBNSU5URU5TRVRf
RUwxKTsKIAkJcmVnICY9IGt2bV9wbXVfdmFsaWRfY291bnRlcl9tYXNrKHZjcHUpOworCX0KIAog
CXJldHVybiByZWc7CiB9Ci0tIAoyLjEuMi4zMzAuZzU2NTMwMWUuZGlydHkKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
