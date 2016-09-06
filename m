From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 PATCH 2/7] KVM: Track the pid of the VM process
Date: Tue, 6 Sep 2016 08:22:52 +0200
Message-ID: <20160906062252.GA30513@cbox>
References: <1473093097-30932-1-git-send-email-punit.agrawal@arm.com>
 <1473093097-30932-3-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D21B49B1D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 02:12:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IDw9KcLtNPhe for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 02:12:01 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FC7449AF5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 02:12:01 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id w12so72064795wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Sep 2016 23:20:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473093097-30932-3-git-send-email-punit.agrawal@arm.com>
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

T24gTW9uLCBTZXAgMDUsIDIwMTYgYXQgMDU6MzE6MzJQTSArMDEwMCwgUHVuaXQgQWdyYXdhbCB3
cm90ZToKPiBVc2Vyc3BhY2UgdG9vbHMgc3VjaCBhcyBwZXJmIGNhbiBiZSB1c2VkIHRvIHByb2Zp
bGUgaW5kaXZpZHVhbAo+IHByb2Nlc3Nlcy4KPiAKPiBUcmFjayB0aGUgUElEIG9mIHRoZSB2aXJ0
dWFsIG1hY2hpbmUgcHJvY2VzcyB0byBtYXRjaCBwcm9maWxpbmcgcmVxdWVzdHMKPiB0YXJnZXRl
ZCBhdCBpdC4gVGhpcyBjYW4gYmUgdXNlZCB0byB0YWtlIGFwcHJvcHJpYXRlIGFjdGlvbiB0byBl
bmFibGUKPiB0aGUgcmVxdWVzdGVkIHByb2ZpbGluZyBvcGVyYXRpb25zIGZvciB0aGUgVk1zIG9m
IGludGVyZXN0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IFB1bml0IEFncmF3YWwgPHB1bml0LmFncmF3
YWxAYXJtLmNvbT4KPiBDYzogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KPiBD
YzogIlJhZGltIEtyxI1tw6HFmSIgPHJrcmNtYXJAcmVkaGF0LmNvbT4KPiBDYzogQ2hyaXN0b2Zm
ZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5hcm8ub3JnPgo+IENjOiBNYXJjIFp5bmdpZXIg
PG1hcmMuenluZ2llckBhcm0uY29tPgo+IC0tLQo+ICBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0Lmgg
fCAxICsKPiAgdmlydC9rdm0va3ZtX21haW4uYyAgICAgIHwgMiArKwo+ICAyIGZpbGVzIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2t2bV9o
b3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKPiBpbmRleCA5YzI4YjRkLi43YzQyYzk0
IDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+ICsrKyBiL2luY2x1ZGUv
bGludXgva3ZtX2hvc3QuaAo+IEBAIC0zNzQsNiArMzc0LDcgQEAgc3RydWN0IGt2bV9tZW1zbG90
cyB7Cj4gIHN0cnVjdCBrdm0gewo+ICAJc3BpbmxvY2tfdCBtbXVfbG9jazsKPiAgCXN0cnVjdCBt
dXRleCBzbG90c19sb2NrOwo+ICsJc3RydWN0IHBpZCAqcGlkOwo+ICAJc3RydWN0IG1tX3N0cnVj
dCAqbW07IC8qIHVzZXJzcGFjZSB0aWVkIHRvIHRoaXMgdm0gKi8KPiAgCXN0cnVjdCBrdm1fbWVt
c2xvdHMgKm1lbXNsb3RzW0tWTV9BRERSRVNTX1NQQUNFX05VTV07Cj4gIAlzdHJ1Y3Qgc3JjdV9z
dHJ1Y3Qgc3JjdTsKPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3Zt
L2t2bV9tYWluLmMKPiBpbmRleCAxOTUwNzgyLi5hYjI1MzVhIDEwMDY0NAo+IC0tLSBhL3ZpcnQv
a3ZtL2t2bV9tYWluLmMKPiArKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCj4gQEAgLTYxMyw2ICs2
MTMsNyBAQCBzdGF0aWMgc3RydWN0IGt2bSAqa3ZtX2NyZWF0ZV92bSh1bnNpZ25lZCBsb25nIHR5
cGUpCj4gIAlzcGluX2xvY2tfaW5pdCgma3ZtLT5tbXVfbG9jayk7Cj4gIAlhdG9taWNfaW5jKCZj
dXJyZW50LT5tbS0+bW1fY291bnQpOwo+ICAJa3ZtLT5tbSA9IGN1cnJlbnQtPm1tOwo+ICsJa3Zt
LT5waWQgPSBnZXRfdGFza19waWQoY3VycmVudCwgUElEVFlQRV9QSUQpOwoKSG93IGRvb2VzIHRo
aXMgZGVhbCB3aXRoIHRocmVhZGluZz8gIElzIHRoZSBpZGVhIHRoYXQgdGhlIHVzZXIgYnkKc3Bl
Y2lmeWluZyB0aGUgbWFpbiB0aHJlYWQncyBwaWQgd2lsbCBlbmFibGUgdHJhcHBpbmcgZm9yIGFs
bCB2Y3B1CnRocmVhZHMgYmVsb25naW5nIHRvIHRoYXQgVk0/Cgo+ICAJa3ZtX2V2ZW50ZmRfaW5p
dChrdm0pOwo+ICAJbXV0ZXhfaW5pdCgma3ZtLT5sb2NrKTsKPiAgCW11dGV4X2luaXQoJmt2bS0+
aXJxX2xvY2spOwo+IEBAIC03MTIsNiArNzEzLDcgQEAgc3RhdGljIHZvaWQga3ZtX2Rlc3Ryb3lf
dm0oc3RydWN0IGt2bSAqa3ZtKQo+ICAJaW50IGk7Cj4gIAlzdHJ1Y3QgbW1fc3RydWN0ICptbSA9
IGt2bS0+bW07Cj4gIAo+ICsJcHV0X3BpZChrdm0tPnBpZCk7Cj4gIAlrdm1fZGVzdHJveV92bV9k
ZWJ1Z2ZzKGt2bSk7Cj4gIAlrdm1fYXJjaF9zeW5jX2V2ZW50cyhrdm0pOwo+ICAJc3Bpbl9sb2Nr
KCZrdm1fbG9jayk7Cj4gLS0gCj4gMi44LjEKPiAKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
