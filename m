From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 22/25] ARM: decompressor: Remove __hyp_get_vectors usage
Date: Mon,  6 Mar 2017 14:24:55 +0000
Message-ID: <20170306142458.8875-23-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BC3A40A6A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vKxl6BgCR6pH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:25:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ACB640BE4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:33 -0500 (EST)
In-Reply-To: <20170306142458.8875-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

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

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/boot/compressed/head.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9150f9732785..d58bb104c6e8 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -422,7 +422,10 @@ dtb_check_done:
 		cmp	r0, #HYP_MODE
 		bne	1f
 
-		bl	__hyp_get_vectors
+0:		adr	r0, 0b
+		movw	r1, #:lower16:__hyp_stub_vectors - 0b
+		movt	r1, #:upper16:__hyp_stub_vectors - 0b
+		add	r0, r0, r1
 		sub	r0, r0, r5
 		add	r0, r0, r10
 		bl	__hyp_set_vectors
-- 
2.11.0
