From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 51/95] arm64: VHE: Add support for running Linux in EL2 mode
Date: Wed,  9 Mar 2016 07:30:45 +0000
Message-ID: <1457508689-19672-52-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B3F49B37
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mb4EDD98aeRw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:34:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1B049B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:09 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

With ARMv8.1 VHE, the architecture is able to (almost) transparently
run the kernel at EL2, despite being written for EL1.

This patch takes care of the "almost" part, mostly preventing the kernel
from dropping from EL2 to EL1, and setting up the HYP configuration.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
