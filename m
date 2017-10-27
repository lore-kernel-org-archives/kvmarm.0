From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 23/28] arm64/sve: KVM: Treat guest SVE use as undefined
 instruction execution
Date: Fri, 27 Oct 2017 11:51:05 +0100
Message-ID: <1509101470-7881-24-git-send-email-Dave.Martin@arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E8E849D63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jqQsnqPzamd5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 06:50:41 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF6CD49D5E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:39 -0400 (EDT)
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

V2hlbiB0cmFwcGluZyBmb3JiaWRkZW4gYXR0ZW1wdHMgYnkgYSBndWVzdCB0byB1c2UgU1ZFLCB3
ZSB3YW50IHRoZQpndWVzdCB0byBzZWUgYSB0cmFwIGNvbnNpc3RlbnQgd2l0aCBTVkUgbm90IGJl
aW5nIGltcGxlbWVudGVkLgoKVGhpcyBwYXRjaCBpbmplY3RzIGFuIHVuZGVmaW5lZCBpbnN0cnVj
dGlvbiBleGNlcHRpb24gaW50byB0aGUKZ3Vlc3QgaW4gcmVzcG9uc2UgdG8gc3VjaCBhbiBleGNl
cHRpb24uCgpTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNvbT4K
UmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KQWNrZWQt
Ynk6IENhdGFsaW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+CkFja2VkLWJ5OiBD
aHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGxpbmFyby5vcmc+Ci0tLQogYXJjaC9h
cm02NC9rdm0vaGFuZGxlX2V4aXQuYyB8IDggKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA4IGlu
c2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oYW5kbGVfZXhpdC5jIGIv
YXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQuYwppbmRleCA3ZGViYjc0Li5iNzEyNDc5IDEwMDY0
NAotLS0gYS9hcmNoL2FybTY0L2t2bS9oYW5kbGVfZXhpdC5jCisrKyBiL2FyY2gvYXJtNjQva3Zt
L2hhbmRsZV9leGl0LmMKQEAgLTE0Nyw2ICsxNDcsMTMgQEAgc3RhdGljIGludCBrdm1faGFuZGxl
X3Vua25vd25fZWMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3J1biAqcnVuKQog
CXJldHVybiAxOwogfQogCitzdGF0aWMgaW50IGhhbmRsZV9zdmUoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBzdHJ1Y3Qga3ZtX3J1biAqcnVuKQoreworCS8qIFVudGlsIFNWRSBpcyBzdXBwb3J0ZWQg
Zm9yIGd1ZXN0czogKi8KKwlrdm1faW5qZWN0X3VuZGVmaW5lZCh2Y3B1KTsKKwlyZXR1cm4gMTsK
K30KKwogc3RhdGljIGV4aXRfaGFuZGxlX2ZuIGFybV9leGl0X2hhbmRsZXJzW10gPSB7CiAJWzAg
Li4uIEVTUl9FTHhfRUNfTUFYXQk9IGt2bV9oYW5kbGVfdW5rbm93bl9lYywKIAlbRVNSX0VMeF9F
Q19XRnhdCT0ga3ZtX2hhbmRsZV93ZngsCkBAIC0xNjAsNiArMTY3LDcgQEAgc3RhdGljIGV4aXRf
aGFuZGxlX2ZuIGFybV9leGl0X2hhbmRsZXJzW10gPSB7CiAJW0VTUl9FTHhfRUNfSFZDNjRdCT0g
aGFuZGxlX2h2YywKIAlbRVNSX0VMeF9FQ19TTUM2NF0JPSBoYW5kbGVfc21jLAogCVtFU1JfRUx4
X0VDX1NZUzY0XQk9IGt2bV9oYW5kbGVfc3lzX3JlZywKKwlbRVNSX0VMeF9FQ19TVkVdCT0gaGFu
ZGxlX3N2ZSwKIAlbRVNSX0VMeF9FQ19JQUJUX0xPV10JPSBrdm1faGFuZGxlX2d1ZXN0X2Fib3J0
LAogCVtFU1JfRUx4X0VDX0RBQlRfTE9XXQk9IGt2bV9oYW5kbGVfZ3Vlc3RfYWJvcnQsCiAJW0VT
Ul9FTHhfRUNfU09GVFNUUF9MT1ddPSBrdm1faGFuZGxlX2d1ZXN0X2RlYnVnLAotLSAKMi4xLjQK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
