From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 07/15] ARM: head.S: use PC-relative insn sequences for __fixup_pv_table
Date: Sat,  5 Aug 2017 21:52:14 +0100
Message-ID: <20170805205222.19868-8-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, linux@armlinux.org.uk, linux-omap@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, krzk@kernel.org, jason@lakedaemon.net, arm@kernel.org, andrew@lunn.ch, gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com, tony@atomide.com, baohua@kernel.org, horms@verge.net.au, magnus.damm@gmail.com, vireshk@kernel.org, shiraz.linux.kernel@gmail.com, patrice.chotard@st.com, nico@linaro.org, dave.martin@arm.com, marc.zyngier@arm.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Replace the open coded PC relative offset calculations with adr_l
and mov_l invocations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/head.S | 27 ++++++--------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index aed341e0f530..939543e73874 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -578,14 +578,11 @@ ENDPROC(fixup_smp)
  */
 	__HEAD
 __fixup_pv_table:
-	adr	r0, 1f
-	ldmia	r0, {r3-r7}
+	adr_l	r6, __pv_phys_pfn_offset
+	adr_l	r7, __pv_offset			@ __pa(__pv_offset)
+	mov_l	r3, __pv_offset			@ __va(__pv_offset)
 	mvn	ip, #0
-	subs	r3, r0, r3	@ PHYS_OFFSET - PAGE_OFFSET
-	add	r4, r4, r3	@ adjust table start address
-	add	r5, r5, r3	@ adjust table end address
-	add	r6, r6, r3	@ adjust __pv_phys_pfn_offset address
-	add	r7, r7, r3	@ adjust __pv_offset address
+	subs	r3, r7, r3	@ PHYS_OFFSET - PAGE_OFFSET
 	mov	r0, r8, lsr #PAGE_SHIFT	@ convert to PFN
 	str	r0, [r6]	@ save computed PHYS_OFFSET to __pv_phys_pfn_offset
 	strcc	ip, [r7, #HIGH_OFFSET]	@ save to __pv_offset high bits
@@ -594,20 +591,15 @@ __fixup_pv_table:
 THUMB(	it	ne		@ cross section branch )
 	bne	__error
 	str	r3, [r7, #LOW_OFFSET]	@ save to __pv_offset low bits
+	adr_l	r4, __pv_table_begin
+	adr_l	r5, __pv_table_end
 	b	__fixup_a_pv_table
 ENDPROC(__fixup_pv_table)
-
-	.align
-1:	.long	.
-	.long	__pv_table_begin
-	.long	__pv_table_end
-2:	.long	__pv_phys_pfn_offset
-	.long	__pv_offset
+	.ltorg
 
 	.text
 __fixup_a_pv_table:
-	adr	r0, 3f
-	ldr	r6, [r0]
+	mov_l	r6, __pv_offset
 	add	r6, r6, r3
 	ldr	r0, [r6, #HIGH_OFFSET]	@ pv_offset high word
 	ldr	r6, [r6, #LOW_OFFSET]	@ pv_offset low word
@@ -676,9 +668,6 @@ ARM_BE8(rev16	ip, ip)
 #endif
 ENDPROC(__fixup_a_pv_table)
 
-	.align
-3:	.long __pv_offset
-
 ENTRY(fixup_pv_table)
 	stmfd	sp!, {r4 - r7, lr}
 	mov	r3, #0			@ no offset
-- 
2.11.0
