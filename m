From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v1 2/2] kvm: arm64: handle single-step of userspace mmio
 instructions
Date: Fri, 6 Oct 2017 14:13:38 +0100
Message-ID: <a9f8905e-18e9-267a-2479-f498c248e2f4@arm.com>
References: <20171006113921.24880-1-alex.bennee@linaro.org>
 <20171006113921.24880-3-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 893D549C26
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 09:13:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 64eUeXafGhLx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Oct 2017 09:13:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B52C405F9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 09:13:13 -0400 (EDT)
In-Reply-To: <20171006113921.24880-3-alex.bennee@linaro.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAwNi8xMC8xNyAxMjozOSwgQWxleCBCZW5uw6llIHdyb3RlOgo+IFRoZSBzeXN0ZW0gc3Rh
dGUgb2YgS1ZNIHdoZW4gdXNpbmcgdXNlcnNwYWNlIGVtdWxhdGlvbiBpcyBub3QgY29tcGxldGUK
PiB1bnRpbCB3ZSByZXR1cm4gaW50byBLVk1fUlVOLiBUbyBoYW5kbGUgbW1pbyByZWxhdGVkIHVw
ZGF0ZXMgd2Ugd2FpdAo+IHVudGlsIHRoZXkgaGF2ZSBiZWVuIGNvbW1pdHRlZCBhbmQgdGhlbiBz
Y2hlZHVsZSBvdXIgS1ZNX0VYSVRfREVCVUcuCj4gCj4gSSd2ZSBpbnRyb2R1Y2VkIGEgbmV3IGZ1
bmN0aW9uIGt2bV9hcm1fbWF5YmVfcmV0dXJuX2RlYnVnKCkgdG8gd3JhcCB1cAo+IHRoZSBkaWZm
ZXJlbmNlcyBiZXR3ZWVuIGFybS9hcm02NCB3aGljaCBpcyBjdXJyZW50bHkgbnVsbCBmb3IgYXJt
Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9y
Zz4KPiAtLS0KPiAgIGFyY2gvYXJtL2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggICB8ICAyICsrCj4g
ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggfCAgMSArCj4gICBhcmNoL2FybTY0
L2t2bS9kZWJ1Zy5jICAgICAgICAgICAgfCAyMSArKysrKysrKysrKysrKysrKysrKysKPiAgIGFy
Y2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmMgICAgICB8ICA5ICsrKy0tLS0tLQo+ICAgdmlydC9r
dm0vYXJtL2FybS5jICAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgIHZpcnQva3ZtL2FybS9tbWlv
LmMgICAgICAgICAgICAgICB8ICAzICsrLQo+ICAgNiBmaWxlcyBjaGFuZ2VkLCAzMCBpbnNlcnRp
b25zKCspLCA4IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9hcmNoL2FybS9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oIGIvYXJjaC9hcm0vaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+IGluZGV4
IDRhODc5ZjZmZjEzYi4uYWVjOTQzZjZkMTIzIDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtL2luY2x1
ZGUvYXNtL2t2bV9ob3N0LmgKPiArKysgYi9hcmNoL2FybS9pbmNsdWRlL2FzbS9rdm1faG9zdC5o
Cj4gQEAgLTI4NSw2ICsyODUsOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2FybV9pbml0X2Rl
YnVnKHZvaWQpIHt9Cj4gICBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2FybV9zZXR1cF9kZWJ1Zyhz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHt9Cj4gICBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2FybV9j
bGVhcl9kZWJ1ZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHt9Cj4gICBzdGF0aWMgaW5saW5lIHZv
aWQga3ZtX2FybV9yZXNldF9kZWJ1Z19wdHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KSB7fQo+ICtz
dGF0aWMgaW5saW5lIGludCAga3ZtX2FybV9tYXliZV9yZXR1cm5fZGVidWcoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LAo+ICsJCQkJCQlzdHJ1Y3Qga3ZtX3J1biAqcnVuKSB7fQo+ICAgCgpUaGlzIGZ1
bmN0aW9uIHNob3VsZCByZXR1cm4gMS4KCj4gICBpbnQga3ZtX2FybV92Y3B1X2FyY2hfc2V0X2F0
dHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+ICAgCQkJICAgICAgIHN0cnVjdCBrdm1fZGV2aWNl
X2F0dHIgKmF0dHIpOwo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9o
b3N0LmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPiBpbmRleCBlOTIzYjU4
NjA2ZTIuLmZhNjdkMjE2NjJmNiAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9ob3N0LmgKPiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPiBA
QCAtMzY5LDYgKzM2OSw3IEBAIHZvaWQga3ZtX2FybV9pbml0X2RlYnVnKHZvaWQpOwo+ICAgdm9p
ZCBrdm1fYXJtX3NldHVwX2RlYnVnKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cj4gICB2b2lkIGt2
bV9hcm1fY2xlYXJfZGVidWcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKPiAgIHZvaWQga3ZtX2Fy
bV9yZXNldF9kZWJ1Z19wdHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKPiAraW50ICBrdm1fYXJt
X21heWJlX3JldHVybl9kZWJ1ZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcnVu
ICpydW4pOwoKSSBmZWVsIHRoZSBuYW1lIGNvdWxkIGJlIGEgbGl0dGxlIGJpdCBtb3JlIGV4cGxp
Y2l0OgoKa3ZtX2FybV90cmFwX25lZWRfc3RlcF9kZWJ1Zywga3ZtX2FybV90cmFwX3N0ZXBfcmV0
dXJuX2RlYnVnLCAKa3ZtX2FybV90cmFwX25lZWRfcmV0dXJuX2RlYnVnLgoKQXQgbGVhc3QsIEkg
dGhpbmsgaXQgd291bGQgYmUgbmljZSB0aGF0IHRoZSBuYW1lIHJlZmxlY3QgdGhhdCB0aGlzIGNo
ZWNrIAppcyBtZWFudCBmb3IgZW11bGF0ZWQgaW5zdHJ1Y3Rpb25zLgoKT3RoZXJ3aXNlOgoKUmV2
aWV3ZWQtYnk6IEp1bGllbiBUaGllcnJ5IDxqdWxpZW4udGhpZXJyeUBhcm0uY29tPgoKVGhhbmtz
LAoKLS0gCkp1bGllbiBUaGllcnJ5Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
