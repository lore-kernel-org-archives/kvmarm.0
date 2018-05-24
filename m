From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v11 03/19] arm64: Use update{,_tsk}_thread_flag()
Date: Thu, 24 May 2018 17:56:32 +0100
Message-ID: <1527181008-13549-4-git-send-email-Dave.Martin@arm.com>
References: <1527181008-13549-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 222DC4A10C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:47:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dr0lV5RXCXUc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 12:47:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F00CC4A0EA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 12:46:57 -0400 (EDT)
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

VGhpcyBwYXRjaCB1c2VzIHRoZSBuZXcgdXBkYXRlX3RocmVhZF9mbGFnKCkgaGVscGVycyB0byBz
aW1wbGlmeSBhCmNvdXBsZSBvZiBpZiAoKSBzZXQ7IGVsc2UgY2xlYXI7IGNvbnN0cnVjdHMuCgpO
byBmdW5jdGlvbmFsIGNoYW5nZS4KClNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1h
cnRpbkBhcm0uY29tPgpSZXZpZXdlZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5h
cm8ub3JnPgpBY2tlZC1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KQWNr
ZWQtYnk6IENhdGFsaW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+CkNjOiBXaWxs
IERlYWNvbiA8d2lsbC5kZWFjb25AYXJtLmNvbT4KLS0tCiBhcmNoL2FybTY0L2tlcm5lbC9mcHNp
bWQuYyB8IDE4ICsrKysrKysrLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rZXJuZWwvZnBz
aW1kLmMgYi9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYwppbmRleCAxMmUxYzk2Li45ZDg1Mzcz
IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYworKysgYi9hcmNoL2FybTY0
L2tlcm5lbC9mcHNpbWQuYwpAQCAtNjE4LDEwICs2MTgsOCBAQCBpbnQgc3ZlX3NldF92ZWN0b3Jf
bGVuZ3RoKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywKIAl0YXNrLT50aHJlYWQuc3ZlX3ZsID0g
dmw7CiAKIG91dDoKLQlpZiAoZmxhZ3MgJiBQUl9TVkVfVkxfSU5IRVJJVCkKLQkJc2V0X3Rza190
aHJlYWRfZmxhZyh0YXNrLCBUSUZfU1ZFX1ZMX0lOSEVSSVQpOwotCWVsc2UKLQkJY2xlYXJfdHNr
X3RocmVhZF9mbGFnKHRhc2ssIFRJRl9TVkVfVkxfSU5IRVJJVCk7CisJdXBkYXRlX3Rza190aHJl
YWRfZmxhZyh0YXNrLCBUSUZfU1ZFX1ZMX0lOSEVSSVQsCisJCQkgICAgICAgZmxhZ3MgJiBQUl9T
VkVfVkxfSU5IRVJJVCk7CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTkxMCwxMiArOTA4LDEyIEBAIHZv
aWQgZnBzaW1kX3RocmVhZF9zd2l0Y2goc3RydWN0IHRhc2tfc3RydWN0ICpuZXh0KQogCQkgKiB0
aGUgVElGX0ZPUkVJR05fRlBTVEFURSBmbGFnIHNvIHRoZSBzdGF0ZSB3aWxsIGJlIGxvYWRlZAog
CQkgKiB1cG9uIHRoZSBuZXh0IHJldHVybiB0byB1c2VybGFuZC4KIAkJICovCi0JCWlmIChfX3Ro
aXNfY3B1X3JlYWQoZnBzaW1kX2xhc3Rfc3RhdGUuc3QpID09Ci0JCQkmbmV4dC0+dGhyZWFkLnV3
LmZwc2ltZF9zdGF0ZQotCQkgICAgJiYgbmV4dC0+dGhyZWFkLmZwc2ltZF9jcHUgPT0gc21wX3By
b2Nlc3Nvcl9pZCgpKQotCQkJY2xlYXJfdHNrX3RocmVhZF9mbGFnKG5leHQsIFRJRl9GT1JFSUdO
X0ZQU1RBVEUpOwotCQllbHNlCi0JCQlzZXRfdHNrX3RocmVhZF9mbGFnKG5leHQsIFRJRl9GT1JF
SUdOX0ZQU1RBVEUpOworCQlib29sIHdyb25nX3Rhc2sgPSBfX3RoaXNfY3B1X3JlYWQoZnBzaW1k
X2xhc3Rfc3RhdGUuc3QpICE9CisJCQkJCSZuZXh0LT50aHJlYWQudXcuZnBzaW1kX3N0YXRlOwor
CQlib29sIHdyb25nX2NwdSA9IG5leHQtPnRocmVhZC5mcHNpbWRfY3B1ICE9IHNtcF9wcm9jZXNz
b3JfaWQoKTsKKworCQl1cGRhdGVfdHNrX3RocmVhZF9mbGFnKG5leHQsIFRJRl9GT1JFSUdOX0ZQ
U1RBVEUsCisJCQkJICAgICAgIHdyb25nX3Rhc2sgfHwgd3JvbmdfY3B1KTsKIAl9CiB9CiAKLS0g
CjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
