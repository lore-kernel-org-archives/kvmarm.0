From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 08/16] KVM: arm64: Support dynamically hideable system
 registers
Date: Wed, 25 Jul 2018 16:41:44 +0100
Message-ID: <877eljtj9j.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-9-git-send-email-Dave.Martin@arm.com>
 <878t5ztneo.fsf@linaro.org> <20180725143613.GM4240@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E33C40A50
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 11:41:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A3VgXL7Wsdes for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 11:41:47 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4048540493
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 11:41:47 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id b15-v6so7842014wrv.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 08:41:47 -0700 (PDT)
In-reply-to: <20180725143613.GM4240@e103592.cambridge.arm.com>
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
IDI1LCAyMDE4IGF0IDAzOjEyOjE1UE0gKzAxMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4KPj4g
RGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+IHdyaXRlczoKPj4KPj4gPiBTb21lIHN5
c3RlbSByZWdpc3RlcnMgbWF5IG9yIG1heSBub3QgbG9naWNhbGx5IGV4aXN0IGZvciBhIHZjcHUK
Pj4gPiBkZXBlbmRpbmcgb24gd2hldGhlciBjZXJ0YWluIGFyY2hpdGVjdHVyYWwgZmVhdHVyZXMg
YXJlIGVuYWJsZWQgZm9yCj4+ID4gdGhlIHZjcHUuCj4+ID4KPj4gPiBJbiBvcmRlciB0byBhdm9p
ZCBzcHVyaW91c2x5IGVtdWxhdGluZyBhY2Nlc3MgdG8gdGhlc2UgcmVnaXN0ZXJzCj4+ID4gd2hl
biB0aGV5IHNob3VsZCBub3QgZXhpc3QsIG9yIGFsbG93aW5nIHRoZSByZWdpc3RlcnMgdG8gYmUK
Pj4gPiBzcHVyaW91c2x5IGVudW1lcmF0ZWQgb3Igc2F2ZWQvcmVzdG9yZWQgdGhyb3VnaCB0aGUg
aW9jdGwKPj4gPiBpbnRlcmZhY2UsIGEgbWVhbnMgaXMgbmVlZGVkIHRvIGFsbG93IHJlZ2lzdGVy
cyB0byBiZSBoaWRkZW4KPj4gPiBkZXBlbmRpbmcgb24gdGhlIHZjcHUgY29uZmlndXJhdGlvbi4K
Pj4gPgo+PiA+IEluIG9yZGVyIHRvIHN1cHBvcnQgdGhpcyBpbiBhIGZsZXhpYmxlIHdheSwgdGhp
cyBwYXRjaCBhZGRzIGEKPj4gPiBjaGVja19wcmVzZW50KCkgbWV0aG9kIHRvIHN0cnVjdCBzeXNf
cmVnX2Rlc2MsIGFuZCB1cGRhdGVzIHRoZQo+PiA+IGdlbmVyaWMgc3lzdGVtIHJlZ2lzdGVyIGFj
Y2VzcyBhbmQgZW51bWVyYXRpb24gY29kZSB0byBiZSBhd2FyZSBvZgo+PiA+IGl0OiAgaWYgY2hl
Y2tfcHJlc2VudCgpIHJldHVybnMgZmFsc2UsIHRoZSBjb2RlIGJlaGF2ZXMgYXMgaWYgdGhlCj4+
ID4gcmVnaXN0ZXIgZGlkIG5vdCBleGlzdC4KPj4gPgo+PiA+IEZvciBjb252ZW5pZW5jZSwgdGhl
IGNvbXBsZXRlIGNoZWNrIGlzIHdyYXBwZWQgdXAgaW4gYSBuZXcgaGVscGVyCj4+ID4gc3lzX3Jl
Z19wcmVzZW50KCkuCj4+ID4KPj4gPiBBbiBhdHRlbXB0IGhhcyBiZWVuIG1hZGUgdG8gaG9vayB0
aGUgbmV3IGNoZWNrIGludG8gdGhlIGdlbmVyaWMKPj4gPiBhY2Nlc3NvcnMgZm9yIHRyYXBwZWQg
c3lzdGVtIHJlZ2lzdGVycy4gIFRoaXMgc2hvdWxkIHJlZHVjZSB0aGUKPj4gPiBwb3RlbnRpYWwg
Zm9yIGZ1dHVyZSBzdXJwcmlzZXMsIGFsdGhvdWdoIHRoZSByZWR1bmRhbnQgY2hlY2sgd2lsbAo+
PiA+IGFkZCBhIHNtYWxsIGNvc3QuICBObyBzeXN0ZW0gcmVnaXN0ZXIgZGVwZW5kcyBvbiB0aGlz
IGZ1bmN0aW9uYWxpdHkKPj4gPiB5ZXQsIGFuZCBzb21lIHBhdGhzIG5lZWRpbmcgdGhlIGNoZWNr
IG1heSBhbHNvIG5lZWQgYXR0ZW50aW9uLgo+PiA+Cj4+ID4gTmF0dXJhbGx5LCB0aGlzIGZhY2ls
aXR5IG1ha2VzIHNlbnNlIG9ubHkgZm9yIHJlZ2lzdGVycyB0aGF0IGFyZQo+PiA+IHRyYXBwZWQu
Cj4+ID4KPj4gPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNv
bT4KPj4gPiAtLS0KPj4gPiAgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyB8IDIwICsrKysrKysr
KysrKysrKy0tLS0tCj4+ID4gIGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmggfCAxMSArKysrKysr
KysrKwo+PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25z
KC0pCj4KPiBbLi4uXQo+Cj4+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdz
LmggYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5oCj4+ID4gaW5kZXggY2Q3MTBmOC4uZGZiYjM0
MiAxMDA2NDQKPj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5oCj4+ID4gKysrIGIv
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuaAo+PiA+IEBAIC0yMiw2ICsyMiw5IEBACj4+ID4gICNp
Zm5kZWYgX19BUk02NF9LVk1fU1lTX1JFR1NfTE9DQUxfSF9fCj4+ID4gICNkZWZpbmUgX19BUk02
NF9LVk1fU1lTX1JFR1NfTE9DQUxfSF9fCj4+ID4KPj4gPiArI2luY2x1ZGUgPGxpbnV4L2NvbXBp
bGVyLmg+Cj4+ID4gKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgo+Pgo+PiBJIGNhbiBzZWUgd2h5
IHlvdSB3YW50IGNvbXBpbGVyLmgsIGJ1dCB3aHkgdHlwZXMuaD8KPgo+IEZvciBib29sICh0aG91
Z2ggaXQgZmVsdCBhIGJpdCBwZWRhbnRpYykuCgpJdCBtdXN0IGJlIHBpY2tlZCB1cCBlbHNld2hl
cmUgYmVjYXVzZSBpdCBkaWRuJ3QgZmFpbCB3aGVuIEkgcmVidWlsdAp3aXRob3V0IGl0IC0gYW5k
IHRoZSBoZWFkZXIgaGFzIGJlZW4gaGFwcGlseSB1c2luZyBib29sIHVwIHRvIHRoYXQKcG9pbnQu
CgoKPgo+IENoZWVycwo+IC0tLURhdmUKCgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
