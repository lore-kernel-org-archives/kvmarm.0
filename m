From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v7 2/7] KVM: kvm_host: add devid in
 kvm_kernel_irq_routing_entry
Date: Thu, 21 Jul 2016 17:54:26 +0100
Message-ID: <5790FE42.103@arm.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-3-git-send-email-eric.auger@redhat.com>
 <20160721161328.GC32739@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11A2349B44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 12:48:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eUSKLOTwvqdb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2016 12:48:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 244C049B32
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 12:48:15 -0400 (EDT)
In-Reply-To: <20160721161328.GC32739@potion>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjEvMDcvMTYgMTc6MTMsIFJhZGltIEtyxI1tw6HFmSB3cm90ZToKPiAyMDE2LTA3LTE4IDEz
OjI1KzAwMDAsIEVyaWMgQXVnZXI6Cj4+IEV4dGVuZCBrdm1fa2VybmVsX2lycV9yb3V0aW5nX2Vu
dHJ5IHRvIHRyYW5zcG9ydCB0aGUgZGV2aWNlIGlkCj4+IGZpZWxkLCBkZXZpZC4gQSBuZXcgZmxh
Z3MgZmllbGQgbWFrZXMgcG9zc2libGUgdG8gaW5kaWNhdGUgdGhlCj4+IGRldmlkIGlzIHZhbGlk
LiBUaG9zZSBhZGRpdGlvbnMgYXJlIHVzZWQgZm9yIEFSTSBHSUN2MyBJVFMgTVNJCj4+IGluamVj
dGlvbi4KPj4KPj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQu
Y29tPgo+PiBBY2tlZC1ieTogQ2hyaXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5h
cm8ub3JnPgo+Pgo+PiAtLS0KPj4gdjYgLT4gdjc6Cj4+IC0gYWRkZWQgbXNpXyBwcmVmaXggdG8g
ZmxhZ3MgYW5kIGRldl9pZCBmaWVsZHMKPj4KPj4gdjQgLT4gdjU6Cj4+IC0gYWRkIENocmlzdG9m
ZmVyJ3MgUi1iCj4+Cj4+IHYyIC0+IHYzOgo+PiAtIGFkZCBmbGFncwo+Pgo+PiB2MSAtPiB2MjoK
Pj4gLSByZXBsYWNlIG1zaV9tc2cgZmllbGQgYnkgYSBzdHJ1Y3QgY29tcG9zZWQgb2YgbXNpX21z
ZyBhbmQgZGV2aWQKPj4KPj4gUkZDIC0+IFBBVENIOgo+PiAtIHJld29yZCB0aGUgY29tbWl0IG1l
c3NhZ2UgYWZ0ZXIgY2hhbmdlIGluIGZpcnN0IHBhdGNoICh1YXBpKQo+PiAtLS0KPj4gIGluY2x1
ZGUvbGludXgva3ZtX2hvc3QuaCB8IDYgKysrKystCj4+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L2t2bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKPj4gaW5kZXggYzg3ZmU2Zi4u
M2QyY2JiNCAxMDA2NDQKPj4gLS0tIGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCj4+ICsrKyBi
L2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+PiBAQCAtMzE3LDcgKzMxNywxMSBAQCBzdHJ1Y3Qg
a3ZtX2tlcm5lbF9pcnFfcm91dGluZ19lbnRyeSB7Cj4+ICAJCQl1bnNpZ25lZCBpcnFjaGlwOwo+
PiAgCQkJdW5zaWduZWQgcGluOwo+PiAgCQl9IGlycWNoaXA7Cj4+IC0JCXN0cnVjdCBtc2lfbXNn
IG1zaTsKPj4gKwkJc3RydWN0IHsKPj4gKwkJCXN0cnVjdCBtc2lfbXNnIG1zaTsKPj4gKwkJCXUz
MiBtc2lfZmxhZ3M7Cj4+ICsJCQl1MzIgbXNpX2RldmlkOwo+IAo+IEknZCBtdWNoIHJhdGhlciBz
ZWUgdGhlbSBhcyBtc2kuZmxhZ3MgYW5kIG1zaS5kZXZpZC4KClRoYXQncyBub3QgcmVhbGx5IHBv
c3NpYmxlLCBhcyBtc2lfbXNnIGlzIHRoZSBjb3JlIGRhdGEgc3RydWN0dXJlIGZvcgpNU0lzLCBh
bmQgbm9ib2R5IHJlYWxseSBleHBlY3RzIHRoaXMgdHJ1Y3R1cmUgdG8gY2hhbmdlLgoKPiBJIGRp
ZG4ndCBub3RpY2UgYSBjb2RlIHRoYXQgcGFzc2VzIHN0cnVjdCBtc2lfbXNnIGFueXdoZXJlLCBz
byB1c2luZyBhbgo+IGFkLWhvYyBzdHJ1Y3QgbGlrZSBpcnFjaGlwIG9yIGRlZmluaW5nIGEgbmV3
IG9uZSB3b3VsZCB3b3JrIGZpbmUuCgpJIGd1ZXNzIHdlIGNvdWxkIGhhdmUgYW4gYXJtLXNwZWNp
ZmljIG9uZToKCgkJc3RydWN0IGFybV9tc2kgewoJCQlzdHJ1Y3QgbXNpX21zZyBtc2c7CgkJCXUz
MiBmbGFnczsKCQkJdTMyIGRldmlkOwoJCX07CgphbmQgdXNlIHRoYXQuIFdvdWxkIHRoYXQgYmUg
T0sgd2l0aCB5b3U/CgpUaGFua3MsCgoJTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qg
c21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
