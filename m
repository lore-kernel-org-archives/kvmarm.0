From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 29/34] ARM: decompressor: Remove __hyp_get_vectors usage
Date: Mon,  3 Apr 2017 19:38:02 +0100
Message-ID: <20170403183807.1620-30-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
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

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/boot/compressed/head.S | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 9150f9732785..7c711ba61417 100644
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
2.11.0
