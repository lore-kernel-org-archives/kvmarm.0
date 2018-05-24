From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v11 07/19] arm64: fpsimd: Avoid FPSIMD context leakage for the
 init task
Date: Thu, 24 May 2018 17:56:36 +0100
Message-ID: <1527181008-13549-8-git-send-email-Dave.Martin@arm.com>
References: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B263C49F8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:47:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMh2UAfk6BE4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 12:47:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C3FB4A0D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:47:04 -0400 (EDT)
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

VGhlIGluaXQgdGFzayBpcyBzdGFydGVkIHdpdGggdGhyZWFkX2ZsYWdzIGVxdWFsIHRvIDAsIHdo
aWNoIG1lYW5zCnRoYXQgVElGX0ZPUkVJR05fRlBTVEFURSBpcyBpbml0aWFsbHkgY2xlYXIuCgpJ
dCBpcyB0aGVvcmV0aWNhbGx5IHBvc3NpYmxlIChpZiB1bmxpa2VseSkgdGhhdCB0aGUgaW5pdCB0
YXNrIGNvdWxkCnJlYWNoIHVzZXJzcGFjZSB3aXRob3V0IGV2ZXIgYmVpbmcgc2NoZWR1bGVkIG91
dC4gIElmIHRoaXMgb2NjdXJzLApkYXRhIGxlZnQgaW4gdGhlIEZQU0lNRCByZWdpc3RlcnMgYnkg
dGhlIGtlcm5lbCBjb3VsZCBiZSBleHBvc2VkLgoKVGhpcyBwYXRjaCBmaXhlcyB0aGlzIGFub21h
bHkgYnkgZW5zdXJpbmcgdGhhdCB0aGUgaW5pdCB0YXNrJ3MKaW5pdGlhbCBUSUZfRk9SRUlHTl9G
UFNUQVRFIGlzIHNldC4KClNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBh
cm0uY29tPgpGaXhlczogMDA1Zjc4Y2Q4ODQ5ICgiYXJtNjQ6IGRlZmVyIHJlbG9hZGluZyBhIHRh
c2sncyBGUFNJTUQgc3RhdGUgdG8gdXNlcmxhbmQgcmVzdW1lIikKUmV2aWV3ZWQtYnk6IENhdGFs
aW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+ClJldmlld2VkLWJ5OiBBbGV4IEJl
bm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CkNjOiBXaWxsIERlYWNvbiA8d2lsbC5kZWFj
b25AYXJtLmNvbT4KQ2M6IEFyZCBCaWVzaGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3Jn
PgoKLS0tCgpDaGFuZ2VzIHNpbmNlIHYxMDoKCiAqIE5ldyBwYXRjaC4KLS0tCiBhcmNoL2FybTY0
L2luY2x1ZGUvYXNtL3RocmVhZF9pbmZvLmggfCAxMyArKysrKysrLS0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQvaW5jbHVkZS9hc20vdGhyZWFkX2luZm8uaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20v
dGhyZWFkX2luZm8uaAppbmRleCA3NDBhYTAzYy4uYWYyNzFmOSAxMDA2NDQKLS0tIGEvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oCisrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20vdGhyZWFkX2luZm8uaApAQCAtNDUsMTIgKzQ1LDYgQEAgc3RydWN0IHRocmVhZF9pbmZvIHsK
IAlpbnQJCQlwcmVlbXB0X2NvdW50OwkvKiAwID0+IHByZWVtcHRhYmxlLCA8MCA9PiBidWcgKi8K
IH07CiAKLSNkZWZpbmUgSU5JVF9USFJFQURfSU5GTyh0c2spCQkJCQkJXAotewkJCQkJCQkJCVwK
LQkucHJlZW1wdF9jb3VudAk9IElOSVRfUFJFRU1QVF9DT1VOVCwJCQkJXAotCS5hZGRyX2xpbWl0
CT0gS0VSTkVMX0RTLAkJCQkJXAotfQotCiAjZGVmaW5lIHRocmVhZF9zYXZlZF9wYyh0c2spCVwK
IAkoKHVuc2lnbmVkIGxvbmcpKHRzay0+dGhyZWFkLmNwdV9jb250ZXh0LnBjKSkKICNkZWZpbmUg
dGhyZWFkX3NhdmVkX3NwKHRzaykJXApAQCAtMTE3LDUgKzExMSwxMiBAQCB2b2lkIGFyY2hfcmVs
ZWFzZV90YXNrX3N0cnVjdChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzayk7CiAJCQkJIF9USUZfU1lT
Q0FMTF9UUkFDRVBPSU5UIHwgX1RJRl9TRUNDT01QIHwgXAogCQkJCSBfVElGX05PSFopCiAKKyNk
ZWZpbmUgSU5JVF9USFJFQURfSU5GTyh0c2spCQkJCQkJXAorewkJCQkJCQkJCVwKKwkuZmxhZ3MJ
CT0gX1RJRl9GT1JFSUdOX0ZQU1RBVEUsCQkJCVwKKwkucHJlZW1wdF9jb3VudAk9IElOSVRfUFJF
RU1QVF9DT1VOVCwJCQkJXAorCS5hZGRyX2xpbWl0CT0gS0VSTkVMX0RTLAkJCQkJXAorfQorCiAj
ZW5kaWYgLyogX19LRVJORUxfXyAqLwogI2VuZGlmIC8qIF9fQVNNX1RIUkVBRF9JTkZPX0ggKi8K
LS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
