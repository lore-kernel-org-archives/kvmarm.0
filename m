From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 1/2] kvm/arm: skip MMIO insn after emulation
Date: Tue, 11 Dec 2018 09:30:45 +0100
Message-ID: <20181211083045.GU30263@e113682-lin.lund.arm.com>
References: <20181109150711.45864-1-mark.rutland@arm.com>
 <20181109150711.45864-2-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B7E4A1DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 03:30:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y2526Q2tun9c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 03:30:48 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 422CF4A200
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 03:30:48 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181109150711.45864-2-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gRnJpLCBOb3YgMDksIDIwMTggYXQgMDM6MDc6MTBQTSArMDAwMCwgTWFyayBSdXRsYW5kIHdy
b3RlOgo+IFdoZW4gd2UgZW11bGF0ZSBhbiBNTUlPIGluc3RydWN0aW9uLCB3ZSBhZHZhbmNlIHRo
ZSBDUFUgc3RhdGUgd2l0aGluCj4gZGVjb2RlX2hzcigpLCBiZWZvcmUgZW11bGF0aW5nIHRoZSBp
bnN0cnVjdGlvbiBlZmZlY3RzLgo+IAo+IEhhdmluZyB0aGlzIGxvZ2ljIGluIGRlY29kZV9oc3Io
KSBpcyBvcGFxdWUsIGFuZCBhZHZhbmNpbmcgdGhlIHN0YXRlCj4gYmVmb3JlIGVtdWxhdGlvbiBp
cyBwcm9ibGVtYXRpYy4gSXQgZ2V0cyBpbiB0aGUgd2F5IG9mIGFwcGx5aW5nCj4gY29uc2lzdGVu
dCBzaW5nbGUtc3RlcCBsb2dpYywgYW5kIGl0IHByZXZlbnRzIHVzIGZyb20gYmVpbmcgYWJsZSB0
byBmYWlsCj4gYW4gTU1JTyBpbnN0cnVjdGlvbiB3aXRoIGEgc3luY2hyb25vdXMgZXhjZXB0aW9u
Lgo+IAo+IENsZWFuIHRoaXMgdXAgYnkgb25seSBhZHZhbmNpbmcgdGhlIENQVSBzdGF0ZSAqYWZ0
ZXIqIHRoZSBlZmZlY3RzIG9mIHRoZQo+IGluc3RydWN0aW9uIGFyZSBlbXVsYXRlZC4KPiAKPiBT
aWduZWQtb2ZmLWJ5OiBNYXJrIFJ1dGxhbmQgPG1hcmsucnV0bGFuZEBhcm0uY29tPgo+IENjOiBB
bGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Cj4gQ2M6IENocmlzdG9mZmVyIERh
bGwgPGNocmlzdG9mZmVyLmRhbGxAYXJtLmNvbT4KPiBDYzogTWFyYyBaeW5naWVyIDxtYXJjLnp5
bmdpZXJAYXJtLmNvbT4KPiBDYzogUGV0ZXIgTWF5ZGVsbCA8cGV0ZXIubWF5ZGVsbEBsaW5hcm8u
b3JnPgo+IC0tLQo+ICB2aXJ0L2t2bS9hcm0vbW1pby5jIHwgMTEgKysrKysrLS0tLS0KPiAgMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0t
Z2l0IGEvdmlydC9rdm0vYXJtL21taW8uYyBiL3ZpcnQva3ZtL2FybS9tbWlvLmMKPiBpbmRleCBk
YWM3Y2ViMWE2NzcuLjA4NDQzYTE1ZTZiZSAxMDA2NDQKPiAtLS0gYS92aXJ0L2t2bS9hcm0vbW1p
by5jCj4gKysrIGIvdmlydC9rdm0vYXJtL21taW8uYwo+IEBAIC0xMTcsNiArMTE3LDEyIEBAIGlu
dCBrdm1faGFuZGxlX21taW9fcmV0dXJuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2
bV9ydW4gKnJ1bikKPiAgCQl2Y3B1X3NldF9yZWcodmNwdSwgdmNwdS0+YXJjaC5tbWlvX2RlY29k
ZS5ydCwgZGF0YSk7Cj4gIAl9Cj4gIAo+ICsJLyoKPiArCSAqIFRoZSBNTUlPIGluc3RydWN0aW9u
IGlzIGVtdWxhdGVkIGFuZCBzaG91bGQgbm90IGJlIHJlLWV4ZWN1dGVkCj4gKwkgKiBpbiB0aGUg
Z3Vlc3QuCj4gKwkgKi8KPiArCWt2bV9za2lwX2luc3RyKHZjcHUsIGt2bV92Y3B1X3RyYXBfaWxf
aXMzMmJpdCh2Y3B1KSk7Cj4gKwo+ICAJcmV0dXJuIDA7Cj4gIH0KPiAgCj4gQEAgLTE0NCwxMSAr
MTUwLDYgQEAgc3RhdGljIGludCBkZWNvZGVfaHNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9v
bCAqaXNfd3JpdGUsIGludCAqbGVuKQo+ICAJdmNwdS0+YXJjaC5tbWlvX2RlY29kZS5zaWduX2V4
dGVuZCA9IHNpZ25fZXh0ZW5kOwo+ICAJdmNwdS0+YXJjaC5tbWlvX2RlY29kZS5ydCA9IHJ0Owo+
ICAKPiAtCS8qCj4gLQkgKiBUaGUgTU1JTyBpbnN0cnVjdGlvbiBpcyBlbXVsYXRlZCBhbmQgc2hv
dWxkIG5vdCBiZSByZS1leGVjdXRlZAo+IC0JICogaW4gdGhlIGd1ZXN0Lgo+IC0JICovCj4gLQlr
dm1fc2tpcF9pbnN0cih2Y3B1LCBrdm1fdmNwdV90cmFwX2lsX2lzMzJiaXQodmNwdSkpOwo+ICAJ
cmV0dXJuIDA7Cj4gIH0KPiAgCj4gLS0gCj4gMi4xMS4wCj4gClJldmlld2VkLWJ5OiBDaHJpc3Rv
ZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGFybS5jb20+Cl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
