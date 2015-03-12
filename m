From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 3/6] hw/char: pl011 don't keep setting the IRQ if
 nothing changed
Date: Thu, 12 Mar 2015 15:51:50 +0000
Message-ID: <CAFEAcA-RhZVe1qwKQ3LzfWbzYVcBQ-jrwTnhH0OX69GNtnoysw@mail.gmail.com>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
 <1425479753-18349-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFB0348AC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 11:45:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3S0rLEra0WoF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2015 11:45:49 -0400 (EDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
 [209.85.217.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BAFE248AC4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 11:45:48 -0400 (EDT)
Received: by lbiz12 with SMTP id z12so16898510lbi.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 08:52:10 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gNCBNYXJjaCAyMDE1IGF0IDE0OjM1LCBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFy
by5vcmc+IHdyb3RlOgo+IFdoaWxlIG9ic2VydmluZyBLVk0gdHJhY2VzIEkgY2FuIHNlZSBhZGRp
dGlvbmFsIElSUSBjYWxscyBvbiBwcmV0dHkgbXVjaAo+IGV2ZXJ5IE1NSU8gYWNjZXNzIHdoaWNo
IGlzIGp1c3QgcGxhaW4gaW5lZmZpY2llbnQuIE9ubHkgdXBkYXRlIHRoZSBRRU1VCj4gSVJRIGxl
dmVsIGlmIHNvbWV0aGluZyBoYXMgYWN0dWFsbHkgY2hhbmdlZCBmcm9tIGxhc3QgdGltZS4gT3Ro
ZXJ3aXNlIHdlCj4gbWF5IGJlIHBhcGVyaW5nIG92ZXIgb3RoZXIgZmFpbHVyZSBtb2Rlcy4KPgo+
IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPgo+
IGRpZmYgLS1naXQgYS9ody9jaGFyL3BsMDExLmMgYi9ody9jaGFyL3BsMDExLmMKPiBpbmRleCAw
YTQ1MTE1Li5iYjU1NGJjIDEwMDY0NAo+IC0tLSBhL2h3L2NoYXIvcGwwMTEuYwo+ICsrKyBiL2h3
L2NoYXIvcGwwMTEuYwo+IEBAIC0zNiw2ICszNiw5IEBAIHR5cGVkZWYgc3RydWN0IFBMMDExU3Rh
dGUgewo+ICAgICAgQ2hhckRyaXZlclN0YXRlICpjaHI7Cj4gICAgICBxZW11X2lycSBpcnE7Cj4g
ICAgICBjb25zdCB1bnNpZ25lZCBjaGFyICppZDsKPiArCj4gKyAgICAvKiBub3Qgc2VyaWFsaXNl
ZCwgcHJldmVudHMgcGwwMTFfdXBkYXRlIGRvaW5nIGV4dHJhIHNldF9pcnFzICovCj4gKyAgICB1
aW50MzJfdCBjdXJyZW50X2lycTsKPiAgfSBQTDAxMVN0YXRlOwo+Cj4gICNkZWZpbmUgUEwwMTFf
SU5UX1RYIDB4MjAKPiBAQCAtNTMsMTAgKzU2LDExIEBAIHN0YXRpYyBjb25zdCB1bnNpZ25lZCBj
aGFyIHBsMDExX2lkX2x1bWluYXJ5WzhdID0KPgo+ICBzdGF0aWMgdm9pZCBwbDAxMV91cGRhdGUo
UEwwMTFTdGF0ZSAqcykKPiAgewo+IC0gICAgdWludDMyX3QgZmxhZ3M7Cj4gLQo+IC0gICAgZmxh
Z3MgPSBzLT5pbnRfbGV2ZWwgJiBzLT5pbnRfZW5hYmxlZDsKPiAtICAgIHFlbXVfc2V0X2lycShz
LT5pcnEsIGZsYWdzICE9IDApOwo+ICsgICAgdWludDMyX3QgZmxhZ3MgPSBzLT5pbnRfbGV2ZWwg
JiBzLT5pbnRfZW5hYmxlZDsKPiArICAgIGlmIChmbGFncyAhPSBzLT5jdXJyZW50X2lycSkgewo+
ICsgICAgICAgIHMtPmN1cnJlbnRfaXJxID0gZmxhZ3M7Cj4gKyAgICAgICAgcWVtdV9zZXRfaXJx
KHMtPmlycSwgcy0+Y3VycmVudF9pcnEgIT0gMCk7Cj4gKyAgICB9Cj4gIH0KCkNvbnNpZGVyIHRo
aXMgc2VxdWVuY2Ugb2YgZXZlbnRzOgoKICogdGhlIGd1ZXN0IGRvZXMgc29tZXRoaW5nIGNhdXNp
bmcgdGhlIGludGVycnVwdCB0bwogICBiZSBhc3NlcnRlZDsgaW50X2xldmVsIGFuZCBpbnRfZW5h
YmxlZCBhcmUgMSwgYW5kCiAgIGN1cnJlbnRfaXJxIGlzIGFsc28gbm93IDEuIFdlIGNhbGwgcWVt
dV9zZXRfaXJxKCkKICAgdG8gcmFpc2UgdGhlIGludGVycnVwdCB3aXRoIHRoZSBHSUMKICogd2Ug
bWlncmF0ZSB0aGUgZ3Vlc3QgdG8gYW5vdGhlciBob3N0CiAqIG9uIHRoZSByZWNlaXZpbmcgZW5k
LCBRRU1VIGlzIGluIGEgY2xlYW5seSByZXNldAogICBzdGF0ZSwgYW5kIHNvIGN1cnJlbnRfaXJx
LCBpbnRfbGV2ZWwgYW5kIGludF9lbmFibGVkCiAgIGFyZSBhbGwgemVybyBiZWZvcmUgaW5jb21p
bmcgZGF0YSBhcnJpdmVzCiAqIGludF9sZXZlbCBhbmQgaW50X2VuYWJsZWQgYXJlIGJvdGggc2V0
IHRvIDEgZnJvbQogICB0aGUgaW5jb21pbmcgZGF0YSBzdHJlYW0KICogdGhlIEdJQyBpdHNlbGYg
aXMgc2V0IHRvIHRoZSAiaW50ZXJydXB0IGlzCiAgIGFzc2VydGVkIiBzdGF0ZSBieSBpdHMgb3du
IGluY29taW5nIGRhdGEKICogY3VycmVudF9pcnEgcmVtYWlucyB6ZXJvLCBiZWNhdXNlIGl0J3Mg
bm90IG1pZ3JhdGVkCiAqIHRoZSBndWVzdCBpcyByZXN1bWVkLCBhbmQgZG9lcyBzb21ldGhpbmcg
dG8gZGVhc3NlcnQKICAgdGhlIGludGVycnVwdC4gdGhlIG5ldyAnZmxhZ3MnIHZhbHVlIGlzIHpl
cm8KICogYmVjYXVzZSBmbGFncyA9PSBzLT5jdXJyZW50X2lycSwgd2UgZG9uJ3QgY2FsbAogICBx
ZW11X3NldF9pcnEsIGFuZCBzbyB3ZSd2ZSBqdXN0IGRyb3BwZWQgdGhlIGRlYXNzZXJ0CiAgIG9m
IHRoaXMgaW50ZXJydXB0IG9uIHRoZSBmbG9vci4KCi0tIFBNTQpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
