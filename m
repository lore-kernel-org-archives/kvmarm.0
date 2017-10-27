From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 17/28] arm64/sve: Preserve SVE registers around kernel-mode
 NEON use
Date: Fri, 27 Oct 2017 11:50:59 +0100
Message-ID: <1509101470-7881-18-git-send-email-Dave.Martin@arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E77949D5C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XosfFWM75-yI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 06:50:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 221FB49D4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:28 -0400 (EDT)
In-Reply-To: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
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

S2VybmVsLW1vZGUgTkVPTiB3aWxsIGNvcnJ1cHQgdGhlIFNWRSB2ZWN0b3IgcmVnaXN0ZXJzLCBk
dWUgdG8gdGhlCndheSB0aGV5IGFsaWFzIHRoZSBGUFNJTUQgdmVjdG9yIHJlZ2lzdGVycyBpbiB0
aGUgaGFyZHdhcmUuCgpUaGlzIHBhdGNoIGVuc3VyZXMgdGhhdCBhbnkgbGl2ZSBTVkUgcmVnaXN0
ZXIgY29udGVudCBmb3IgdGhlIHRhc2sKaXMgc2F2ZWQgYnkga2VybmVsX25lb25fYmVnaW4oKS4g
IFRoZSBkYXRhIHdpbGwgYmUgcmVzdG9yZWQgaW4gdGhlCnVzdWFsIHdheSBvbiByZXR1cm4gdG8g
dXNlcnNwYWNlLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5j
b20+ClJldmlld2VkLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9y
Zz4KUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KUmV2
aWV3ZWQtYnk6IENhdGFsaW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+Ci0tLQog
YXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMgfCA2ICsrKystLQogMSBmaWxlIGNoYW5nZWQsIDQg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tl
cm5lbC9mcHNpbWQuYyBiL2FyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jCmluZGV4IDcwM2U5ZDcu
LmQ1MTA4ZTggMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jCisrKyBiL2Fy
Y2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jCkBAIC04ODQsOCArODg0LDEwIEBAIHZvaWQga2VybmVs
X25lb25fYmVnaW4odm9pZCkKIAlfX3RoaXNfY3B1X3dyaXRlKGtlcm5lbF9uZW9uX2J1c3ksIHRy
dWUpOwogCiAJLyogU2F2ZSB1bnNhdmVkIHRhc2sgZnBzaW1kIHN0YXRlLCBpZiBhbnk6ICovCi0J
aWYgKGN1cnJlbnQtPm1tICYmICF0ZXN0X2FuZF9zZXRfdGhyZWFkX2ZsYWcoVElGX0ZPUkVJR05f
RlBTVEFURSkpCi0JCWZwc2ltZF9zYXZlX3N0YXRlKCZjdXJyZW50LT50aHJlYWQuZnBzaW1kX3N0
YXRlKTsKKwlpZiAoY3VycmVudC0+bW0pIHsKKwkJdGFza19mcHNpbWRfc2F2ZSgpOworCQlzZXRf
dGhyZWFkX2ZsYWcoVElGX0ZPUkVJR05fRlBTVEFURSk7CisJfQogCiAJLyogSW52YWxpZGF0ZSBh
bnkgdGFzayBzdGF0ZSByZW1haW5pbmcgaW4gdGhlIGZwc2ltZCByZWdzOiAqLwogCV9fdGhpc19j
cHVfd3JpdGUoZnBzaW1kX2xhc3Rfc3RhdGUsIE5VTEwpOwotLSAKMi4xLjQKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
