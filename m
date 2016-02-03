From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 22/23] arm64: VHE: Add support for running Linux in EL2 mode
Date: Wed,  3 Feb 2016 18:00:15 +0000
Message-ID: <1454522416-6874-23-git-send-email-marc.zyngier@arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

With ARMv8.1 VHE, the architecture is able to (almost) transparently
run the kernel at EL2, despite being written for EL1.

This patch takes care of the "almost" part, mostly preventing the kernel
from dropping from EL2 to EL1, and setting up the HYP configuration.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/Kconfig       | 13 +++++++++++++
 arch/arm64/kernel/head.S | 28 +++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8cc6228..cf118d9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -750,6 +750,19 @@ config ARM64_LSE_ATOMICS
 	  not support these instructions and requires the kernel to be
 	  built with binutils >= 2.25.
 
+config ARM64_VHE
+	bool "Enable support for Virtualization Host Extensions (VHE)"
+	default y
+	help
+	  Virtualization Host Extensions (VHE) allow the kernel to run
+	  directly at EL2 (instead of EL1) on processors that support
+	  it. This leads to better performance for KVM, as they reduce
+	  the cost of the world switch.
+
+	  Selecting this option allows the VHE feature to be detected
+	  at runtime, and does not affect processors that do not
+	  implement this feature.
+
 endmenu
 
 endmenu
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 917d981..6f2f377 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -30,6 +30,7 @@
 #include <asm/cache.h>
 #include <asm/cputype.h>
 #include <asm/kernel-pgtable.h>
+#include <asm/kvm_arm.h>
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/pgtable.h>
@@ -464,9 +465,27 @@ CPU_LE(	bic	x0, x0, #(3 << 24)	)	// Clear the EE and E0E bits for EL1
 	isb
 	ret
 
+2:
+#ifdef CONFIG_ARM64_VHE
+	/*
+	 * Check for VHE being present. For the rest of the EL2 setup,
+	 * x2 being non-zero indicates that we do have VHE, and that the
+	 * kernel is intended to run at EL2.
+	 */
+	mrs	x2, id_aa64mmfr1_el1
+	ubfx	x2, x2, #8, #4
+#else
+	mov	x2, xzr
+#endif
+
 	/* Hyp configuration. */
-2:	mov	x0, #(1 << 31)			// 64-bit EL1
+	mov	x0, #HCR_RW			// 64-bit EL1
+	cbz	x2, set_hcr
+	orr	x0, x0, #HCR_TGE		// Enable Host Extensions
+	orr	x0, x0, #HCR_E2H
+set_hcr:
 	msr	hcr_el2, x0
+	isb
 
 	/* Generic timers. */
 	mrs	x0, cnthctl_el2
@@ -526,6 +545,13 @@ CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
 	/* Stage-2 translation */
 	msr	vttbr_el2, xzr
 
+	cbz	x2, install_el2_stub
+
+	mov	w20, #BOOT_CPU_MODE_EL2		// This CPU booted in EL2
+	isb
+	ret
+
+install_el2_stub:
 	/* Hypervisor stub */
 	adrp	x0, __hyp_stub_vectors
 	add	x0, x0, #:lo12:__hyp_stub_vectors
-- 
2.1.4
