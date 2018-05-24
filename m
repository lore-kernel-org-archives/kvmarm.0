From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v11 17/19] KVM: arm64: Remove redundant *exit_code changes in
 fpsimd_guest_exit()
Date: Thu, 24 May 2018 17:56:46 +0100
Message-ID: <1527181008-13549-18-git-send-email-Dave.Martin@arm.com>
References: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D88314A141
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:47:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FLat+A3JE5qL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 12:47:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F654A109
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:47:20 -0400 (EDT)
In-Reply-To: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

SW4gZml4dXBfZ3Vlc3RfZXhpdCgpLCB0aGVyZSBhcmUgYSBjb3VwbGUgb2YgY2FzZXMgd2hlcmUg
YWZ0ZXIKY2hlY2tpbmcgd2hhdCB0aGUgZXhpdCBjb2RlIHdhcywgd2UgYXNzaWduIGl0IGV4cGxp
Y2l0bHkgd2l0aCB0aGUKdmFsdWUgaXQgYWxyZWFkeSBoYWQuCgpBc3N1bWluZyB0aGlzIGlzIG5v
dCBpbmRpY2F0aXZlIG9mIGEgYnVnLCB0aGVzZSBhc3NpZ25tZW50cyBhcmUgbm90Cm5lZWRlZC4K
ClRoaXMgcGF0Y2ggcmVtb3ZlcyB0aGUgcmVkdW5kYW50IGFzc2lnbm1lbnRzLCBhbmQgc2ltcGxp
ZmllcyBzb21lCmlmLW5lc3RpbmcgdGhhdCBiZWNvbWVzIHRyaXZpYWwgYXMgYSByZXN1bHQuCgpO
byBmdW5jdGlvbmFsIGNoYW5nZS4KClNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1h
cnRpbkBhcm0uY29tPgpSZXZpZXdlZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5h
cm8ub3JnPgpBY2tlZC1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KQWNr
ZWQtYnk6IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAYXJtLmNvbT4KLS0tCiBh
cmNoL2FybTY0L2t2bS9oeXAvc3dpdGNoLmMgfCAxNiArKysrLS0tLS0tLS0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9h
cmNoL2FybTY0L2t2bS9oeXAvc3dpdGNoLmMgYi9hcmNoL2FybTY0L2t2bS9oeXAvc3dpdGNoLmMK
aW5kZXggYTZhOGM3ZC4uMThkMGZhYSAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vaHlwL3N3
aXRjaC5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL2h5cC9zd2l0Y2guYwpAQCAtNDAzLDEyICs0MDMs
OCBAQCBzdGF0aWMgYm9vbCBfX2h5cF90ZXh0IGZpeHVwX2d1ZXN0X2V4aXQoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LCB1NjQgKmV4aXRfY29kZSkKIAkJaWYgKHZhbGlkKSB7CiAJCQlpbnQgcmV0ID0g
X192Z2ljX3YyX3BlcmZvcm1fY3B1aWZfYWNjZXNzKHZjcHUpOwogCi0JCQlpZiAocmV0ID09IDEp
IHsKLQkJCQlpZiAoX19za2lwX2luc3RyKHZjcHUpKQotCQkJCQlyZXR1cm4gdHJ1ZTsKLQkJCQll
bHNlCi0JCQkJCSpleGl0X2NvZGUgPSBBUk1fRVhDRVBUSU9OX1RSQVA7Ci0JCQl9CisJCQlpZiAo
cmV0ID09ICAxICYmIF9fc2tpcF9pbnN0cih2Y3B1KSkKKwkJCQlyZXR1cm4gdHJ1ZTsKIAogCQkJ
aWYgKHJldCA9PSAtMSkgewogCQkJCS8qIFByb21vdGUgYW4gaWxsZWdhbCBhY2Nlc3MgdG8gYW4K
QEAgLTQzMCwxMiArNDI2LDggQEAgc3RhdGljIGJvb2wgX19oeXBfdGV4dCBmaXh1cF9ndWVzdF9l
eGl0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0ICpleGl0X2NvZGUpCiAJICAgICBrdm1fdmNw
dV90cmFwX2dldF9jbGFzcyh2Y3B1KSA9PSBFU1JfRUx4X0VDX0NQMTVfMzIpKSB7CiAJCWludCBy
ZXQgPSBfX3ZnaWNfdjNfcGVyZm9ybV9jcHVpZl9hY2Nlc3ModmNwdSk7CiAKLQkJaWYgKHJldCA9
PSAxKSB7Ci0JCQlpZiAoX19za2lwX2luc3RyKHZjcHUpKQotCQkJCXJldHVybiB0cnVlOwotCQkJ
ZWxzZQotCQkJCSpleGl0X2NvZGUgPSBBUk1fRVhDRVBUSU9OX1RSQVA7Ci0JCX0KKwkJaWYgKHJl
dCA9PSAxICYmIF9fc2tpcF9pbnN0cih2Y3B1KSkKKwkJCXJldHVybiB0cnVlOwogCX0KIAogCS8q
IFJldHVybiB0byB0aGUgaG9zdCBrZXJuZWwgYW5kIGhhbmRsZSB0aGUgZXhpdCAqLwotLSAKMi4x
LjQKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
