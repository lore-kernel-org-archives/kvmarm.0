From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/85] KVM: arm/arm64: No need to zero CNTVOFF in
 kvm_timer_vcpu_put() for VHE
Date: Wed, 28 Mar 2018 13:51:36 +0100
Message-ID: <20180328125254.31380-8-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0BA74A048
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:46:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mUPGPiqYpDDM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:45:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8801A49FBC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:45:23 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogU2hhbmtlciBEb250aGluZW5pIDxzaGFua2VyZEBjb2RlYXVyb3JhLm9yZz4KCkluIEFB
cmNoNjQvQUFyY2gzMiwgdGhlIHZpcnR1YWwgY291bnRlciB1c2VzIGEgZml4ZWQgdmlydHVhbCBv
ZmZzZXQKb2YgemVybyBpbiB0aGUgZm9sbG93aW5nIHNpdHVhdGlvbnMgYXMgcGVyIEFSTXY4IHNw
ZWNpZmljYXRpb25zOgoKMSkgSENSX0VMMi5FMkggaXMgMSwgYW5kIENOVFZDVF9FTDAvQ05UVkNU
IGFyZSByZWFkIGZyb20gRUwyLgoyKSBIQ1JfRUwyLntFMkgsIFRHRX0gaXMgezEsIDF9LCBhbmQg
ZWl0aGVyOgogICDigJQgQ05UVkNUX0VMMCBpcyByZWFkIGZyb20gTm9uLXNlY3VyZSBFTDAgb3Ig
RUwyLgogICDigJQgQ05UVkNUIGlzIHJlYWQgZnJvbSBOb24tc2VjdXJlIEVMMC4KClNvLCBubyBu
ZWVkIHRvIHplcm8gQ05UVk9GRl9FTDIvQ05UVk9GRiBmb3IgVkhFIGNhc2UuCgpBY2tlZC1ieTog
TWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KQWNrZWQtYnk6IENocmlzdG9mZmVy
IERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4KU2lnbmVkLW9mZi1ieTogU2hhbmtl
ciBEb250aGluZW5pIDxzaGFua2VyZEBjb2RlYXVyb3JhLm9yZz4KU2lnbmVkLW9mZi1ieTogQ2hy
aXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5hcm8ub3JnPgotLS0KIHZpcnQva3Zt
L2FybS9hcmNoX3RpbWVyLmMgfCA2ICsrKystLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vYXJjaF90aW1l
ci5jIGIvdmlydC9rdm0vYXJtL2FyY2hfdGltZXIuYwppbmRleCA3MDI2OGMwYmVjNzkuLjg2ZWNh
MzI0NzRjYyAxMDA2NDQKLS0tIGEvdmlydC9rdm0vYXJtL2FyY2hfdGltZXIuYworKysgYi92aXJ0
L2t2bS9hcm0vYXJjaF90aW1lci5jCkBAIC01NDEsOSArNTQxLDExIEBAIHZvaWQga3ZtX3RpbWVy
X3ZjcHVfcHV0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIAkgKiBUaGUga2VybmVsIG1heSBkZWNp
ZGUgdG8gcnVuIHVzZXJzcGFjZSBhZnRlciBjYWxsaW5nIHZjcHVfcHV0LCBzbwogCSAqIHdlIHJl
c2V0IGNudHZvZmYgdG8gMCB0byBlbnN1cmUgYSBjb25zaXN0ZW50IHJlYWQgYmV0d2VlbiB1c2Vy
CiAJICogYWNjZXNzZXMgdG8gdGhlIHZpcnR1YWwgY291bnRlciBhbmQga2VybmVsIGFjY2VzcyB0
byB0aGUgcGh5c2ljYWwKLQkgKiBjb3VudGVyLgorCSAqIGNvdW50ZXIgb2Ygbm9uLVZIRSBjYXNl
LiBGb3IgVkhFLCB0aGUgdmlydHVhbCBjb3VudGVyIHVzZXMgYSBmaXhlZAorCSAqIHZpcnR1YWwg
b2Zmc2V0IG9mIHplcm8sIHNvIG5vIG5lZWQgdG8gemVybyBDTlRWT0ZGX0VMMiByZWdpc3Rlci4K
IAkgKi8KLQlzZXRfY250dm9mZigwKTsKKwlpZiAoIWhhc192aGUoKSkKKwkJc2V0X2NudHZvZmYo
MCk7CiB9CiAKIC8qCi0tIAoyLjE0LjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
