From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3 10/28] arm64/sve: Low-level CPU setup
Date: Tue, 10 Oct 2017 19:38:27 +0100
Message-ID: <1507660725-7986-11-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

To enable the kernel to use SVE, SVE traps from EL1 to EL2 must be
disabled.  To take maximum advantage of the hardware, the full
available vector length also needs to be enabled for EL1 by
programming ZCR_EL2.LEN.  (The kernel will program ZCR_EL1.LEN as
required, but this cannot override the limit set by ZCR_EL2.)

Traps from EL0 to EL1 are also left enabled by virtue of setting
the relevant CPACR bit at its default (RES0) value.

This patch makes the appropriate changes to the primary and
secondary CPU initialisation code.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alex Bennée <alex.bennee@linaro.org>

---

Dropped Alex Bennée's Reviewed-by, since there is a non-trivial change
to the logic here.

Changes since v2
----------------

Requested by Catalin Marinas:

 * Removed the asm logic to enable SVE for EL1 from __cpu_setup, since
   the kernel doesn't need SVE so early.

   Instead, this logic is moved to C code called via cpufeatures in
   "arm64/sve: Probe SVE capabilities and usable vector lengths"
   and wired up for the arm64_cpu_capabilities enable() method in
   "arm64/sve: Detect SVE and activate runtime support".
---
 arch/arm64/kernel/head.S | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 0b243ec..bb6e3f2 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -517,8 +517,19 @@ CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
 	mov	x0, #0x33ff
 	msr	cptr_el2, x0			// Disable copro. traps to EL2
 
+	/* SVE register access */
+	mrs	x1, id_aa64pfr0_el1
+	ubfx	x1, x1, #ID_AA64PFR0_SVE_SHIFT, #4
+	cbz	x1, 7f
+
+	bic	x0, x0, #CPTR_EL2_TZ		// Also disable SVE traps
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+	isb
+	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
+	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
+
 	/* Hypervisor stub */
-	adr_l	x0, __hyp_stub_vectors
+7:	adr_l	x0, __hyp_stub_vectors
 	msr	vbar_el2, x0
 
 	/* spsr */
-- 
2.1.4
