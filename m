From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 05/26] KVM: arm64: Add missing #include of <linux/bitmap.h>
 to kvm_host.h
Date: Mon, 18 Feb 2019 19:52:18 +0000
Message-ID: <1550519559-15915-6-git-send-email-Dave.Martin@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C08AB4A418
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 14:54:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lF8+ZfRfwyPC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 14:54:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C33A4A41B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 14:54:19 -0500 (EST)
In-Reply-To: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

a3ZtX2hvc3QuaCB1c2VzIERFQ0xBUkVfQklUTUFQKCkgdG8gZGVjbGFyZSB0aGUgZmVhdHVyZXMg
bWVtYmVyIG9mCnN0cnVjdCB2Y3B1X2FyY2gsIGJ1dCB0aGUgY29ycmVzcG9uZGluZyAjaW5jbHVk
ZSBmb3IgdGhpcyBpcwptaXNzaW5nLgoKVGhpcyBwYXRjaCBhZGRzIGEgc3VpdGFibGUgI2luY2x1
ZGUgZm9yIDxsaW51eC9iaXRtYXAuaD4uICBBbHRob3VnaAp0aGUgaGVhZGVyIGJ1aWxkcyB3aXRo
b3V0IGl0IHRvZGF5LCB0aGlzIHNob3VsZCBoZWxwIHRvIGF2b2lkCmZ1dHVyZSBzdXJwcmlzZXMu
CgpTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNvbT4KUmV2aWV3
ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KLS0tCiBhcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBi
L2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAppbmRleCA3NzMyZDBiLi44NDA1NmE0
IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKKysrIGIvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCkBAIC0yMiw2ICsyMiw3IEBACiAjaWZuZGVm
IF9fQVJNNjRfS1ZNX0hPU1RfSF9fCiAjZGVmaW5lIF9fQVJNNjRfS1ZNX0hPU1RfSF9fCiAKKyNp
bmNsdWRlIDxsaW51eC9iaXRtYXAuaD4KICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgogI2luY2x1
ZGUgPGxpbnV4L2t2bV90eXBlcy5oPgogI2luY2x1ZGUgPGFzbS9jcHVmZWF0dXJlLmg+Ci0tIAoy
LjEuNAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
