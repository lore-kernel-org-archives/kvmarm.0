From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v11 13/19] arm64/sve: Switch sve_pffr() argument from task to
 thread
Date: Thu, 24 May 2018 17:56:42 +0100
Message-ID: <1527181008-13549-14-git-send-email-Dave.Martin@arm.com>
References: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E56244A0E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:47:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I2JxCotQ1efW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 12:47:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2CF4A102
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:47:14 -0400 (EDT)
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

c3ZlX3BmZnIoKSwgd2hpY2ggaXMgdXNlZCB0byBkZXJpdmUgdGhlIGJhc2UgYWRkcmVzcyB1c2Vk
IGZvcgpsb3ctbGV2ZWwgU1ZFIHNhdmUvcmVzdG9yZSByb3V0aW5lcywgY3VycmVudGx5IHRha2Vz
IHRoZSByZWxldmFudAp0YXNrX3N0cnVjdCBhcyBhbiBhcmd1bWVudC4KClRoZSBvbmx5IGFjY2Vz
c2VkIGZpZWxkcyBhcmUgYWN0dWFsbHkgcGFydCBvZiB0aHJlYWRfc3RydWN0LCBzbwp0aGlzIHBh
dGNoIGNoYW5nZXMgdGhlIGFyZ3VtZW50IHR5cGUgYWNjb3JkaW5nbHkuICBUaGlzIGlzIGRvbmUg
aW4KcHJlcGFyYXRpb24gZm9yIG1vdmluZyB0aGlzIGZ1bmN0aW9uIHRvIGEgaGVhZGVyLCB3aGVy
ZSB3ZSBkbyBub3QKd2FudCB0byBoYXZlIHRvIGluY2x1ZGUgPGxpbnV4L3NjaGVkLmg+IGR1ZSB0
byB0aGUgY29uc2VxdWVudApjaXJjdWxhciAjaW5jbHVkZSBwcm9ibGVtcy4KCk5vIGZ1bmN0aW9u
YWwgY2hhbmdlLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5j
b20+ClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CkFj
a2VkLWJ5OiBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4ubWFyaW5hc0Bhcm0uY29tPgpBY2tlZC1i
eTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KLS0tCiBhcmNoL2FybTY0L2tl
cm5lbC9mcHNpbWQuYyB8IDEwICsrKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rZXJuZWwvZnBz
aW1kLmMgYi9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYwppbmRleCA2YzAxZWUyLi44NDJiMmFk
IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYworKysgYi9hcmNoL2FybTY0
L2tlcm5lbC9mcHNpbWQuYwpAQCAtNDQsNiArNDQsNyBAQAogI2luY2x1ZGUgPGFzbS9mcHNpbWQu
aD4KICNpbmNsdWRlIDxhc20vY3B1ZmVhdHVyZS5oPgogI2luY2x1ZGUgPGFzbS9jcHV0eXBlLmg+
CisjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPgogI2luY2x1ZGUgPGFzbS9zaW1kLmg+CiAjaW5j
bHVkZSA8YXNtL3NpZ2NvbnRleHQuaD4KICNpbmNsdWRlIDxhc20vc3lzcmVnLmg+CkBAIC0xNjcs
MTAgKzE2OCw5IEBAIHN0YXRpYyBzaXplX3Qgc3ZlX2Zmcl9vZmZzZXQoaW50IHZsKQogCXJldHVy
biBTVkVfU0lHX0ZGUl9PRkZTRVQoc3ZlX3ZxX2Zyb21fdmwodmwpKSAtIFNWRV9TSUdfUkVHU19P
RkZTRVQ7CiB9CiAKLXN0YXRpYyB2b2lkICpzdmVfcGZmcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRh
c2spCitzdGF0aWMgdm9pZCAqc3ZlX3BmZnIoc3RydWN0IHRocmVhZF9zdHJ1Y3QgKnRocmVhZCkK
IHsKLQlyZXR1cm4gKGNoYXIgKil0YXNrLT50aHJlYWQuc3ZlX3N0YXRlICsKLQkJc3ZlX2Zmcl9v
ZmZzZXQodGFzay0+dGhyZWFkLnN2ZV92bCk7CisJcmV0dXJuIChjaGFyICopdGhyZWFkLT5zdmVf
c3RhdGUgKyBzdmVfZmZyX29mZnNldCh0aHJlYWQtPnN2ZV92bCk7CiB9CiAKIHN0YXRpYyB2b2lk
IGNoYW5nZV9jcGFjcih1NjQgdmFsLCB1NjQgbWFzaykKQEAgLTI1Myw3ICsyNTMsNyBAQCBzdGF0
aWMgdm9pZCB0YXNrX2Zwc2ltZF9sb2FkKHZvaWQpCiAJV0FSTl9PTighaW5fc29mdGlycSgpICYm
ICFpcnFzX2Rpc2FibGVkKCkpOwogCiAJaWYgKHN5c3RlbV9zdXBwb3J0c19zdmUoKSAmJiB0ZXN0
X3RocmVhZF9mbGFnKFRJRl9TVkUpKQotCQlzdmVfbG9hZF9zdGF0ZShzdmVfcGZmcihjdXJyZW50
KSwKKwkJc3ZlX2xvYWRfc3RhdGUoc3ZlX3BmZnIoJmN1cnJlbnQtPnRocmVhZCksCiAJCQkgICAg
ICAgJmN1cnJlbnQtPnRocmVhZC51dy5mcHNpbWRfc3RhdGUuZnBzciwKIAkJCSAgICAgICBzdmVf
dnFfZnJvbV92bChjdXJyZW50LT50aHJlYWQuc3ZlX3ZsKSAtIDEpOwogCWVsc2UKQEAgLTI4NSw3
ICsyODUsNyBAQCB2b2lkIGZwc2ltZF9zYXZlKHZvaWQpCiAJCQkJcmV0dXJuOwogCQkJfQogCi0J
CQlzdmVfc2F2ZV9zdGF0ZShzdmVfcGZmcihjdXJyZW50KSwgJnN0LT5mcHNyKTsKKwkJCXN2ZV9z
YXZlX3N0YXRlKHN2ZV9wZmZyKCZjdXJyZW50LT50aHJlYWQpLCAmc3QtPmZwc3IpOwogCQl9IGVs
c2UKIAkJCWZwc2ltZF9zYXZlX3N0YXRlKHN0KTsKIAl9Ci0tIAoyLjEuNAoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
