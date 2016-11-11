From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v5 10/11] arm/arm64: gicv3:
 add an IPI test
Date: Fri, 11 Nov 2016 15:20:15 +0000
Message-ID: <a29368b3-d17c-8696-8d72-6ea31eea63be@arm.com>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-11-git-send-email-drjones@redhat.com>
 <874m3f8621.fsf@linaro.org>
 <20161110203713.4idzgs5u2xm7ms4o@hawk.localdomain>
 <871syi8hbg.fsf@linaro.org>
 <20161111135421.5oxdkfqynkgipgom@hawk.localdomain>
 <87twbe6pah.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE4240419
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 10:19:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YYLewoNseY4T for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2016 10:19:17 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA4040416
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 10:19:16 -0500 (EST)
In-Reply-To: <87twbe6pah.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

SGksCgpPbiAxMS8xMS8xNiAxNDo1MywgQWxleCBCZW5uw6llIHdyb3RlOgo+IAo+IEFuZHJldyBK
b25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4gCj4+IE9uIEZyaSwgTm92IDExLCAy
MDE2IGF0IDEwOjAyOjU5QU0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4+Cj4+PiBBbmRy
ZXcgSm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4gd3JpdGVzOgo+Pj4KPj4+PiBPbiBUaHUsIE5v
diAxMCwgMjAxNiBhdCAwNzo1Mzo1OFBNICswMDAwLCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4+Pj4g
Wy4uLl0KPj4+Pj4+ICtzdHJ1Y3QgZ2ljIGdpY3YyID0gewo+Pj4+Pj4gKwkuaXBpID0gewo+Pj4+
Pj4gKwkJLmVuYWJsZSA9IGdpY3YyX2VuYWJsZV9kZWZhdWx0cywKPj4+Pj4+ICsJCS5zZW5kX3Nl
bGYgPSBnaWN2Ml9pcGlfc2VuZF9zZWxmLAo+Pj4+Pj4gKwkJLnNlbmRfdGxpc3QgPSBnaWN2Ml9p
cGlfc2VuZF90bGlzdCwKPj4+Pj4+ICsJCS5zZW5kX2Jyb2FkY2FzdCA9IGdpY3YyX2lwaV9zZW5k
X2Jyb2FkY2FzdCwKPj4+Pj4+ICsJfSwKPj4+Pj4+ICsJLnJlYWRfaWFyID0gZ2ljdjJfcmVhZF9p
YXIsCj4+Pj4+PiArCS5pcnFuciA9IGdpY3YyX2lycW5yLAo+Pj4+Pj4gKwkud3JpdGVfZW9pID0g
Z2ljdjJfd3JpdGVfZW9pLAo+Pj4+Pj4gK307Cj4+Pj4+PiArCj4+Pj4+PiArc3RydWN0IGdpYyBn
aWN2MyA9IHsKPj4+Pj4+ICsJLmlwaSA9IHsKPj4+Pj4+ICsJCS5lbmFibGUgPSBnaWN2M19lbmFi
bGVfZGVmYXVsdHMsCj4+Pj4+PiArCQkuc2VuZF9zZWxmID0gZ2ljdjNfaXBpX3NlbmRfc2VsZiwK
Pj4+Pj4+ICsJCS5zZW5kX3RsaXN0ID0gZ2ljdjNfaXBpX3NlbmRfdGxpc3QsCj4+Pj4+PiArCQku
c2VuZF9icm9hZGNhc3QgPSBnaWN2M19pcGlfc2VuZF9icm9hZGNhc3QsCj4+Pj4+PiArCX0sCj4+
Pj4+PiArCS5yZWFkX2lhciA9IGdpY3YzX3JlYWRfaWFyLAo+Pj4+Pj4gKwkuaXJxbnIgPSBnaWN2
M19pcnFuciwKPj4+Pj4+ICsJLndyaXRlX2VvaSA9IGdpY3YzX3dyaXRlX2VvaXIsCj4+Pj4+PiAr
fTsKPj4+Pj4+ICsKPj4+Pj4KPj4+Pj4gU28gSSB3YXMgcmUtYmFzaW5nIG15IGt2bS11bml0LXRl
c3RzIGFnYWluc3QgeW91ciBHSUMgcmV3b3JrIGFuZCBmb3VuZAo+Pj4+PiBteXNlbGYgY29weSBh
bmQgcGFzdGluZyBhIGJ1bmNoIG9mIHRoaXMgaW50byBteSB0ZXN0cyB0aGF0IGZpcmUgSVJRcy4K
Pj4+Pj4gVGhhdCBtYWtlcyBtZSB0aGluayB0aGUgYWJzdHJhY3Rpb24gc2hvdWxkIGJlIGluIHRo
ZSBsaWJyYXJ5IGNvZGUgc28KPj4+Pj4gb3RoZXIgdGVzdHMgY2FuIGZpZGRsZSB3aXRoIHNlbmRp
bmcgSVJRcy4KPj4+Pj4KPj4+Pj4gV2hhdCBkbyB5b3UgdGhpbms/Cj4+Pj4+Cj4+Pj4KPj4+PiBJ
IGd1ZXNzIHlvdSBtZWFuIG1vdmluZyB0aGUgYWJvdmUgdHdvIHN0cnVjdHMgYW5kIHRoZWlyIGNv
cnJlc3BvbmRpbmcKPj4+PiBmdW5jdGlvbnMgKGFsbCB3aGljaCBhcmVuJ3QgYWxyZWFkeSBjb21t
b24pIHRvIGxpYi9hcm0vID8gT3IgZG8geW91Cj4+Pj4ganVzdCBtZWFuIHRoZSBvbmUgbm9uLXRy
aXZpYWwgZnVuY3Rpb24gZ2ljdjNfaXBpX3NlbmRfdGxpc3Q/IEkgdGhpbmsKPj4+PiBhZ3JlZSB3
aXRoIGdpY3YzX2lwaV9zZW5kX3RsaXN0IGdldHRpbmcgc2hhcmVkLCBidXQgdGhlIG90aGVycyBh
cmUKPj4+PiBtb3N0bHkgb25lLWxpbmVycywgc28gSSdtIG5vdCBzdXJlLiBJIGd1ZXNzIEknZCBo
YXZlIHRvIHNlZSBob3cgeW91J3JlCj4+Pj4gdXNpbmcgdGhlbSBmaXJzdC4KPj4+Cj4+PiBTbyBp
dCBsb29rZWQgbGlrZSB0aGVyZSB3ZXJlIHNvbWUgZnVuY3Rpb25zIGluIHRoZSBjb21tb24gY29k
ZSBmb3Igb25lCj4+PiBHSUMgd2hpY2ggaGFkIGxvY2FsIHRlc3QgZGVmaW5lZCBmdW5jdGlvbnMg
Zm9yIHRoZSBvdGhlci4gVGhleSBzaG91bGQgYXQKPj4+IGxlYXN0IGJlIGNvbnNpc3RlbnQuCj4+
Cj4+IGdpY3YzX3JlYWRfaWFyIGFuZCBnaWN2M193cml0ZV9lb2lyIGJlaW5nIGNvbW1vbiBhbHJl
YWR5IGlzIGEgcHJvZHVjdCBvZgo+PiBiZWluZyBzeXNyZWcgd3JhcHBlcnMsIGFsbG93aW5nIGZv
ciBib3RoIGFybTMyIGFuZCBhcm02NCB0byB1c2UgZnVuY3Rpb25zCj4+IG9mIHRoZSBzYW1lIG5h
bWVzLCBub3QgYmVjYXVzZSBJIHdhbnRlZCBnaWN2MyB0byBiZSBpbmNvbnNpc3RlbnQgd2l0aAo+
PiBnaWN2MiAod2hpY2ggdXNlcyBNTUlPIGFuZCB0aHVzIGRvZXNuJ3QgbmVlZCB3cmFwcGVycykK
Pj4KPj4+Cj4+PiBGb3IgbXkgdXNlIGNhc2UgSSBjb3VsZCBkbyB3aXRoIGEgY29tbW9uOgo+Pj4K
Pj4+ICAgZ2ljX2VuYWJsZQo+Pgo+PiBPSywgSSBjYW4gZXh0ZW5kIGdpY19pbml0KCkgdG8gaW5p
dGlhbGl6ZSBhICdzdHJ1Y3QgZ2ljX2NvbW1vbl9vcHMnIHRoYXQKPj4gaW5jbHVkZXMgYW4gZW5h
YmxlIC0+ICpfZW5hYmxlX2RlZmF1bHRzKHZvaWQpLCBpcGlfc2VuZChpbnQgY3B1KSwKPj4gcmVh
ZF9pYXIodm9pZCksIGlhcl9pcnFucih1MzIgaWFyKSwgYW5kIHdyaXRlX2VvaSh1MzIgaXJxc3Rh
dCkuIEFuZCBhbHNvCj4+IHByb3ZpZGUgdGhlIHdyYXBwZXJzIGdpY19lbmFibGUsIGdpY19pcGlf
c2VuZChjcHUpLCAuLi4KPj4KPj4+ICAgZ2ljX3NlbmRfc3BpKGNwdSwgaXJxKQo+Pgo+PiBJJ2xs
IGxldCB5b3UgYWRkIHRoaXMgb25lIHRvIHRoZSBuZXcgY29tbW9uIG9wcyBzdHJ1Y3QgOi0pCj4+
Cj4+PiAgIGdpY19pcnFfYWNrKCkgd2hpY2ggcmV0dXJucyB0aGUgaWFyLgo+Pgo+PiBUaGlzIG9u
ZSB3aWxsIGJlIGNhbGxlZCByZWFkX2lhci4KPj4KPj4gV291bGQgdGhhdCB3b3JrIGZvciB5b3Us
IEFsZXg/Cj4gCj4gU291bmRzIGdvb2QgdG8gbWUgOi0pCj4gCj4+Cj4+IEFuZHJlLAo+Pgo+PiBX
b3VsZCB0aGlzIGFsc28gc2F0aXNmeSB5b3VyIG5lZWRzIGZvciBtb3JlIGNvbW1vbiBjb2RlPwoK
VEJIIEkgaGF2ZW4ndCBsb29rIGRlZXBseSBlbm91Z2ggdG8gZ2l2ZSBhbiBlZHVjYXRlZCBhbnN3
ZXIuIEkganVzdAp3YW50ZWQgdG8gKzEgQWxleCBmb3IgdGhlIGdlbmVyYWwgZGlyZWN0aW9uLiBT
byBJIGd1ZXNzIGl0J3MgT0suIDstKQoKSSBndWVzcyB3ZSBtYXkgbmVlZCBzb21lIHJlZmFjdG9y
aW5nIGxhdGVyIGFueXdheSwgc28gYW55IG1pc3NpbmcgcGllY2VzCmNhbiBiZSBhZGRlZC9yZWZh
Y3RvcmVkIGxhdGVyIG9uY2Ugd2UgZXhhY3RseSBrbm93IHdoYXQgd2UgbmVlZC4KCkNoZWVycywK
QW5kcmUuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
