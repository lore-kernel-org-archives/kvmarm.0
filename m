From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH v2 14/23] KVM: Allow 2048-bit register access via
 ioctl interface
Date: Tue, 20 Nov 2018 11:20:04 +0000
Message-ID: <87pnv0hu6z.fsf@linaro.org>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-15-git-send-email-Dave.Martin@arm.com>
 <87r2fhhv2z.fsf@linaro.org> <20181119170727.GY3505@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9454A320
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 06:20:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HcTENhh2iQ5w for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Nov 2018 06:20:07 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55FB04A2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 06:20:07 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id q26so1784686wmf.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 03:20:07 -0800 (PST)
In-reply-to: <20181119170727.GY3505@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IE9uIE1vbiwgTm92
IDE5LCAyMDE4IGF0IDA0OjQ4OjM2UE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4KPj4g
RGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+IHdyaXRlczoKPj4KPj4gPiBUaGUgQXJt
IFNWRSBhcmNoaXRlY3R1cmUgZGVmaW5lcyByZWdpc3RlcnMgdGhhdCBhcmUgdXAgdG8gMjA0OCBi
aXRzCj4+ID4gaW4gc2l6ZSAod2l0aCBzb21lIHBvc3NpYmlsaXR5IG9mIGZ1cnRoZXIgZnV0dXJl
IGV4cGFuc2lvbikuCj4+ID4KPj4gPiBJbiBvcmRlciB0byBhdm9pZCB0aGUgbmVlZCBmb3IgYW4g
ZXhjZXNzaXZlbHkgbGFyZ2UgbnVtYmVyIG9mCj4+ID4gaW9jdGxzIHdoZW4gc2F2aW5nIGFuZCBy
ZXN0b3JpbmcgYSB2Y3B1J3MgcmVnaXN0ZXJzLCB0aGlzIHBhdGNoCj4+ID4gYWRkcyBhICNkZWZp
bmUgdG8gbWFrZSBzdXBwb3J0IGZvciBpbmRpdmlkdWFsIDIwNDgtYml0IHJlZ2lzdGVycwo+PiA+
IHRocm91Z2ggdGhlIEtWTV97R0VULFNFVH1fT05FX1JFRyBpb2N0bCBpbnRlcmZhY2Ugb2ZmaWNp
YWwuICBUaGlzCj4+ID4gd2lsbCBhbGxvdyBlYWNoIFNWRSByZWdpc3RlciB0byBiZSBhY2Nlc3Nl
ZCBpbiBhIHNpbmdsZSBjYWxsLgo+PiA+Cj4+ID4gVGhlcmUgYXJlIHN1ZmZpY2llbnQgc3BhcmUg
Yml0cyBpbiB0aGUgcmVnaXN0ZXIgaWQgc2l6ZSBmaWVsZCBmb3IKPj4gPiB0aGlzIGNoYW5nZSwg
c28gdGhlcmUgaXMgbm8gQUJJIGltcGFjdCBwcm92aWRpbmcgdGhhdAo+PiA+IEtWTV9HRVRfUkVH
X0xJU1QgZG9lcyBub3QgZW51bWVyYXRlIGFueSAyMDQ4LWJpdCByZWdpc3RlciB1bmxlc3MKPj4g
PiB1c2Vyc3BhY2UgZXhwbGljaXRseSBvcHRzIGluIHRvIHRoZSByZWxldmFudCBhcmNoaXRlY3R1
cmUtc3BlY2lmaWMKPj4gPiBmZWF0dXJlcy4KPj4gPgo+PiA+IFNpZ25lZC1vZmYtYnk6IERhdmUg
TWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgo+PiA+IC0tLQo+PiA+ICBpbmNsdWRlL3VhcGkv
bGludXgva3ZtLmggfCAxICsKPj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCj4+
ID4KPj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGIvaW5jbHVkZS91
YXBpL2xpbnV4L2t2bS5oCj4+ID4gaW5kZXggMjUxYmUzNS4uN2MzYzVjYyAxMDA2NDQKPj4gPiAt
LS0gYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKPj4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGlu
dXgva3ZtLmgKPj4gPiBAQCAtMTExMCw2ICsxMTEwLDcgQEAgc3RydWN0IGt2bV9kaXJ0eV90bGIg
ewo+PiA+ICAjZGVmaW5lIEtWTV9SRUdfU0laRV9VMjU2CTB4MDA1MDAwMDAwMDAwMDAwMFVMTAo+
PiA+ICAjZGVmaW5lIEtWTV9SRUdfU0laRV9VNTEyCTB4MDA2MDAwMDAwMDAwMDAwMFVMTAo+PiA+
ICAjZGVmaW5lIEtWTV9SRUdfU0laRV9VMTAyNAkweDAwNzAwMDAwMDAwMDAwMDBVTEwKPj4gPiAr
I2RlZmluZSBLVk1fUkVHX1NJWkVfVTIwNDgJMHgwMDgwMDAwMDAwMDAwMDAwVUxMCj4+Cj4+IFll
YWggT0sgSSBndWVzcyAtIGJ1dCBpdCBkb2VzIG1ha2UgbWUgcXVlc3Rpb24gaWYgS1ZNX1JFR19T
SVpFX01BU0sgaXMKPj4gcGFydCBvZiB0aGUgQUJJIGJlY2F1c2UgYWx0aG91Z2ggd2UgaGF2ZSBz
cGFjZSBmb3IgYW5vdGhlciBmZXcgYml0cyB0aGF0Cj4+IGlzIHRoZSBsYXN0IG9uZSB3aXRob3V0
IGNoYW5naW5nIHRoZSBtYXNrLgo+Cj4gRGViYXRhYmxlLCBidXQgS1ZNX1JFR19TSVpFX01BU0sg
aXMgVUFQSSBhbmQgc3VnZ2VzdHMgYSBjbGVhciBpbnRlbnQgbm90Cj4gdG8gcmVjeWNsZSBiaXQg
NTUgZm9yIGFub3RoZXIgcHVycG9zZS4gIFRoaXMgYWxsb3dzIGZvciByZWcgc2l6ZXMgdXAgdG8K
PiAyNjIxNDQgYml0cyB3aGljaCBpcyBob3BlZnVsbHkgbW9yZSB0aGFuIGVub3VnaCBmb3IgdGhl
IGZvcmVzZWVhYmxlCj4gZnV0dXJlLgo+Cj4gRXZlbiBpZiBiaXRzIDU2LTU5IGFyZSBjdXJyZW50
bHkgYWx3YXlzIDAsIEtWTV9SRUdfQVJDSF9NQVNLIHN1Z2dlc3RzCj4gdGhhdCB0aGVzZSBiaXRz
IGFyZW4ndCBnb2luZyB0byBiZSB1c2VkIGZvciBzaXplIGZpZWxkIGJpdHMuCj4KPgo+IE9yIGFt
IEkgbWlzc2luZyBzb21ldGhpbmc/CgpObyB5b3UgYXJlIHF1aXRlIHJpZ2h0IC0gSSB0aG91Z2h0
IEkgd2FzIHdhdGNoaW5nIGFuIGluY3JlbWVudGluZyBiaXQKcG9zaXRpb24gbm90IGFuIGluY3Jl
bWVudGluZyBudW1iZXIuIFRvbyBtdWNoIHN0YXJpbmcgYXQgZGVmaW5lcywgY2FycnkKb24gOy0p
Cgo+Cj4+IFJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+
Cj4KPiBUaGFua3MKPiAtLS1EYXZlCgoKLS0KQWxleCBCZW5uw6llCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
