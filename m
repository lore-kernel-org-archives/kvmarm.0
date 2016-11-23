From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v7 05/11] arm/arm64: irq enable/disable
Date: Wed, 23 Nov 2016 17:54:00 +0100
Message-ID: <20161123165406.32661-6-drjones@redhat.com>
References: <20161123165406.32661-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D4E40C4F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 11:53:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 531nXlyloZel for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 11:53:43 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7577040CD8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 11:53:43 -0500 (EST)
In-Reply-To: <20161123165406.32661-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

UmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KUmV2aWV3
ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTog
QW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+Ci0tLQogbGliL2FybS9hc20vcHJvY2Vz
c29yLmggICB8IDEwICsrKysrKysrKysKIGxpYi9hcm02NC9hc20vcHJvY2Vzc29yLmggfCAxMCAr
KysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9saWIvYXJtL2FzbS9wcm9jZXNzb3IuaCBiL2xpYi9hcm0vYXNtL3Byb2Nlc3Nvci5oCmluZGV4
IGJjNDZkMWY5ODBlZS4uOTU5ZWNkYTVkY2VkIDEwMDY0NAotLS0gYS9saWIvYXJtL2FzbS9wcm9j
ZXNzb3IuaAorKysgYi9saWIvYXJtL2FzbS9wcm9jZXNzb3IuaApAQCAtMzUsNiArMzUsMTYgQEAg
c3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGN1cnJlbnRfY3Bzcih2b2lkKQogCiAjZGVmaW5l
IGN1cnJlbnRfbW9kZSgpIChjdXJyZW50X2Nwc3IoKSAmIE1PREVfTUFTSykKIAorc3RhdGljIGlu
bGluZSB2b2lkIGxvY2FsX2lycV9lbmFibGUodm9pZCkKK3sKKwlhc20gdm9sYXRpbGUoImNwc2ll
IGkiIDogOiA6ICJtZW1vcnkiLCAiY2MiKTsKK30KKworc3RhdGljIGlubGluZSB2b2lkIGxvY2Fs
X2lycV9kaXNhYmxlKHZvaWQpCit7CisJYXNtIHZvbGF0aWxlKCJjcHNpZCBpIiA6IDogOiAibWVt
b3J5IiwgImNjIik7Cit9CisKIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBnZXRfbXBpZHIo
dm9pZCkKIHsKIAl1bnNpZ25lZCBsb25nIG1waWRyOwpkaWZmIC0tZ2l0IGEvbGliL2FybTY0L2Fz
bS9wcm9jZXNzb3IuaCBiL2xpYi9hcm02NC9hc20vcHJvY2Vzc29yLmgKaW5kZXggOTRmN2NlMzVi
NjVjLi5kNTRhNGVkMWMxODcgMTAwNjQ0Ci0tLSBhL2xpYi9hcm02NC9hc20vcHJvY2Vzc29yLmgK
KysrIGIvbGliL2FybTY0L2FzbS9wcm9jZXNzb3IuaApAQCAtNjgsNiArNjgsMTYgQEAgc3RhdGlj
IGlubGluZSB1bnNpZ25lZCBsb25nIGN1cnJlbnRfbGV2ZWwodm9pZCkKIAlyZXR1cm4gZWwgJiAw
eGM7CiB9CiAKK3N0YXRpYyBpbmxpbmUgdm9pZCBsb2NhbF9pcnFfZW5hYmxlKHZvaWQpCit7CisJ
YXNtIHZvbGF0aWxlKCJtc3IgZGFpZmNsciwgIzIiIDogOiA6ICJtZW1vcnkiKTsKK30KKworc3Rh
dGljIGlubGluZSB2b2lkIGxvY2FsX2lycV9kaXNhYmxlKHZvaWQpCit7CisJYXNtIHZvbGF0aWxl
KCJtc3IgZGFpZnNldCwgIzIiIDogOiA6ICJtZW1vcnkiKTsKK30KKwogI2RlZmluZSBERUZJTkVf
R0VUX1NZU1JFRyhyZWcsIHR5cGUpCQkJCVwKIHN0YXRpYyBpbmxpbmUgdHlwZSBnZXRfIyNyZWco
dm9pZCkJCQkJXAogewkJCQkJCQkJXAotLSAKMi45LjMKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
