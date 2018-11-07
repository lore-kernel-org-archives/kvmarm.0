From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Wed, 7 Nov 2018 18:08:29 +0000
Message-ID: <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com>
References: <20181107171031.22573-1-alex.bennee@linaro.org>
 <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1054A312
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Nov 2018 13:08:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ryrfDRTGYFfk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Nov 2018 13:08:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E142C4A310
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Nov 2018 13:08:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gV2VkLCBOb3YgMDcsIDIwMTggYXQgMDY6MDE6MjBQTSArMDAwMCwgTWFyayBSdXRsYW5kIHdy
b3RlOgo+IE9uIFdlZCwgTm92IDA3LCAyMDE4IGF0IDA1OjEwOjMxUE0gKzAwMDAsIEFsZXggQmVu
bsOpZSB3cm90ZToKPiA+IE5vdCBhbGwgZmF1bHRzIGhhbmRsZWQgYnkgaGFuZGxlX2V4aXQgYXJl
IGluc3RydWN0aW9uIGVtdWxhdGlvbnMuIEZvcgo+ID4gZXhhbXBsZSBhIEVTUl9FTHhfRUNfSUFC
VCB3aWxsIHJlc3VsdCBpbiB0aGUgcGFnZSB0YWJsZXMgYmVpbmcgdXBkYXRlZAo+ID4gYnV0IHRo
ZSBpbnN0cnVjdGlvbiB0aGF0IHRyaWdnZXJlZCB0aGUgZmF1bHQgaGFzbid0IGFjdHVhbGx5IGV4
ZWN1dGVkCj4gPiB5ZXQuIFdlIHVzZSB0aGUgc2ltcGxlIGhldXJpc3RpYyBvZiBjaGVja2luZyBm
b3IgYSBjaGFuZ2VkIFBDIGJlZm9yZQo+ID4gc2VlaW5nIGlmIGt2bV9hcm1faGFuZGxlX3N0ZXBf
ZGVidWcgd2FudHMgdG8gY2xhaW0gd2Ugc3RlcHBlZCBhbgo+ID4gaW5zdHJ1Y3Rpb24uCj4gPiAK
PiA+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4K
PiA+IC0tLQo+ID4gIGFyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmMgfCA0ICsrKy0KPiA+ICAx
IGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gPiAKPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oYW5kbGVfZXhpdC5jIGIvYXJjaC9hcm02NC9rdm0v
aGFuZGxlX2V4aXQuYwo+ID4gaW5kZXggZTVlNzQxYmZmZmUxLi5iODI1MmU3MmY4ODIgMTAwNjQ0
Cj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9oYW5kbGVfZXhpdC5jCj4gPiArKysgYi9hcmNoL2Fy
bTY0L2t2bS9oYW5kbGVfZXhpdC5jCj4gPiBAQCAtMjE0LDYgKzIxNCw3IEBAIHN0YXRpYyBleGl0
X2hhbmRsZV9mbiBrdm1fZ2V0X2V4aXRfaGFuZGxlcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4g
PiAgc3RhdGljIGludCBoYW5kbGVfdHJhcF9leGNlcHRpb25zKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgc3RydWN0IGt2bV9ydW4gKnJ1bikKPiA+ICB7Cj4gPiAgCWludCBoYW5kbGVkOwo+ID4gKyAg
ICAgICAgdW5zaWduZWQgbG9uZyBvbGRfcGMgPSAqdmNwdV9wYyh2Y3B1KTsKPiA+ICAKPiA+ICAJ
LyoKPiA+ICAJICogU2VlIEFSTSBBUk0gQjEuMTQuMTogIkh5cCB0cmFwcyBvbiBpbnN0cnVjdGlv
bnMKPiA+IEBAIC0yMzMsNyArMjM0LDggQEAgc3RhdGljIGludCBoYW5kbGVfdHJhcF9leGNlcHRp
b25zKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2bV9ydW4gKnJ1bikKPiA+ICAJICog
a3ZtX2FybV9oYW5kbGVfc3RlcF9kZWJ1ZygpIHNldHMgdGhlIGV4aXRfcmVhc29uIG9uIHRoZSBr
dm1fcnVuCj4gPiAgCSAqIHN0cnVjdHVyZSBpZiB3ZSBuZWVkIHRvIHJldHVybiB0byB1c2Vyc3Bh
Y2UuCj4gPiAgCSAqLwo+ID4gLQlpZiAoaGFuZGxlZCA+IDAgJiYga3ZtX2FybV9oYW5kbGVfc3Rl
cF9kZWJ1Zyh2Y3B1LCBydW4pKQo+ID4gKwlpZiAoaGFuZGxlZCA+IDAgJiYgKnZjcHVfcGModmNw
dSkgIT0gb2xkX3BjICYmCj4gCj4gVGhpcyBkb2Vzbid0IHdvcmsgaWYgdGhlIGVtdWxhdGlvbiBp
cyBlcXVpdmFsZW50IHRvIGEgYnJhbmNoLXRvLXNlbGYsIHNvCj4gSSBkb24ndCB0aGluayB0aGF0
IHdlIHdhbnQgdG8gZG8gdGhpcy4KPiAKPiBXaGVuIGFyZSB3ZSBmYWlsaW5nIHRvIGFkdmFuY2Ug
dGhlIHNpbmdsZS1zdGVwIHN0YXRlIG1hY2hpbmUgY29ycmVjdGx5PwoKSSBkb24ndCB1bmRlcnN0
YW5kIGhvdyB0aGlzIGlzIGludGVuZGVkIHRvIHdvcmsgY3VycmVudGx5LgoKU3VyZWx5IGt2bV9z
a2lwX2luc3RyKCkgc2hvdWxkIGFkdmFuY2UgdGhlIHN0YXRlIG1hY2hpbmUgYXMgbmVjZXNzYXJ5
LApzbyB0aGF0IHdlIGNhbiByZWx5IG9uIHRoZSBIVyB0byBnZW5lcmF0ZSBhbnkgbmVjZXNzYXJ5
IHNpbmdsZS1zdGVwCmV4Y2VwdGlvbiB3aGVuIHdlIG5leHQgcmV0dXJuIHRvIHRoZSBndWVzdD8K
Ci4uLiBhbmQgaWYgdXNlcnNwYWNlIGRlY2lkZXMgdG8gZW11bGF0ZSBzb21ldGhpbmcsIGl0J3Mg
dXAgdG8gaXQgdG8KYWR2YW5jZSB0aGUgc3RhdGUgbWFjaGluZSBjb25zaXN0ZW50bHkuCgpUaGFu
a3MsCk1hcmsuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
