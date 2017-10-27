From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 04/28] arm64: Port deprecated instruction emulation to new
 sysctl interface
Date: Fri, 27 Oct 2017 11:50:46 +0100
Message-ID: <1509101470-7881-5-git-send-email-Dave.Martin@arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22EDA49D20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ogf97auvXO06 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 06:50:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E505549D5A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:02 -0400 (EDT)
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

Q3VycmVudGx5LCBhcm12OF9kZXByZWN0ZWQuYyB0YWtlcyBjaGFyZ2Ugb2YgdGhlICJhYmkiIHN5
c2N0bApkaXJlY3RvcnksIHdoaWNoIG1ha2VzIGxpZmUgZGlmZmljdWx0IGZvciBvdGhlciBjb2Rl
IHRoYXQgd2FudHMgdG8KcmVnaXN0ZXIgc3lzY3RscyBpbiB0aGUgc2FtZSBkaXJlY3RvcnkuCgpU
aGVyZSBpcyBhICJuZXciIFsxXSBzeXNjdGwgcmVnaXN0cmF0aW9uIGludGVyZmFjZSB0aGF0IHJl
bW92ZXMgdGhlCm5lZWQgdG8gZGVmaW5lIGN0bF90YWJsZXMgZm9yIHBhcmVudCBkaXJlY3Rvcmll
cyBleHBsaWNpdGx5LCB3aGljaAppcyBpZGVhbCBoZXJlLgoKVGhpcyBwYXRjaCBwb3J0cyByZWdp
c3Rlcl9pbnNuX2VtdWxhdGlvbl9zeXNjdGwoKSBvdmVyIHRvIHRoZQpyZWdpc3Rlcl9zeXNjdGwo
KSBpbnRlcmZhY2UgYW5kIHJlbW92ZXMgdGhlIHJlZHVuZGFudCBjdGxfdGFibGUgZm9yCiJhYmki
LgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJldmll
d2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+ClJldmlld2VkLWJ5
OiBDYXRhbGluIE1hcmluYXMgPGNhdGFsaW4ubWFyaW5hc0Bhcm0uY29tPgoKWzFdIGZlYTQ3OGQ0
MTAxYSAoc3lzY3RsOiBBZGQgcmVnaXN0ZXJfc3lzY3RsIGZvciBub3JtYWwgc3lzY3RsCnVzZXJz
KQpUaGUgY29tbWl0IG1lc3NhZ2Ugbm90ZXMgYW4gaW50ZW50IHRvIHBvcnQgdXNlcnMgb2YgdGhl
CnByZS1leGlzdGluZyBpbnRlcmZhY2VzIG92ZXIgdG8gcmVnaXN0ZXJfc3lzY3RsKCksIHRob3Vn
aCB0aGUKbnVtYmVyIG9mIHVzZXJzIG9mIHRoZSBuZXcgaW50ZXJmYWNlIGN1cnJlbnRseSBhcHBl
YXJzIG5lZ2xpZ2libGUuCi0tLQogYXJjaC9hcm02NC9rZXJuZWwvYXJtdjhfZGVwcmVjYXRlZC5j
IHwgMTUgKysrLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAx
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tlcm5lbC9hcm12OF9kZXBy
ZWNhdGVkLmMgYi9hcmNoL2FybTY0L2tlcm5lbC9hcm12OF9kZXByZWNhdGVkLmMKaW5kZXggYTRk
YzExNS4uYzMzYjVlNCAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvYXJtdjhfZGVwcmVj
YXRlZC5jCisrKyBiL2FyY2gvYXJtNjQva2VybmVsL2FybXY4X2RlcHJlY2F0ZWQuYwpAQCAtMjI4
LDE1ICsyMjgsNyBAQCBzdGF0aWMgaW50IGVtdWxhdGlvbl9wcm9jX2hhbmRsZXIoc3RydWN0IGN0
bF90YWJsZSAqdGFibGUsIGludCB3cml0ZSwKIAlyZXR1cm4gcmV0OwogfQogCi1zdGF0aWMgc3Ry
dWN0IGN0bF90YWJsZSBjdGxfYWJpW10gPSB7Ci0JewotCQkucHJvY25hbWUgPSAiYWJpIiwKLQkJ
Lm1vZGUgPSAwNTU1LAotCX0sCi0JeyB9Ci19OwotCi1zdGF0aWMgdm9pZCBfX2luaXQgcmVnaXN0
ZXJfaW5zbl9lbXVsYXRpb25fc3lzY3RsKHN0cnVjdCBjdGxfdGFibGUgKnRhYmxlKQorc3RhdGlj
IHZvaWQgX19pbml0IHJlZ2lzdGVyX2luc25fZW11bGF0aW9uX3N5c2N0bCh2b2lkKQogewogCXVu
c2lnbmVkIGxvbmcgZmxhZ3M7CiAJaW50IGkgPSAwOwpAQCAtMjYyLDggKzI1NCw3IEBAIHN0YXRp
YyB2b2lkIF9faW5pdCByZWdpc3Rlcl9pbnNuX2VtdWxhdGlvbl9zeXNjdGwoc3RydWN0IGN0bF90
YWJsZSAqdGFibGUpCiAJfQogCXJhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnNuX2VtdWxh
dGlvbl9sb2NrLCBmbGFncyk7CiAKLQl0YWJsZS0+Y2hpbGQgPSBpbnNuc19zeXNjdGw7Ci0JcmVn
aXN0ZXJfc3lzY3RsX3RhYmxlKHRhYmxlKTsKKwlyZWdpc3Rlcl9zeXNjdGwoImFiaSIsIGluc25z
X3N5c2N0bCk7CiB9CiAKIC8qCkBAIC02NDQsNyArNjM1LDcgQEAgc3RhdGljIGludCBfX2luaXQg
YXJtdjhfZGVwcmVjYXRlZF9pbml0KHZvaWQpCiAJY3B1aHBfc2V0dXBfc3RhdGVfbm9jYWxscyhD
UFVIUF9BUF9BUk02NF9JU05ERVBfU1RBUlRJTkcsCiAJCQkJICAiYXJtNjQvaXNuZGVwOnN0YXJ0
aW5nIiwKIAkJCQkgIHJ1bl9hbGxfaW5zbl9zZXRfaHdfbW9kZSwgTlVMTCk7Ci0JcmVnaXN0ZXJf
aW5zbl9lbXVsYXRpb25fc3lzY3RsKGN0bF9hYmkpOworCXJlZ2lzdGVyX2luc25fZW11bGF0aW9u
X3N5c2N0bCgpOwogCiAJcmV0dXJuIDA7CiB9Ci0tIAoyLjEuNAoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
