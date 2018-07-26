From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 13/16] KVM: Allow 2048-bit register access via
 KVM_{GET, SET}_ONE_REG
Date: Thu, 26 Jul 2018 14:55:44 +0100
Message-ID: <871sbqt82n.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-14-git-send-email-Dave.Martin@arm.com>
 <874lgntihl.fsf@linaro.org> <20180726125834.GV4240@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C71254043C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jul 2018 09:55:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2N2j08-2yKG6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jul 2018 09:55:46 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B778740217
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jul 2018 09:55:46 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id h9-v6so1825771wro.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jul 2018 06:55:46 -0700 (PDT)
In-reply-to: <20180726125834.GV4240@e103592.cambridge.arm.com>
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

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IE9uIFdlZCwgSnVs
IDI1LCAyMDE4IGF0IDA0OjU4OjMwUE0gKzAxMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4KPj4g
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
cmUtc3BlY2lmaWMKPj4gPiBmZWF0dXJlcy4KPj4KPj4gRG9lcyBpdD8gSXQncyBub3QgaW4gdGhp
cyBwYXRjaCBhbmQgbG9va2luZyBhdCB0aGUgZmluYWwgdHJlZToKPj4KPj4gICB1bnNpZ25lZCBs
b25nIGt2bV9hcm1fbnVtX3JlZ3Moc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+PiAgIHsKPj4gICAg
ICAgICAgIHVuc2lnbmVkIGxvbmcgcmVzID0gMDsKPj4KPj4gICAgICAgICAgIHJlcyArPSBudW1f
Y29yZV9yZWdzKCk7Cj4+ICAgICAgICAgICByZXMgKz0gbnVtX3N2ZV9yZWdzKHZjcHUpOwo+PiAg
ICAgICAgICAgcmVzICs9IGt2bV9hcm1fbnVtX3N5c19yZWdfZGVzY3ModmNwdSk7Cj4+ICAgICAg
ICAgICByZXMgKz0ga3ZtX2FybV9nZXRfZndfbnVtX3JlZ3ModmNwdSk7Cj4+ICAgICAgICAgICBy
ZXMgKz0gTlVNX1RJTUVSX1JFR1M7Cj4+Cj4+ICAgICAgICAgICByZXR1cm4gcmVzOwo+PiAgIH0K
Pj4KPj4KPj4gd2hpY2ggbGVhZHMgdG86Cj4+Cj4+ICAgc3RhdGljIGludCBlbnVtZXJhdGVfc3Zl
X3JlZ3MoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgX191c2VyICoqdWluZCkKPj4g
ICB7Cj4+ICAgICAgICAgICB1bnNpZ25lZCBpbnQgbiwgaTsKPj4gICAgICAgICAgIGludCBlcnIg
PSAwOwo+PiAgICAgICAgICAgaW50IHRvdGFsID0gMDsKPj4gICAgICAgICAgIHVuc2lnbmVkIGlu
dCBzbGljZXM7Cj4+Cj4+ICAgICAgICAgICBpZiAoIXZjcHVfaGFzX3N2ZSgmdmNwdS0+YXJjaCkp
Cj4+ICAgICAgICAgICAgICAgICAgIHJldHVybiAwOwo+Pgo+PiBXaGljaCBlbnVtZXJhdGVzIHRo
ZSBTVkUgcmVncyBpZiB2Y3B1X2hhc19zdmUoKSB3aGljaCBBRkFJQ1QgaXMgdHJ1ZSBpZgo+PiB0
aGUgaG9zdCBzdXBwb3J0cyBpdCwgbm90IGlmIHRoZSB1c2VyIGhhcyByZXF1ZXN0ZWQgaXQuCj4+
Cj4+IEknbGwgaGF2ZSB0byBjaGVjayB3aGF0IGJ1dCBnaXZlbiB0aGUgaW5kaXJlY3Rpb24gb2Yg
a3ZtX29uZV9yZWcgSQo+PiB3b25kZXIgaWYgZXhpc3RpbmcgYmluYXJpZXMgbWlnaHQgZW5kIHVw
IHNwYW1taW5nIGEgYmFkbHkgc2l6ZWQgYXJyYXkKPj4gd2hlbiBydW4gb24gYSBuZXcgU1ZFIHN1
cHBvcnRpbmcga2VybmVsPwo+Cj4gVGhhdCBzaG91bGRuJ3QgYmUgdGhlIGNhc2U6IHZjcHVfaGFz
X3N2ZSgpIGNoZWNrcyBmb3IgdGhlCj4gS1ZNX0FSTTY0X0dVRVNUX0hBU19TVkUgZmxhZywgd2hp
Y2ggc2hvdWxkIG9ubHkgYmUgc2V0IGlmIHVzZXJzcGFjZSBhc2tzCj4gZm9yIGl0Lgo+Cj4gR2l2
ZSBtZSBhIHNob3V0IGlmIHRoaXMgZG9lc24ndCBzZWVtIHRvIGJlIHRoZSBjYXNlLi4uCgpBaGgg
SSBtaXNzZWQgaXQgdGhlIGZpcnN0IHRpbWU6CgoJCWlmIChzeXN0ZW1fc3VwcG9ydHNfc3ZlKCkg
JiYKCQkgICAgdGVzdF9iaXQoS1ZNX0FSTV9WQ1BVX1NWRSwgdmNwdS0+YXJjaC5mZWF0dXJlcykp
IHsKCQkJdmNwdS0+YXJjaC5mbGFncyB8PSBLVk1fQVJNNjRfR1VFU1RfSEFTX1NWRTsKCkFuZCB2
Y3B1LT5hcmNoLmZlYXR1cmVzIGlzIHNldCBieSB0aGUgdXNlci4gSG93ZXZlciBpdCB3aWxsIGJl
IHNldCBhcwp1bmxlc3MgeW91IHNwZWNpZnkgb3RoZXJ3aXNlIHdlIHVzZSB0aGUgcmVzdWx0cyBv
ZiBwcm9iZWQ6CgogIHJldCA9IGlvY3RsKHZtZmQsIEtWTV9BUk1fUFJFRkVSUkVEX1RBUkdFVCwg
aW5pdCk7CgpzbyB0aGUgdXNlciB3aWxsIGdldCBpdCBieSBkZWZpbml0aW9uIHdoZW4gdGhleSBm
aXJzdCBydW4gb24gU1ZFIGNhcGFibGUKaGFyZHdhcmUuCgoKPgo+IENoZWVycwo+IC0tLURhdmUK
CgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
