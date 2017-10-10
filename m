From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3 17/28] arm64/sve: Preserve SVE registers around kernel-mode
 NEON use
Date: Tue, 10 Oct 2017 19:38:34 +0100
Message-ID: <1507660725-7986-18-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C1749D83
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 14:38:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ODSot8cmEMJZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Oct 2017 14:38:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 345EA49DB1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 14:38:51 -0400 (EDT)
In-Reply-To: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

S2VybmVsLW1vZGUgTkVPTiB3aWxsIGNvcnJ1cHQgdGhlIFNWRSB2ZWN0b3IgcmVnaXN0ZXJzLCBk
dWUgdG8gdGhlCndheSB0aGV5IGFsaWFzIHRoZSBGUFNJTUQgdmVjdG9yIHJlZ2lzdGVycyBpbiB0
aGUgaGFyZHdhcmUuCgpUaGlzIHBhdGNoIGVuc3VyZXMgdGhhdCBhbnkgbGl2ZSBTVkUgcmVnaXN0
ZXIgY29udGVudCBmb3IgdGhlIHRhc2sKaXMgc2F2ZWQgYnkga2VybmVsX25lb25fYmVnaW4oKS4g
IFRoZSBkYXRhIHdpbGwgYmUgcmVzdG9yZWQgaW4gdGhlCnVzdWFsIHdheSBvbiByZXR1cm4gdG8g
dXNlcnNwYWNlLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5j
b20+ClJldmlld2VkLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9y
Zz4KUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KLS0t
CiBhcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYyB8IDYgKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwg
NCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
a2VybmVsL2Zwc2ltZC5jIGIvYXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMKaW5kZXggNTY3M2Y1
MC4uYjFkMzgzYSAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMKKysrIGIv
YXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMKQEAgLTkwOSw4ICs5MDksMTAgQEAgdm9pZCBrZXJu
ZWxfbmVvbl9iZWdpbih2b2lkKQogCV9fdGhpc19jcHVfd3JpdGUoa2VybmVsX25lb25fYnVzeSwg
dHJ1ZSk7CiAKIAkvKiBTYXZlIHVuc2F2ZWQgdGFzayBmcHNpbWQgc3RhdGUsIGlmIGFueTogKi8K
LQlpZiAoY3VycmVudC0+bW0gJiYgIXRlc3RfYW5kX3NldF90aHJlYWRfZmxhZyhUSUZfRk9SRUlH
Tl9GUFNUQVRFKSkKLQkJZnBzaW1kX3NhdmVfc3RhdGUoJmN1cnJlbnQtPnRocmVhZC5mcHNpbWRf
c3RhdGUpOworCWlmIChjdXJyZW50LT5tbSkgeworCQl0YXNrX2Zwc2ltZF9zYXZlKCk7CisJCXNl
dF90aHJlYWRfZmxhZyhUSUZfRk9SRUlHTl9GUFNUQVRFKTsKKwl9CiAKIAkvKiBJbnZhbGlkYXRl
IGFueSB0YXNrIHN0YXRlIHJlbWFpbmluZyBpbiB0aGUgZnBzaW1kIHJlZ3M6ICovCiAJX190aGlz
X2NwdV93cml0ZShmcHNpbWRfbGFzdF9zdGF0ZSwgTlVMTCk7Ci0tIAoyLjEuNAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
