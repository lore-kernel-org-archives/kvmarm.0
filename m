From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v10 02/18] thread_info: Add update_thread_flag() helpers
Date: Wed, 23 May 2018 15:35:31 +0100
Message-ID: <87lgcatp70.fsf@linaro.org>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-3-git-send-email-Dave.Martin@arm.com>
 <87po1mtrg3.fsf@linaro.org>
 <20180523135732.GK13470@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B6B749F8C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 May 2018 10:25:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yq6JQJ0NOBXr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 May 2018 10:24:54 -0400 (EDT)
Received: from mail-wr0-f196.google.com (mail-wr0-f196.google.com
 [209.85.128.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E4C04A0CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 May 2018 10:24:54 -0400 (EDT)
Received: by mail-wr0-f196.google.com with SMTP id w10-v6so4132225wrk.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 May 2018 07:35:33 -0700 (PDT)
In-reply-to: <20180523135732.GK13470@e103592.cambridge.arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IE9uIFdlZCwgTWF5
IDIzLCAyMDE4IGF0IDAyOjQ2OjUyUE0gKzAxMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4KPj4g
RGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+IHdyaXRlczoKPj4KPj4gPiBUaGVyZSBh
cmUgYSBudW1iZXIgb2YgYml0cyBvZiBjb2RlIHNwcmlua2xlZCBhcm91bmQgdGhlIGtlcm5lbCB0
bwo+PiA+IHNldCBhIHRocmVhZCBmbGFnIGlmIGEgY2VydGFpbiBjb25kaXRpb24gaXMgdHJ1ZSwg
YW5kIGNsZWFyIGl0Cj4+ID4gb3RoZXJ3aXNlLgo+PiA+Cj4+ID4gVG8gaGVscCBtYWtlIHRob3Nl
IGNhbGwgc2l0ZXMgdGVyc2VyIGFuZCBsZXNzIGN1bWJlcnNvbWUsIHRoaXMKPj4gPiBwYXRjaCBh
ZGRzIGEgbmV3IGZhbWlseSBvZiB0aHJlYWQgZmxhZyBtYW5pcHVsYXRvcnMKPj4gPgo+PiA+IAl1
cGRhdGUqX3RocmVhZF9mbGFnKFsuLi4sXSBmbGFnLCBjb25kKQo+PiA+Cj4+ID4gd2hpY2ggZG8g
dGhlIGVxdWl2YWxlbnQgb2Y6Cj4+ID4KPj4gPiAJaWYgKGNvbmQpCj4+ID4gCQlzZXQqX3RocmVh
ZF9mbGFnKFsuLi4sXSBmbGFnKTsKPj4gPiAJZWxzZQo+PiA+IAkJY2xlYXIqX3RocmVhZF9mbGFn
KFsuLi4sXSBmbGFnKTsKPj4gPgo+PiA+IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZl
Lk1hcnRpbkBhcm0uY29tPgo+PiA+IEFja2VkLWJ5OiBTdGV2ZW4gUm9zdGVkdCAoVk13YXJlKSA8
cm9zdGVkdEBnb29kbWlzLm9yZz4KPj4gPiBBY2tlZC1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5
bmdpZXJAYXJtLmNvbT4KPj4gPiBBY2tlZC1ieTogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1h
cmluYXNAYXJtLmNvbT4KPj4gPiBDYzogSW5nbyBNb2xuYXIgPG1pbmdvQHJlZGhhdC5jb20+Cj4+
ID4gQ2M6IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz4KPj4gPiBDYzogT2xl
ZyBOZXN0ZXJvdiA8b2xlZ0ByZWRoYXQuY29tPgo+PiA+IC0tLQo+PiA+ICBpbmNsdWRlL2xpbnV4
L3NjaGVkLmggICAgICAgfCAgNiArKysrKysKPj4gPiAgaW5jbHVkZS9saW51eC90aHJlYWRfaW5m
by5oIHwgMTEgKysrKysrKysrKysKPj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25z
KCspCj4+ID4KPgo+IFsuLi5dCj4KPj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC90aHJl
YWRfaW5mby5oIGIvaW5jbHVkZS9saW51eC90aHJlYWRfaW5mby5oCj4+ID4gaW5kZXggY2YyODYy
Yi4uOGQ4ODIxYiAxMDA2NDQKPj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3RocmVhZF9pbmZvLmgK
Pj4gPiArKysgYi9pbmNsdWRlL2xpbnV4L3RocmVhZF9pbmZvLmgKPj4gPiBAQCAtNjAsNiArNjAs
MTUgQEAgc3RhdGljIGlubGluZSB2b2lkIGNsZWFyX3RpX3RocmVhZF9mbGFnKHN0cnVjdCB0aHJl
YWRfaW5mbyAqdGksIGludCBmbGFnKQo+PiA+ICAJY2xlYXJfYml0KGZsYWcsICh1bnNpZ25lZCBs
b25nICopJnRpLT5mbGFncyk7Cj4+ID4gIH0KPj4gPgo+PiA+ICtzdGF0aWMgaW5saW5lIHZvaWQg
dXBkYXRlX3RpX3RocmVhZF9mbGFnKHN0cnVjdCB0aHJlYWRfaW5mbyAqdGksIGludCBmbGFnLAo+
PiA+ICsJCQkJCSBib29sIHZhbHVlKQo+PiA+ICt7Cj4+ID4gKwlpZiAodmFsdWUpCj4+ID4gKwkJ
c2V0X3RpX3RocmVhZF9mbGFnKHRpLCBmbGFnKTsKPj4gPiArCWVsc2UKPj4gPiArCQljbGVhcl90
aV90aHJlYWRfZmxhZyh0aSwgZmxhZyk7Cj4+ID4gK30KPj4gPiArCj4+Cj4+IHZhbHVlIGRvZXMg
c2VlbSBhIGJpdCBvZiB2YW5pbGxhIG5vbi1pbmZvcm1hdGl2ZSBuYW1lIGZvciBhIGNvbmRpdGlv
bgo+PiBmbGFnIGJ1dCB3aGF0ZXZlcjoKPj4KPj4gUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8
YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPgo+IEkgZ3Vlc3MsIHRob3VnaCBJIGNvdWxkbid0IHNv
bWUgdXAgd2l0aCBhbiBvYnZpb3VzbHkgYmV0dGVyIG5hbWUuCj4KPiBJIHN1cHBvcnQgImNvbmRp
dGlvbiIgd291bGQgaGF2ZSB3b3JrZWQsIGJ1dCBpdCdzIG1vcmUgdmVyYm9zZS4KCldlbGwgYXMg
eW91IHVzZSBjb25kIGluIHRoZSB0ZXh0IEkgdGhpbmsgY29uZCB3b3VsZCBhbHNvIHdvcmsgYXMg
YW4KYWJicmV2aWF0ZWQgdmFyaWFibGUgbmFtZS4gQnV0IGl0cyBhIG1pbm9yIG5pdCA7LSkKCj4K
PiBUaGFua3MgZm9yIHRoZSByZXZpZXcKPiAtLS1EYXZlCgoKLS0KQWxleCBCZW5uw6llCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
