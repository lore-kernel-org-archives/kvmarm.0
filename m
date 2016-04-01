From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Add braces to multi-line if statement in
 virtual PMU code
Date: Fri, 1 Apr 2016 22:23:56 +0800
Message-ID: <56FE847C.80802@linaro.org>
References: <1459509142-13524-1-git-send-email-will.deacon@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5435440F90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 10:23:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bzT5m6xS3AfQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2016 10:23:04 -0400 (EDT)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
 [209.85.220.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A64740F77
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 10:23:03 -0400 (EDT)
Received: by mail-pa0-f44.google.com with SMTP id td3so91081290pab.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2016 07:24:11 -0700 (PDT)
In-Reply-To: <1459509142-13524-1-git-send-email-will.deacon@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjAxNuW5tDA05pyIMDHml6UgMTk6MTIsIFdpbGwgRGVhY29uIHdyb3RlOgo+IFRoZSBrZXJu
ZWwgaXMgd3JpdHRlbiBpbiBDLCBub3QgcHl0aG9uLCBzbyB3ZSBuZWVkIGJyYWNlcyBhcm91bmQK
PiBtdWx0aS1saW5lIGlmIHN0YXRlbWVudHMuIEdDQyA2IGFjdHVhbGx5IHdhcm5zIGFib3V0IHRo
aXMsIHRoYW5rcyB0byB0aGUKPiBmYW50YXN0aWMgbmV3ICItV21pc2xlYWRpbmctaW5kZW50YXRp
b24iIGZsYWc6Cj4gCj4gIHwgdmlydC9rdm0vYXJtL3BtdS5jOiBJbiBmdW5jdGlvbiDigJhrdm1f
cG11X292ZXJmbG93X3N0YXR1c+KAmToKPiAgfCB2aXJ0L2t2bS9hcm0vcG11LmM6MTk4OjM6IHdh
cm5pbmc6IHN0YXRlbWVudCBpcyBpbmRlbnRlZCBhcyBpZiBpdCB3ZXJlIGd1YXJkZWQgYnkuLi4g
Wy1XbWlzbGVhZGluZy1pbmRlbnRhdGlvbl0KPiAgfCAgICByZWcgJj0gdmNwdV9zeXNfcmVnKHZj
cHUsIFBNQ05URU5TRVRfRUwwKTsKPiAgfCAgICBefn4KPiAgfCBhcmNoL2FybTY0L2t2bS8uLi8u
Li8uLi92aXJ0L2t2bS9hcm0vcG11LmM6MTk2OjI6IG5vdGU6IC4uLnRoaXMg4oCYaWbigJkgY2xh
dXNlLCBidXQgaXQgaXMgbm90Cj4gIHwgICBpZiAoKHZjcHVfc3lzX3JlZyh2Y3B1LCBQTUNSX0VM
MCkgJiBBUk1WOF9QTVVfUE1DUl9FKSkKPiAgfCAgIF5+Cj4gCj4gQXMgaXQgdHVybnMgb3V0LCB0
aGlzIHBhcnRpY3VsYXIgY2FzZSBpcyBoYXJtbGVzcyAod2UganVzdCBkbyBzb21lICY9Cj4gb3Bl
cmF0aW9ucyB3aXRoIDApLCBidXQgd29ydGggZml4aW5nIG5vbmV0aGVsZXNzLgo+IApBaCwgdGhh
bmtzISBJIG1pZ2h0IGJlIGZvb2xlZCBhdCB0aGF0IG1vbWVudC4gOikKClJldmlld2VkLWJ5OiBT
aGFubm9uIFpoYW8gPHNoYW5ub24uemhhb0BsaW5hcm8ub3JnPgoKPiBTaWduZWQtb2ZmLWJ5OiBX
aWxsIERlYWNvbiA8d2lsbC5kZWFjb25AYXJtLmNvbT4KPiAtLS0KPiAgdmlydC9rdm0vYXJtL3Bt
dS5jIHwgMyArKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQo+IAo+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vcG11LmMgYi92aXJ0L2t2bS9hcm0v
cG11LmMKPiBpbmRleCBiNTc1NGM2YzU1MDguLjU3NWM3YWEzMGQ3ZSAxMDA2NDQKPiAtLS0gYS92
aXJ0L2t2bS9hcm0vcG11LmMKPiArKysgYi92aXJ0L2t2bS9hcm0vcG11LmMKPiBAQCAtMTkzLDEx
ICsxOTMsMTIgQEAgc3RhdGljIHU2NCBrdm1fcG11X292ZXJmbG93X3N0YXR1cyhzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpCj4gIHsKPiAgCXU2NCByZWcgPSAwOwo+ICAKPiAtCWlmICgodmNwdV9zeXNf
cmVnKHZjcHUsIFBNQ1JfRUwwKSAmIEFSTVY4X1BNVV9QTUNSX0UpKQo+ICsJaWYgKCh2Y3B1X3N5
c19yZWcodmNwdSwgUE1DUl9FTDApICYgQVJNVjhfUE1VX1BNQ1JfRSkpIHsKPiAgCQlyZWcgPSB2
Y3B1X3N5c19yZWcodmNwdSwgUE1PVlNTRVRfRUwwKTsKPiAgCQlyZWcgJj0gdmNwdV9zeXNfcmVn
KHZjcHUsIFBNQ05URU5TRVRfRUwwKTsKPiAgCQlyZWcgJj0gdmNwdV9zeXNfcmVnKHZjcHUsIFBN
SU5URU5TRVRfRUwxKTsKPiAgCQlyZWcgJj0ga3ZtX3BtdV92YWxpZF9jb3VudGVyX21hc2sodmNw
dSk7Cj4gKwl9Cj4gIAo+ICAJcmV0dXJuIHJlZzsKPiAgfQo+IAoKCi0tIApTaGFubm9uCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
