From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3 08/28] arm64/sve: Kconfig update and conditional
 compilation support
Date: Tue, 10 Oct 2017 19:38:25 +0100
Message-ID: <1507660725-7986-9-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 696D749D5E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 14:38:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V7KIJ4Osde8P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Oct 2017 14:38:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AC5749D8A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 14:38:32 -0400 (EDT)
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

VGhpcyBwYXRjaCBhZGRzIENPTkZJR19BUk02NF9TVkUgdG8gY29udHJvbCBidWlsZGluZyBvZiBT
VkUgc3VwcG9ydAppbnRvIHRoZSBrZXJuZWwsIGFuZCBhZGRzIGEgc3R1YiBwcmVkaWNhdGUgc3lz
dGVtX3N1cHBvcnRzX3N2ZSgpIHRvCmNvbnRyb2wgY29uZGl0aW9uYWwgY29tcGlsYXRpb24gYW5k
IHJ1bnRpbWUgU1ZFIHN1cHBvcnQuCgpzeXN0ZW1fc3VwcG9ydHNfc3ZlKCkganVzdCByZXR1cm5z
IGZhbHNlIGZvciBub3c6IGl0IHdpbGwgYmUKcmVwbGFjZWQgd2l0aCBhIG5vbi10cml2aWFsIGlt
cGxlbWVudGF0aW9uIGluIGEgbGF0ZXIgcGF0Y2gsIG9uY2UKU1ZFIHN1cHBvcnQgaXMgY29tcGxl
dGUgZW5vdWdoIHRvIGJlIGVuYWJsZWQgc2FmZWx5LgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0
aW4gPERhdmUuTWFydGluQGFybS5jb20+ClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXgu
YmVubmVlQGxpbmFyby5vcmc+Ci0tLQogYXJjaC9hcm02NC9LY29uZmlnICAgICAgICAgICAgICAg
ICAgfCAxMSArKysrKysrKysrKwogYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlLmgg
fCAgNSArKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9LY29uZmlnIGIvYXJjaC9hcm02NC9LY29uZmlnCmluZGV4IGNhNzExYWMu
LjliM2E1MGUgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQvS2NvbmZpZworKysgYi9hcmNoL2FybTY0
L0tjb25maWcKQEAgLTk3NSw2ICs5NzUsMTcgQEAgY29uZmlnIEFSTTY0X1BNRU0KIAogZW5kbWVu
dQogCitjb25maWcgQVJNNjRfU1ZFCisJYm9vbCAiQVJNIFNjYWxhYmxlIFZlY3RvciBFeHRlbnNp
b24gc3VwcG9ydCIKKwlkZWZhdWx0IHkKKwloZWxwCisJICBUaGUgU2NhbGFibGUgVmVjdG9yIEV4
dGVuc2lvbiAoU1ZFKSBpcyBhbiBleHRlbnNpb24gdG8gdGhlIEFBcmNoNjQKKwkgIGV4ZWN1dGlv
biBzdGF0ZSB3aGljaCBjb21wbGVtZW50cyBhbmQgZXh0ZW5kcyB0aGUgU0lNRCBmdW5jdGlvbmFs
aXR5CisJICBvZiB0aGUgYmFzZSBhcmNoaXRlY3R1cmUgdG8gc3VwcG9ydCBtdWNoIGxhcmdlciB2
ZWN0b3JzIGFuZCB0byBlbmFibGUKKwkgIGFkZGl0aW9uYWwgdmVjdG9yaXNhdGlvbiBvcHBvcnR1
bml0aWVzLgorCisJICBUbyBlbmFibGUgdXNlIG9mIHRoaXMgZXh0ZW5zaW9uIG9uIENQVXMgdGhh
dCBpbXBsZW1lbnQgaXQsIHNheSBZLgorCiBjb25maWcgQVJNNjRfTU9EVUxFX0NNT0RFTF9MQVJH
RQogCWJvb2wKIApkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jcHVmZWF0dXJl
LmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaAppbmRleCA0MjhlZTFmLi40
ZWEzNDQxIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaAor
KysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaApAQCAtMjYyLDYgKzI2Miwx
MSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgc3lzdGVtX3VzZXNfdHRicjBfcGFuKHZvaWQpCiAJCSFj
cHVzX2hhdmVfY29uc3RfY2FwKEFSTTY0X0hBU19QQU4pOwogfQogCitzdGF0aWMgaW5saW5lIGJv
b2wgc3lzdGVtX3N1cHBvcnRzX3N2ZSh2b2lkKQoreworCXJldHVybiBmYWxzZTsKK30KKwogI2Vu
ZGlmIC8qIF9fQVNTRU1CTFlfXyAqLwogCiAjZW5kaWYKLS0gCjIuMS40CgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
