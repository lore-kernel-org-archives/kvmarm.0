From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [RFC v2 PATCH 2/7] KVM: Track the pid of the VM process
Date: Tue, 06 Sep 2016 10:51:27 +0100
Message-ID: <87poohjqzk.fsf@e105922-lin.cambridge.arm.com>
References: <1473093097-30932-1-git-send-email-punit.agrawal@arm.com>
 <1473093097-30932-3-git-send-email-punit.agrawal@arm.com>
 <20160906062252.GA30513@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE5749B3F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 05:43:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K8-Xv11mXuPo for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 05:43:10 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D778349B3D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 05:43:09 -0400 (EDT)
In-Reply-To: <20160906062252.GA30513@cbox> (Christoffer Dall's message of
 "Tue, 6 Sep 2016 08:22:52 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

SGkgQ2hyaXN0b2ZmZXIsCgpDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGxpbmFy
by5vcmc+IHdyaXRlczoKCj4gT24gTW9uLCBTZXAgMDUsIDIwMTYgYXQgMDU6MzE6MzJQTSArMDEw
MCwgUHVuaXQgQWdyYXdhbCB3cm90ZToKPj4gVXNlcnNwYWNlIHRvb2xzIHN1Y2ggYXMgcGVyZiBj
YW4gYmUgdXNlZCB0byBwcm9maWxlIGluZGl2aWR1YWwKPj4gcHJvY2Vzc2VzLgo+PiAKPj4gVHJh
Y2sgdGhlIFBJRCBvZiB0aGUgdmlydHVhbCBtYWNoaW5lIHByb2Nlc3MgdG8gbWF0Y2ggcHJvZmls
aW5nIHJlcXVlc3RzCj4+IHRhcmdldGVkIGF0IGl0LiBUaGlzIGNhbiBiZSB1c2VkIHRvIHRha2Ug
YXBwcm9wcmlhdGUgYWN0aW9uIHRvIGVuYWJsZQo+PiB0aGUgcmVxdWVzdGVkIHByb2ZpbGluZyBv
cGVyYXRpb25zIGZvciB0aGUgVk1zIG9mIGludGVyZXN0Lgo+PiAKPj4gU2lnbmVkLW9mZi1ieTog
UHVuaXQgQWdyYXdhbCA8cHVuaXQuYWdyYXdhbEBhcm0uY29tPgo+PiBDYzogUGFvbG8gQm9uemlu
aSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KPj4gQ2M6ICJSYWRpbSBLcsSNbcOhxZkiIDxya3JjbWFy
QHJlZGhhdC5jb20+Cj4+IENjOiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGxp
bmFyby5vcmc+Cj4+IENjOiBNYXJjIFp5bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgo+PiAt
LS0KPj4gIGluY2x1ZGUvbGludXgva3ZtX2hvc3QuaCB8IDEgKwo+PiAgdmlydC9rdm0va3ZtX21h
aW4uYyAgICAgIHwgMiArKwo+PiAgMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKPj4g
Cj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4
L2t2bV9ob3N0LmgKPj4gaW5kZXggOWMyOGI0ZC4uN2M0MmM5NCAxMDA2NDQKPj4gLS0tIGEvaW5j
bHVkZS9saW51eC9rdm1faG9zdC5oCj4+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+
PiBAQCAtMzc0LDYgKzM3NCw3IEBAIHN0cnVjdCBrdm1fbWVtc2xvdHMgewo+PiAgc3RydWN0IGt2
bSB7Cj4+ICAJc3BpbmxvY2tfdCBtbXVfbG9jazsKPj4gIAlzdHJ1Y3QgbXV0ZXggc2xvdHNfbG9j
azsKPj4gKwlzdHJ1Y3QgcGlkICpwaWQ7Cj4+ICAJc3RydWN0IG1tX3N0cnVjdCAqbW07IC8qIHVz
ZXJzcGFjZSB0aWVkIHRvIHRoaXMgdm0gKi8KPj4gIAlzdHJ1Y3Qga3ZtX21lbXNsb3RzICptZW1z
bG90c1tLVk1fQUREUkVTU19TUEFDRV9OVU1dOwo+PiAgCXN0cnVjdCBzcmN1X3N0cnVjdCBzcmN1
Owo+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWlu
LmMKPj4gaW5kZXggMTk1MDc4Mi4uYWIyNTM1YSAxMDA2NDQKPj4gLS0tIGEvdmlydC9rdm0va3Zt
X21haW4uYwo+PiArKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCj4+IEBAIC02MTMsNiArNjEzLDcg
QEAgc3RhdGljIHN0cnVjdCBrdm0gKmt2bV9jcmVhdGVfdm0odW5zaWduZWQgbG9uZyB0eXBlKQo+
PiAgCXNwaW5fbG9ja19pbml0KCZrdm0tPm1tdV9sb2NrKTsKPj4gIAlhdG9taWNfaW5jKCZjdXJy
ZW50LT5tbS0+bW1fY291bnQpOwo+PiAgCWt2bS0+bW0gPSBjdXJyZW50LT5tbTsKPj4gKwlrdm0t
PnBpZCA9IGdldF90YXNrX3BpZChjdXJyZW50LCBQSURUWVBFX1BJRCk7Cj4KPiBIb3cgZG9vZXMg
dGhpcyBkZWFsIHdpdGggdGhyZWFkaW5nPyAgSXMgdGhlIGlkZWEgdGhhdCB0aGUgdXNlciBieQo+
IHNwZWNpZnlpbmcgdGhlIG1haW4gdGhyZWFkJ3MgcGlkIHdpbGwgZW5hYmxlIHRyYXBwaW5nIGZv
ciBhbGwgdmNwdQo+IHRocmVhZHMgYmVsb25naW5nIHRvIHRoYXQgVk0/CgpZZXMgdGhhdCdzIGNv
cnJlY3QgLSBzcGVjaWZ5aW5nIHRoZSBtYWluIHRocmVhZCBQSUQgd2lsbCBlbmFibGUgdHJhcHBp
bmcKZm9yIHRoZSBWTSAoYWxsIHZjcHVzKS4KCkkgYW0gaGFwcHkgdG8gbW92ZSB0byBhIG1vcmUg
c3VpdGFibGUgaWRlbnRpZmllciBpZiBhdmFpbGFibGUuCgpUaGFua3MsClB1bml0Cgo+Cj4+ICAJ
a3ZtX2V2ZW50ZmRfaW5pdChrdm0pOwo+PiAgCW11dGV4X2luaXQoJmt2bS0+bG9jayk7Cj4+ICAJ
bXV0ZXhfaW5pdCgma3ZtLT5pcnFfbG9jayk7Cj4+IEBAIC03MTIsNiArNzEzLDcgQEAgc3RhdGlj
IHZvaWQga3ZtX2Rlc3Ryb3lfdm0oc3RydWN0IGt2bSAqa3ZtKQo+PiAgCWludCBpOwo+PiAgCXN0
cnVjdCBtbV9zdHJ1Y3QgKm1tID0ga3ZtLT5tbTsKPj4gIAo+PiArCXB1dF9waWQoa3ZtLT5waWQp
Owo+PiAgCWt2bV9kZXN0cm95X3ZtX2RlYnVnZnMoa3ZtKTsKPj4gIAlrdm1fYXJjaF9zeW5jX2V2
ZW50cyhrdm0pOwo+PiAgCXNwaW5fbG9jaygma3ZtX2xvY2spOwo+PiAtLSAKPj4gMi44LjEKPj4g
Cj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBrdm1h
cm0gbWFpbGluZyBsaXN0Cj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQo+IGh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
