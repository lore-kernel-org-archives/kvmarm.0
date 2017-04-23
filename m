From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 64/79] ARM: decompressor: Remove __hyp_get_vectors usage
Date: Sun, 23 Apr 2017 19:09:14 +0200
Message-ID: <20170423170929.27334-65-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B54EB49D0E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tnDz2zJnlJZh for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:56 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E18B149D4C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:53 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id u65so7508521wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:40 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

When the compressed image needs to be relocated to avoid being
overwritten by the decompression process, we need to relocate
the hyp vectors as well so that we can find them once the
decompression has taken effect.

For that, we perform the following calculation:
	u32 v = __hyp_get_vectors();
	v += offset;
	__hyp_set_vectors(v);

But we're guaranteed that the initial value of v as returned by
__hyp_get_vectors is always __hyp_stub_vectors, because we have
just set it by calling __hyp_stub_install.

So let's remove the use of __hyp_get_vectors, and directly use
__hyp_stub_vectors instead.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/boot/compressed/head.S | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9150f97..7c711ba 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -422,7 +422,17 @@ dtb_check_done:
 		cmp	r0, #HYP_MODE
 		bne	1f
 
-		bl	__hyp_get_vectors
+		/*
+		 * Compute the address of the hyp vectors after relocation.
+		 * This requires some arithmetic since we cannot directly
+		 * reference __hyp_stub_vectors in a PC-relative way.
+		 * Call __hyp_set_vectors with the new address so that we
+		 * can HVC again after the copy.
+		 */
+0:		adr	r0, 0b
+		movw	r1, #:lower16:__hyp_stub_vectors - 0b
+		movt	r1, #:upper16:__hyp_stub_vectors - 0b
+		add	r0, r0, r1
 		sub	r0, r0, r5
 		add	r0, r0, r10
 		bl	__hyp_set_vectors
-- 
2.9.0
