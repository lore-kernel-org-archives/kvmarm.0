From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm: VGIC: properly initialise private IRQ affinity
Date: Wed, 6 Mar 2019 11:51:32 +0000
Message-ID: <3f7da1ae-817d-a9fa-8e4b-d4b29ba9b873@arm.com>
References: <20190306104008.69414-1-andre.przywara@arm.com>
 <6382036B-1901-4437-AB57-AC5DE0146377@dinechin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E90584A486
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Mar 2019 06:51:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zKWDWyLRxOqT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Mar 2019 06:51:35 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE9434A409
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Mar 2019 06:51:35 -0500 (EST)
In-Reply-To: <6382036B-1901-4437-AB57-AC5DE0146377@dinechin.org>
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
To: Christophe de Dinechin <christophe.de.dinechin@gmail.com>, Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gMDYvMDMvMjAxOSAxMTo0MiwgQ2hyaXN0b3BoZSBkZSBEaW5lY2hpbiB3cm90ZToKPiAKPiAK
Pj4gT24gNiBNYXIgMjAxOSwgYXQgMTE6NDAsIEFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2Fy
YUBhcm0uY29tPiB3cm90ZToKPj4KPj4gQXQgdGhlIG1vbWVudCB3ZSBpbml0aWFsaXNlIHRoZSB0
YXJnZXQgKm1hc2sqIG9mIGEgdmlydHVhbCBJUlEgdG8gdGhlCj4+IFZDUFUgaXQgYmVsb25ncyB0
bywgZXZlbiB0aG91Z2ggdGhpcyBtYXNrIGlzIG9ubHkgZGVmaW5lZCBmb3IgR0lDdjIgYW5kCj4+
IHF1aWNrbHkgcnVucyBvdXQgb2YgYml0cyBmb3IgbWFueSBHSUN2MyBndWVzdHMuCj4gCj4gSnVz
dCBmb3IgbXkgZWR1Y2F0aW9uLCDigJx0YXJnZXRz4oCdIHNlZW1zIGRlZmluZWQgYXMgYW4gdTgs
Cj4gc28gaXQgbG9va3MgbGlrZSB5b3Ugd2VyZSBzaWxlbnRseSBydW5uaW5nIG91dCBvZiBiaXRz
IGJlZm9yZSwgbm8/CgpZZXMgYW5kIG5vLiBGb3IgYSBHSUN2MyBndWVzdCwgdGhpcyBmaWVsZCBp
cyBuZXZlciBldmFsdWF0ZWQgYXMgYSB1OCwKYnV0IGFzIHRoZSB1MzIgaXQgaXMgYXNzb2NpYXRl
ZCB3aXRoIChzZWUgYXJtX3ZnaWMuaCkuIFBhc3QgdGhlIDh0aAp2Y3B1LCB3ZSdkIGluZGVlZCBl
bmQtdXAgc2V0dGluZyB0aGlzIGZpZWxkIHRvIHplcm8uCgpCdXQgUFBJcyBhcmUgcGVyIENQVSBh
bnl3YXksIGFuZCB3ZSBuZXZlciBldmFsdWF0ZSB0aGUgbXBpZHIgZmllbGQgZm9yCnRob3NlLiBT
byB5ZXMsIHN0dXBpZCBidWcsIGJ1dCBhIGZhaXJseSBoYXJtbGVzcyBvbmUuCgpUaGFua3MsCgoJ
TS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
