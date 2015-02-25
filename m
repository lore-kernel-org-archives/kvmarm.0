From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 3/6] hw/char/pl011: don't keep setting the IRQ if nothing
 changed
Date: Wed, 25 Feb 2015 16:02:35 +0000
Message-ID: <1424880159-29348-4-git-send-email-alex.bennee@linaro.org>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 132DF4693F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 10:57:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3y6+zxlS5Eo9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Feb 2015 10:57:01 -0500 (EST)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 503AC468E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 10:57:01 -0500 (EST)
In-Reply-To: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

V2hpbGUgb2JzZXJ2aW5nIEtWTSB0cmFjZXMgSSBjYW4gc2VlIGFkZGl0aW9uYWwgSVJRIGNhbGxz
IG9uIHByZXR0eSBtdWNoCmV2ZXJ5IE1NSU8gYWNjZXNzIHdoaWNoIGlzIGp1c3QgcGxhaW4gaW5l
ZmZpY2llbnQuIE9ubHkgdXBkYXRlIHRoZSBRRU1VCklSUSBsZXZlbCBpZiBzb21ldGhpbmcgaGFz
IGFjdHVhbGx5IGNoYW5nZWQgZnJvbSBsYXN0IHRpbWUuIE90aGVyd2lzZSB3ZQptYXkgYmUgcGFw
ZXJpbmcgb3ZlciBvdGhlciBmYWlsdXJlIG1vZGVzLgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5u
w6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgoKZGlmZiAtLWdpdCBhL2h3L2NoYXIvcGwwMTEu
YyBiL2h3L2NoYXIvcGwwMTEuYwppbmRleCAwYTQ1MTE1Li5iYjU1NGJjIDEwMDY0NAotLS0gYS9o
dy9jaGFyL3BsMDExLmMKKysrIGIvaHcvY2hhci9wbDAxMS5jCkBAIC0zNiw2ICszNiw5IEBAIHR5
cGVkZWYgc3RydWN0IFBMMDExU3RhdGUgewogICAgIENoYXJEcml2ZXJTdGF0ZSAqY2hyOwogICAg
IHFlbXVfaXJxIGlycTsKICAgICBjb25zdCB1bnNpZ25lZCBjaGFyICppZDsKKworICAgIC8qIG5v
dCBzZXJpYWxpc2VkLCBwcmV2ZW50cyBwbDAxMV91cGRhdGUgZG9pbmcgZXh0cmEgc2V0X2lycXMg
Ki8KKyAgICB1aW50MzJfdCBjdXJyZW50X2lycTsKIH0gUEwwMTFTdGF0ZTsKIAogI2RlZmluZSBQ
TDAxMV9JTlRfVFggMHgyMApAQCAtNTMsMTAgKzU2LDExIEBAIHN0YXRpYyBjb25zdCB1bnNpZ25l
ZCBjaGFyIHBsMDExX2lkX2x1bWluYXJ5WzhdID0KIAogc3RhdGljIHZvaWQgcGwwMTFfdXBkYXRl
KFBMMDExU3RhdGUgKnMpCiB7Ci0gICAgdWludDMyX3QgZmxhZ3M7Ci0KLSAgICBmbGFncyA9IHMt
PmludF9sZXZlbCAmIHMtPmludF9lbmFibGVkOwotICAgIHFlbXVfc2V0X2lycShzLT5pcnEsIGZs
YWdzICE9IDApOworICAgIHVpbnQzMl90IGZsYWdzID0gcy0+aW50X2xldmVsICYgcy0+aW50X2Vu
YWJsZWQ7CisgICAgaWYgKGZsYWdzICE9IHMtPmN1cnJlbnRfaXJxKSB7CisgICAgICAgIHMtPmN1
cnJlbnRfaXJxID0gZmxhZ3M7CisgICAgICAgIHFlbXVfc2V0X2lycShzLT5pcnEsIHMtPmN1cnJl
bnRfaXJxICE9IDApOworICAgIH0KIH0KIAogc3RhdGljIHVpbnQ2NF90IHBsMDExX3JlYWQodm9p
ZCAqb3BhcXVlLCBod2FkZHIgb2Zmc2V0LAotLSAKMi4zLjAKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
