From: Greg Bellows <greg.bellows@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v2 3/6] hw/char: pl011 don't keep setting the
 IRQ if nothing changed
Date: Wed, 11 Mar 2015 09:44:11 -0500
Message-ID: <CAOgzsHVVw-gZE0_O=NH3xn_4jV2+7=Adrs2tsogwKK_ofptL9Q@mail.gmail.com>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
 <1425479753-18349-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2D874875B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 10:37:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qlTo9cd0z4Sh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 10:37:50 -0400 (EDT)
Received: from mail-qc0-f173.google.com (mail-qc0-f173.google.com
 [209.85.216.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4D4D48741
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 10:37:50 -0400 (EDT)
Received: by qcvx3 with SMTP id x3so10717035qcv.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 07:44:11 -0700 (PDT)
In-Reply-To: <1425479753-18349-4-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, QEMU Developers <qemu-devel@nongnu.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gV2VkLCBNYXIgNCwgMjAxNSBhdCA4OjM1IEFNLCBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVl
QGxpbmFyby5vcmc+IHdyb3RlOgo+IFdoaWxlIG9ic2VydmluZyBLVk0gdHJhY2VzIEkgY2FuIHNl
ZSBhZGRpdGlvbmFsIElSUSBjYWxscyBvbiBwcmV0dHkgbXVjaAo+IGV2ZXJ5IE1NSU8gYWNjZXNz
IHdoaWNoIGlzIGp1c3QgcGxhaW4gaW5lZmZpY2llbnQuIE9ubHkgdXBkYXRlIHRoZSBRRU1VCj4g
SVJRIGxldmVsIGlmIHNvbWV0aGluZyBoYXMgYWN0dWFsbHkgY2hhbmdlZCBmcm9tIGxhc3QgdGlt
ZS4gT3RoZXJ3aXNlIHdlCj4gbWF5IGJlIHBhcGVyaW5nIG92ZXIgb3RoZXIgZmFpbHVyZSBtb2Rl
cy4KPgo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9y
Zz4KPgo+IGRpZmYgLS1naXQgYS9ody9jaGFyL3BsMDExLmMgYi9ody9jaGFyL3BsMDExLmMKPiBp
bmRleCAwYTQ1MTE1Li5iYjU1NGJjIDEwMDY0NAo+IC0tLSBhL2h3L2NoYXIvcGwwMTEuYwo+ICsr
KyBiL2h3L2NoYXIvcGwwMTEuYwo+IEBAIC0zNiw2ICszNiw5IEBAIHR5cGVkZWYgc3RydWN0IFBM
MDExU3RhdGUgewo+ICAgICAgQ2hhckRyaXZlclN0YXRlICpjaHI7Cj4gICAgICBxZW11X2lycSBp
cnE7Cj4gICAgICBjb25zdCB1bnNpZ25lZCBjaGFyICppZDsKPiArCj4gKyAgICAvKiBub3Qgc2Vy
aWFsaXNlZCwgcHJldmVudHMgcGwwMTFfdXBkYXRlIGRvaW5nIGV4dHJhIHNldF9pcnFzICovCj4g
KyAgICB1aW50MzJfdCBjdXJyZW50X2lycTsKPiAgfSBQTDAxMVN0YXRlOwo+Cj4gICNkZWZpbmUg
UEwwMTFfSU5UX1RYIDB4MjAKPiBAQCAtNTMsMTAgKzU2LDExIEBAIHN0YXRpYyBjb25zdCB1bnNp
Z25lZCBjaGFyIHBsMDExX2lkX2x1bWluYXJ5WzhdID0KPgo+ICBzdGF0aWMgdm9pZCBwbDAxMV91
cGRhdGUoUEwwMTFTdGF0ZSAqcykKPiAgewo+IC0gICAgdWludDMyX3QgZmxhZ3M7Cj4gLQo+IC0g
ICAgZmxhZ3MgPSBzLT5pbnRfbGV2ZWwgJiBzLT5pbnRfZW5hYmxlZDsKPiAtICAgIHFlbXVfc2V0
X2lycShzLT5pcnEsIGZsYWdzICE9IDApOwo+ICsgICAgdWludDMyX3QgZmxhZ3MgPSBzLT5pbnRf
bGV2ZWwgJiBzLT5pbnRfZW5hYmxlZDsKPiArICAgIGlmIChmbGFncyAhPSBzLT5jdXJyZW50X2ly
cSkgewo+ICsgICAgICAgIHMtPmN1cnJlbnRfaXJxID0gZmxhZ3M7Cj4gKyAgICAgICAgcWVtdV9z
ZXRfaXJxKHMtPmlycSwgcy0+Y3VycmVudF9pcnEgIT0gMCk7Cj4gKyAgICB9Cj4gIH0KPgo+ICBz
dGF0aWMgdWludDY0X3QgcGwwMTFfcmVhZCh2b2lkICpvcGFxdWUsIGh3YWRkciBvZmZzZXQsCj4g
LS0KPiAyLjMuMQo+Cj4KCkRpZCB5b3UgZmluZCB0aGUgc291cmNlIG9mIHRoZSBhZGRpdGlvbmFs
IElSUXM/IFRoaXMgc2VlbXMgbGlrZSBpdApjb3VsZCBiZSBwb3RlbnRpYWxseSBiZSBoaWRpbmcg
YW4gaXNzdWUuICBGcm9tIGxvb2tpbmcgYXQgdGhlIGNvZGUsIGl0CmFwcGVhcnMgdGhhdCBvbmUg
c291cmNlIG9mIHRoZSBhZGRpdGlvbmFsIHVwZGF0ZXMgaXMgaW4gcGwwMTFfcmVhZCwKd2hlcmUg
d2UgcG9zc2libHkgZG8gYW4gdXBkYXRlIHdpdGhvdXQgYSBjaGFuZ2UgaW4gaW50X2xldmVsLiAg
SQp3b25kZXIgaWYgZmluZGluZyBhbmQgZml4aW5nIHRoZSB1cGRhdGVzIGlzIGEgYmV0dGVyIGFw
cHJvYWNoLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
