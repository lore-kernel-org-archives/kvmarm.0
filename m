From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 14/24] KVM: Allow 2048-bit register access via ioctl
 interface
Date: Tue, 11 Dec 2018 23:28:51 +0000
Message-ID: <1544570941-7377-15-git-send-email-Dave.Martin@arm.com>
References: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7321C4A328
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n3uCT9VSQLq0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 18:30:17 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1264A320
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:17 -0500 (EST)
In-Reply-To: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

VGhlIEFybSBTVkUgYXJjaGl0ZWN0dXJlIGRlZmluZXMgcmVnaXN0ZXJzIHRoYXQgYXJlIHVwIHRv
IDIwNDggYml0cwppbiBzaXplICh3aXRoIHNvbWUgcG9zc2liaWxpdHkgb2YgZnVydGhlciBmdXR1
cmUgZXhwYW5zaW9uKS4KCkluIG9yZGVyIHRvIGF2b2lkIHRoZSBuZWVkIGZvciBhbiBleGNlc3Np
dmVseSBsYXJnZSBudW1iZXIgb2YKaW9jdGxzIHdoZW4gc2F2aW5nIGFuZCByZXN0b3JpbmcgYSB2
Y3B1J3MgcmVnaXN0ZXJzLCB0aGlzIHBhdGNoCmFkZHMgYSAjZGVmaW5lIHRvIG1ha2Ugc3VwcG9y
dCBmb3IgaW5kaXZpZHVhbCAyMDQ4LWJpdCByZWdpc3RlcnMKdGhyb3VnaCB0aGUgS1ZNX3tHRVQs
U0VUfV9PTkVfUkVHIGlvY3RsIGludGVyZmFjZSBvZmZpY2lhbC4gIFRoaXMKd2lsbCBhbGxvdyBl
YWNoIFNWRSByZWdpc3RlciB0byBiZSBhY2Nlc3NlZCBpbiBhIHNpbmdsZSBjYWxsLgoKVGhlcmUg
YXJlIHN1ZmZpY2llbnQgc3BhcmUgYml0cyBpbiB0aGUgcmVnaXN0ZXIgaWQgc2l6ZSBmaWVsZCBm
b3IKdGhpcyBjaGFuZ2UsIHNvIHRoZXJlIGlzIG5vIEFCSSBpbXBhY3QgcHJvdmlkaW5nIHRoYXQK
S1ZNX0dFVF9SRUdfTElTVCBkb2VzIG5vdCBlbnVtZXJhdGUgYW55IDIwNDgtYml0IHJlZ2lzdGVy
IHVubGVzcwp1c2Vyc3BhY2UgZXhwbGljaXRseSBvcHRzIGluIHRvIHRoZSByZWxldmFudCBhcmNo
aXRlY3R1cmUtc3BlY2lmaWMKZmVhdHVyZXMuCgpTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8
RGF2ZS5NYXJ0aW5AYXJtLmNvbT4KUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5u
ZWVAbGluYXJvLm9yZz4KLS0tCiBpbmNsdWRlL3VhcGkvbGludXgva3ZtLmggfCAxICsKIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51
eC9rdm0uaCBiL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaAppbmRleCAyYjdhNjUyLi5lMWU4YjA4
IDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKKysrIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2t2bS5oCkBAIC0xMTMyLDYgKzExMzIsNyBAQCBzdHJ1Y3Qga3ZtX2RpcnR5X3RsYiB7
CiAjZGVmaW5lIEtWTV9SRUdfU0laRV9VMjU2CTB4MDA1MDAwMDAwMDAwMDAwMFVMTAogI2RlZmlu
ZSBLVk1fUkVHX1NJWkVfVTUxMgkweDAwNjAwMDAwMDAwMDAwMDBVTEwKICNkZWZpbmUgS1ZNX1JF
R19TSVpFX1UxMDI0CTB4MDA3MDAwMDAwMDAwMDAwMFVMTAorI2RlZmluZSBLVk1fUkVHX1NJWkVf
VTIwNDgJMHgwMDgwMDAwMDAwMDAwMDAwVUxMCiAKIHN0cnVjdCBrdm1fcmVnX2xpc3QgewogCV9f
dTY0IG47IC8qIG51bWJlciBvZiByZWdzICovCi0tIAoyLjEuNAoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
