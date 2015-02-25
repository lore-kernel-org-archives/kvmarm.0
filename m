From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 6/6] target-arm/cpu.h: document why env->spsr exists
Date: Wed, 25 Feb 2015 16:02:39 +0000
Message-ID: <1424880159-29348-8-git-send-email-alex.bennee@linaro.org>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B91E34695D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 10:57:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y66QyntwK0bo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Feb 2015 10:57:10 -0500 (EST)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92F6246964
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Feb 2015 10:57:08 -0500 (EST)
In-Reply-To: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

SSB3YXMgZ2V0dGluZyB2ZXJ5IGNvbmZ1c2VkIGFib3V0IHRoZSBkdXBsaWNhdGlvbiBvZiBzdGF0
ZS4gUGVyaGFwcyB3ZQpzaG91bGQganVzdCBnZXQgcmlkIG9mIGVudi0+c3BzciBhbmQgdXNlIGhl
bHBlcnMgdGhhdCB1bmRlcnN0YW5kIHRoZQpiYW5raW5nPwoKU2lnbmVkLW9mZi1ieTogQWxleCBC
ZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgoKZGlmZiAtLWdpdCBhL3RhcmdldC1hcm0v
Y3B1LmggYi90YXJnZXQtYXJtL2NwdS5oCmluZGV4IDExODQ1YTYuLmQ3ZmQxM2YgMTAwNjQ0Ci0t
LSBhL3RhcmdldC1hcm0vY3B1LmgKKysrIGIvdGFyZ2V0LWFybS9jcHUuaApAQCAtMTU1LDYgKzE1
NSwxMSBAQCB0eXBlZGVmIHN0cnVjdCBDUFVBUk1TdGF0ZSB7CiAgICAgICAgVGhpcyBjb250YWlu
cyBhbGwgdGhlIG90aGVyIGJpdHMuICBVc2UgY3Bzcl97cmVhZCx3cml0ZX0gdG8gYWNjZXNzCiAg
ICAgICAgdGhlIHdob2xlIENQU1IuICAqLwogICAgIHVpbnQzMl90IHVuY2FjaGVkX2Nwc3I7Cisg
ICAgLyogVGhlIHNwc3IgaXMgYSBhbGlhcyBmb3Igc3Bzcl9lbE4gd2hlcmUgTiBpcyB0aGUgY3Vy
cmVudAorICAgICAqIGV4Y2VwdGlvbiBsZXZlbC4gSXQgaXMgcHJvdmlkZWQgZm9yIGhlcmUgc28g
dGhlIFRDRyBtc3IvbXJzCisgICAgICogaW1wbGVtZW50YXRpb24gY2FuIGFjY2VzcyBvbmUgcmVn
aXN0ZXIuIENhcmUgbmVlZHMgdG8gYmUgdGFrZW4KKyAgICAgKiB0byBlbnN1cmUgdGhlIGJhbmtl
ZF9zcHNyW10gaXMgYWxzbyB1cGRhdGVkLgorICAgICAqLwogICAgIHVpbnQzMl90IHNwc3I7CiAK
ICAgICAvKiBCYW5rZWQgcmVnaXN0ZXJzLiAgKi8KLS0gCjIuMy4wCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
