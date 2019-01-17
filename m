From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 09/25] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Thu, 17 Jan 2019 20:33:23 +0000
Message-ID: <1547757219-19439-10-git-send-email-Dave.Martin@arm.com>
References: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C3FD4A3BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:34:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HbF9dp4sddUK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jan 2019 15:34:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0450C4A3CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:34:49 -0500 (EST)
In-Reply-To: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
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

U2luY2UgU1ZFIHdpbGwgYmUgZW5hYmxlZCBvciBkaXNhYmxlZCBvbiBhIHBlci12Y3B1IGJhc2lz
LCBhIGZsYWcKaXMgbmVlZGVkIGluIG9yZGVyIHRvIHRyYWNrIHdoaWNoIHZjcHVzIGhhdmUgaXQg
ZW5hYmxlZC4KClRoaXMgcGF0Y2ggYWRkcyBhIHN1aXRhYmxlIGZsYWcgYW5kIGEgaGVscGVyIGZv
ciBjaGVja2luZyBpdC4KClNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBh
cm0uY29tPgpSZXZpZXdlZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3Jn
PgotLS0KIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8IDQgKysrKwogMSBmaWxl
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAppbmRl
eCA4NDA1NmE0Li5hZjYyNWE4IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmgKKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCkBAIC0zMDks
NiArMzA5LDEwIEBAIHN0cnVjdCBrdm1fdmNwdV9hcmNoIHsKICNkZWZpbmUgS1ZNX0FSTTY0X0ZQ
X0hPU1QJCSgxIDw8IDIpIC8qIGhvc3QgRlAgcmVncyBsb2FkZWQgKi8KICNkZWZpbmUgS1ZNX0FS
TTY0X0hPU1RfU1ZFX0lOX1VTRQkoMSA8PCAzKSAvKiBiYWNrdXAgZm9yIGhvc3QgVElGX1NWRSAq
LwogI2RlZmluZSBLVk1fQVJNNjRfSE9TVF9TVkVfRU5BQkxFRAkoMSA8PCA0KSAvKiBTVkUgZW5h
YmxlZCBmb3IgRUwwICovCisjZGVmaW5lIEtWTV9BUk02NF9HVUVTVF9IQVNfU1ZFCQkoMSA8PCA1
KSAvKiBTVkUgZXhwb3NlZCB0byBndWVzdCAqLworCisjZGVmaW5lIHZjcHVfaGFzX3N2ZSh2Y3B1
KSAoc3lzdGVtX3N1cHBvcnRzX3N2ZSgpICYmIFwKKwkJCSAgICAoKHZjcHUpLT5hcmNoLmZsYWdz
ICYgS1ZNX0FSTTY0X0dVRVNUX0hBU19TVkUpKQogCiAjZGVmaW5lIHZjcHVfZ3BfcmVncyh2KQkJ
KCYodiktPmFyY2guY3R4dC5ncF9yZWdzKQogCi0tIAoyLjEuNAoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
