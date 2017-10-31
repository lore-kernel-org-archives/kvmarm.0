From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v5 30/30] arm64/sve: signal: Include SVE when computing
 AT_MINSIGSTKSZ
Date: Tue, 31 Oct 2017 15:51:22 +0000
Message-ID: <1509465082-30427-31-git-send-email-Dave.Martin@arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E716549D50
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 11:50:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gQcySOoiXoue for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 11:50:59 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A4249D94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 11:50:54 -0400 (EDT)
In-Reply-To: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VGhlIFNWRSBjb250ZXh0IGJsb2NrIGluIHRoZSBzaWduYWwgZnJhbWUgbmVlZHMgdG8gYmUgY29u
c2lkZXJlZAp0b28gd2hlbiBjb21wdXRpbmcgdGhlIG1heGltdW0gcG9zc2libGUgc2lnbmFsIGZy
YW1lIHNpemUuCgpCZWNhdXNlIHRoZSBzaXplIG9mIHRoaXMgYmxvY2sgZGVwZW5kcyBvbiB0aGUg
dmVjdG9yIGxlbmd0aCwgdGhpcwpwYXRjaCBjb21wdXRlcyB0aGUgc2l6ZSBiYXNlZCBub3Qgb24g
dGhlIHRocmVhZCdzIGN1cnJlbnQgdmVjdG9yCmxlbmd0aCBidXQgaW5zdGVhZCBvbiB0aGUgbWF4
aW11bSBwb3NzaWJsZSB2ZWN0b3IgbGVuZ3RoOiB0aGlzCmRldGVybWluZXMgdGhlIG1heGltdW0g
c2l6ZSBvZiBTVkUgY29udGV4dCBibG9jayB0aGF0IGNhbiBiZQpvYnNlcnZlZCBpbiBhbnkgc2ln
bmFsIGZyYW1lIGZvciB0aGUgbGlmZXRpbWUgb2YgdGhlIHByb2Nlc3MuCgpTaWduZWQtb2ZmLWJ5
OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNvbT4KQ2M6IEFyZCBCaWVzaGV1dmVsIDxh
cmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPgpDYzogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBs
aW5hcm8ub3JnPgotLS0KIGFyY2gvYXJtNjQva2VybmVsL3NpZ25hbC5jIHwgMTQgKysrKysrKysr
KysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva2VybmVsL3NpZ25hbC5jIGIvYXJjaC9hcm02NC9rZXJu
ZWwvc2lnbmFsLmMKaW5kZXggN2M3ZDlhZS4uOWI4YWE5MiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02
NC9rZXJuZWwvc2lnbmFsLmMKKysrIGIvYXJjaC9hcm02NC9rZXJuZWwvc2lnbmFsLmMKQEAgLTU5
OSw4ICs1OTksMTggQEAgc3RhdGljIGludCBzZXR1cF9zaWdmcmFtZV9sYXlvdXQoc3RydWN0IHJ0
X3NpZ2ZyYW1lX3VzZXJfbGF5b3V0ICp1c2VyLAogCWlmIChzeXN0ZW1fc3VwcG9ydHNfc3ZlKCkp
IHsKIAkJdW5zaWduZWQgaW50IHZxID0gMDsKIAotCQlpZiAodGVzdF90aHJlYWRfZmxhZyhUSUZf
U1ZFKSkKLQkJCXZxID0gc3ZlX3ZxX2Zyb21fdmwoY3VycmVudC0+dGhyZWFkLnN2ZV92bCk7CisJ
CWlmIChhZGRfYWxsIHx8IHRlc3RfdGhyZWFkX2ZsYWcoVElGX1NWRSkpIHsKKwkJCWludCB2bCA9
IHN2ZV9tYXhfdmw7CisKKwkJCWlmICghYWRkX2FsbCkKKwkJCQl2bCA9IGN1cnJlbnQtPnRocmVh
ZC5zdmVfdmw7CisKKwkJCS8qIEZhaWwgc2FmZSBpZiBzb21ldGhpbmcgd2Fzbid0IGluaXRpYWxp
c2VkICovCisJCQlpZiAoV0FSTl9PTighc3ZlX3ZsX3ZhbGlkKHZsKSkpCisJCQkJdmwgPSBTVkVf
VkxfTUlOOworCisJCQl2cSA9IHN2ZV92cV9mcm9tX3ZsKHZsKTsKKwkJfQogCiAJCWVyciA9IHNp
Z2ZyYW1lX2FsbG9jKHVzZXIsICZ1c2VyLT5zdmVfb2Zmc2V0LAogCQkJCSAgICAgU1ZFX1NJR19D
T05URVhUX1NJWkUodnEpKTsKLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
