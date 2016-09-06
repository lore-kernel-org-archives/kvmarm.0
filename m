From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 PATCH 2/7] KVM: Track the pid of the VM process
Date: Tue, 6 Sep 2016 12:25:42 +0200
Message-ID: <20160906102542.GG30513@cbox>
References: <1473093097-30932-1-git-send-email-punit.agrawal@arm.com>
 <1473093097-30932-3-git-send-email-punit.agrawal@arm.com>
 <20160906062252.GA30513@cbox>
 <87poohjqzk.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E32F849B49
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 06:14:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nWqje3BbDqdq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 06:14:50 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9809349B3F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 06:14:50 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id w12so82954836wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 03:23:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <87poohjqzk.fsf@e105922-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gVHVlLCBTZXAgMDYsIDIwMTYgYXQgMTA6NTE6MjdBTSArMDEwMCwgUHVuaXQgQWdyYXdhbCB3
cm90ZToKPiBIaSBDaHJpc3RvZmZlciwKPiAKPiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZl
ci5kYWxsQGxpbmFyby5vcmc+IHdyaXRlczoKPiAKPiA+IE9uIE1vbiwgU2VwIDA1LCAyMDE2IGF0
IDA1OjMxOjMyUE0gKzAxMDAsIFB1bml0IEFncmF3YWwgd3JvdGU6Cj4gPj4gVXNlcnNwYWNlIHRv
b2xzIHN1Y2ggYXMgcGVyZiBjYW4gYmUgdXNlZCB0byBwcm9maWxlIGluZGl2aWR1YWwKPiA+PiBw
cm9jZXNzZXMuCj4gPj4gCj4gPj4gVHJhY2sgdGhlIFBJRCBvZiB0aGUgdmlydHVhbCBtYWNoaW5l
IHByb2Nlc3MgdG8gbWF0Y2ggcHJvZmlsaW5nIHJlcXVlc3RzCj4gPj4gdGFyZ2V0ZWQgYXQgaXQu
IFRoaXMgY2FuIGJlIHVzZWQgdG8gdGFrZSBhcHByb3ByaWF0ZSBhY3Rpb24gdG8gZW5hYmxlCj4g
Pj4gdGhlIHJlcXVlc3RlZCBwcm9maWxpbmcgb3BlcmF0aW9ucyBmb3IgdGhlIFZNcyBvZiBpbnRl
cmVzdC4KPiA+PiAKPiA+PiBTaWduZWQtb2ZmLWJ5OiBQdW5pdCBBZ3Jhd2FsIDxwdW5pdC5hZ3Jh
d2FsQGFybS5jb20+Cj4gPj4gQ2M6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+
Cj4gPj4gQ2M6ICJSYWRpbSBLcsSNbcOhxZkiIDxya3JjbWFyQHJlZGhhdC5jb20+Cj4gPj4gQ2M6
IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4KPiA+PiBDYzog
TWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KPiA+PiAtLS0KPiA+PiAgaW5jbHVk
ZS9saW51eC9rdm1faG9zdC5oIHwgMSArCj4gPj4gIHZpcnQva3ZtL2t2bV9tYWluLmMgICAgICB8
IDIgKysKPiA+PiAgMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKPiA+PiAKPiA+PiBk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oIGIvaW5jbHVkZS9saW51eC9rdm1f
aG9zdC5oCj4gPj4gaW5kZXggOWMyOGI0ZC4uN2M0MmM5NCAxMDA2NDQKPiA+PiAtLS0gYS9pbmNs
dWRlL2xpbnV4L2t2bV9ob3N0LmgKPiA+PiArKysgYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgK
PiA+PiBAQCAtMzc0LDYgKzM3NCw3IEBAIHN0cnVjdCBrdm1fbWVtc2xvdHMgewo+ID4+ICBzdHJ1
Y3Qga3ZtIHsKPiA+PiAgCXNwaW5sb2NrX3QgbW11X2xvY2s7Cj4gPj4gIAlzdHJ1Y3QgbXV0ZXgg
c2xvdHNfbG9jazsKPiA+PiArCXN0cnVjdCBwaWQgKnBpZDsKPiA+PiAgCXN0cnVjdCBtbV9zdHJ1
Y3QgKm1tOyAvKiB1c2Vyc3BhY2UgdGllZCB0byB0aGlzIHZtICovCj4gPj4gIAlzdHJ1Y3Qga3Zt
X21lbXNsb3RzICptZW1zbG90c1tLVk1fQUREUkVTU19TUEFDRV9OVU1dOwo+ID4+ICAJc3RydWN0
IHNyY3Vfc3RydWN0IHNyY3U7Cj4gPj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMg
Yi92aXJ0L2t2bS9rdm1fbWFpbi5jCj4gPj4gaW5kZXggMTk1MDc4Mi4uYWIyNTM1YSAxMDA2NDQK
PiA+PiAtLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5jCj4gPj4gKysrIGIvdmlydC9rdm0va3ZtX21h
aW4uYwo+ID4+IEBAIC02MTMsNiArNjEzLDcgQEAgc3RhdGljIHN0cnVjdCBrdm0gKmt2bV9jcmVh
dGVfdm0odW5zaWduZWQgbG9uZyB0eXBlKQo+ID4+ICAJc3Bpbl9sb2NrX2luaXQoJmt2bS0+bW11
X2xvY2spOwo+ID4+ICAJYXRvbWljX2luYygmY3VycmVudC0+bW0tPm1tX2NvdW50KTsKPiA+PiAg
CWt2bS0+bW0gPSBjdXJyZW50LT5tbTsKPiA+PiArCWt2bS0+cGlkID0gZ2V0X3Rhc2tfcGlkKGN1
cnJlbnQsIFBJRFRZUEVfUElEKTsKPiA+Cj4gPiBIb3cgZG9vZXMgdGhpcyBkZWFsIHdpdGggdGhy
ZWFkaW5nPyAgSXMgdGhlIGlkZWEgdGhhdCB0aGUgdXNlciBieQo+ID4gc3BlY2lmeWluZyB0aGUg
bWFpbiB0aHJlYWQncyBwaWQgd2lsbCBlbmFibGUgdHJhcHBpbmcgZm9yIGFsbCB2Y3B1Cj4gPiB0
aHJlYWRzIGJlbG9uZ2luZyB0byB0aGF0IFZNPwo+IAo+IFllcyB0aGF0J3MgY29ycmVjdCAtIHNw
ZWNpZnlpbmcgdGhlIG1haW4gdGhyZWFkIFBJRCB3aWxsIGVuYWJsZSB0cmFwcGluZwo+IGZvciB0
aGUgVk0gKGFsbCB2Y3B1cykuCj4gCj4gSSBhbSBoYXBweSB0byBtb3ZlIHRvIGEgbW9yZSBzdWl0
YWJsZSBpZGVudGlmaWVyIGlmIGF2YWlsYWJsZS4KPiAKCldoYXQgaXMgdGhlICdtYWluIHRocmVh
ZCcgPwoKRG9lcyBzb21ldGhpbmcgbWFuZGF0ZSB0aGF0IHRoZSBWTSBpcyBjcmVhdGVkIGJ5IHRo
ZSB0aHJlYWQgZ3JvdXAKbGVhZGVyPyAgSWYgbm90LCBpcyBpdCBub3QgYSBiaXQgc3RyYW5nZSBm
cm9tIGEgdXNlciBwZXJzcGVjdGl2ZSwgdGhhdAp5b3UgaGF2ZSB0byBmaW5kIHRoZSBzcGVjaWZp
YyBzdWJ0aHJlYWQgcGlkIHRoYXQgY3JlYXRlZCB0aGUgdm0gdG8KZW5hYmxlIHRoaXMgdHJhY2lu
ZyBmb3IgYWxsIHZjcHUgdGhyZWFkcyBhbmQgdGhhdCB0aGUgdGdpZCBkb2Vzbid0IHdvcmsKaW4g
dGhpcyBjYXNlPwoKVGhhbmtzLAotQ2hyaXN0b2ZmZXIKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
