From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 12/30] arm64/sve: Low-level CPU setup
Date: Tue, 31 Oct 2017 15:51:04 +0000
Message-ID: <1509465082-30427-13-git-send-email-Dave.Martin@arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

To enable the kernel to use SVE, SVE traps from EL1 to EL2 must be
disabled.  To take maximum advantage of the hardware, the full
available vector length also needs to be enabled for EL1 by
programming ZCR_EL2.LEN.  (The kernel will program ZCR_EL1.LEN as
required, but this cannot override the limit set by ZCR_EL2.)

This patch makes the appropriate changes to the EL2 early setup
code.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alex Bennée <alex.bennee@linaro.org>

---

**Dropped at v3** Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
(Due to significant changes to the logic.)
---
 arch/arm64/kernel/head.S | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index cfa90a4..67e86a0 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -524,8 +524,19 @@ CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
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
