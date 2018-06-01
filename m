From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/33] KVM: arm64: Remove redundant *exit_code changes in
 fpsimd_guest_exit()
Date: Fri,  1 Jun 2018 16:27:32 +0100
Message-ID: <20180601152747.23613-19-marc.zyngier@arm.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1C9A4A17C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:20:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uIfKq7qtKa1w for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 11:19:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09E614A159
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:17:49 -0400 (EDT)
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpJbiBmaXh1cF9ndWVzdF9l
eGl0KCksIHRoZXJlIGFyZSBhIGNvdXBsZSBvZiBjYXNlcyB3aGVyZSBhZnRlcgpjaGVja2luZyB3
aGF0IHRoZSBleGl0IGNvZGUgd2FzLCB3ZSBhc3NpZ24gaXQgZXhwbGljaXRseSB3aXRoIHRoZQp2
YWx1ZSBpdCBhbHJlYWR5IGhhZC4KCkFzc3VtaW5nIHRoaXMgaXMgbm90IGluZGljYXRpdmUgb2Yg
YSBidWcsIHRoZXNlIGFzc2lnbm1lbnRzIGFyZSBub3QKbmVlZGVkLgoKVGhpcyBwYXRjaCByZW1v
dmVzIHRoZSByZWR1bmRhbnQgYXNzaWdubWVudHMsIGFuZCBzaW1wbGlmaWVzIHNvbWUKaWYtbmVz
dGluZyB0aGF0IGJlY29tZXMgdHJpdmlhbCBhcyBhIHJlc3VsdC4KCk5vIGZ1bmN0aW9uYWwgY2hh
bmdlLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJl
dmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CkFja2VkLWJ5
OiBNYXJjIFp5bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgpBY2tlZC1ieTogQ2hyaXN0b2Zm
ZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBhcm0uY29tPgpTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5
bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgotLS0KIGFyY2gvYXJtNjQva3ZtL2h5cC9zd2l0
Y2guYyB8IDE2ICsrKystLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2h5cC9zd2l0
Y2guYyBiL2FyY2gvYXJtNjQva3ZtL2h5cC9zd2l0Y2guYwppbmRleCBhNmE4YzdkOTE1N2QuLjE4
ZDBmYWE4YzgwNiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vaHlwL3N3aXRjaC5jCisrKyBi
L2FyY2gvYXJtNjQva3ZtL2h5cC9zd2l0Y2guYwpAQCAtNDAzLDEyICs0MDMsOCBAQCBzdGF0aWMg
Ym9vbCBfX2h5cF90ZXh0IGZpeHVwX2d1ZXN0X2V4aXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1
NjQgKmV4aXRfY29kZSkKIAkJaWYgKHZhbGlkKSB7CiAJCQlpbnQgcmV0ID0gX192Z2ljX3YyX3Bl
cmZvcm1fY3B1aWZfYWNjZXNzKHZjcHUpOwogCi0JCQlpZiAocmV0ID09IDEpIHsKLQkJCQlpZiAo
X19za2lwX2luc3RyKHZjcHUpKQotCQkJCQlyZXR1cm4gdHJ1ZTsKLQkJCQllbHNlCi0JCQkJCSpl
eGl0X2NvZGUgPSBBUk1fRVhDRVBUSU9OX1RSQVA7Ci0JCQl9CisJCQlpZiAocmV0ID09ICAxICYm
IF9fc2tpcF9pbnN0cih2Y3B1KSkKKwkJCQlyZXR1cm4gdHJ1ZTsKIAogCQkJaWYgKHJldCA9PSAt
MSkgewogCQkJCS8qIFByb21vdGUgYW4gaWxsZWdhbCBhY2Nlc3MgdG8gYW4KQEAgLTQzMCwxMiAr
NDI2LDggQEAgc3RhdGljIGJvb2wgX19oeXBfdGV4dCBmaXh1cF9ndWVzdF9leGl0KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgdTY0ICpleGl0X2NvZGUpCiAJICAgICBrdm1fdmNwdV90cmFwX2dldF9j
bGFzcyh2Y3B1KSA9PSBFU1JfRUx4X0VDX0NQMTVfMzIpKSB7CiAJCWludCByZXQgPSBfX3ZnaWNf
djNfcGVyZm9ybV9jcHVpZl9hY2Nlc3ModmNwdSk7CiAKLQkJaWYgKHJldCA9PSAxKSB7Ci0JCQlp
ZiAoX19za2lwX2luc3RyKHZjcHUpKQotCQkJCXJldHVybiB0cnVlOwotCQkJZWxzZQotCQkJCSpl
eGl0X2NvZGUgPSBBUk1fRVhDRVBUSU9OX1RSQVA7Ci0JCX0KKwkJaWYgKHJldCA9PSAxICYmIF9f
c2tpcF9pbnN0cih2Y3B1KSkKKwkJCXJldHVybiB0cnVlOwogCX0KIAogCS8qIFJldHVybiB0byB0
aGUgaG9zdCBrZXJuZWwgYW5kIGhhbmRsZSB0aGUgZXhpdCAqLwotLSAKMi4xNy4xCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
