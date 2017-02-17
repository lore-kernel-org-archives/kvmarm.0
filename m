From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/20] arm64: hyp-stub: Implement HVC_RESET_VECTORS stub hypercall
Date: Fri, 17 Feb 2017 15:44:10 +0000
Message-ID: <20170217154429.5000-2-marc.zyngier@arm.com>
References: <20170217154429.5000-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170217154429.5000-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Let's define a new stub hypercall that resets the HYP configuration
to its default: hyp-stub vectors, and MMU disabled.

Of course, for the hyp-stub itself, this is a trivial no-op.
Hypervisors will have a bit more work to do.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/virt.h |  8 ++++++++
 arch/arm64/kernel/hyp-stub.S  | 13 ++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 439f6b5d31f6..6d085a4d6cf1 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -39,6 +39,14 @@
  */
 #define HVC_SOFT_RESTART 2
 
+/*
+ * HVC_RESET_VECTORS - Restore the vectors to the original HYP stubs
+ */
+#define HVC_RESET_VECTORS 3
+
+/* Max number of HYP stub hypercalls */
+#define HVC_STUB_HCALL_NR 4
+
 #define BOOT_CPU_MODE_EL1	(0xe11)
 #define BOOT_CPU_MODE_EL2	(0xe12)
 
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index d3b5f75e652e..a162182d5662 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -79,8 +79,11 @@ el1_sync:
 	mov	x1, x3
 	br	x4				// no return
 
+3:	cmp	x0, #HVC_RESET_VECTORS
+	beq	9f				// Nothing to reset!
+
 	/* Someone called kvm_call_hyp() against the hyp-stub... */
-3:	mov	x0, #ARM_EXCEPTION_HYP_GONE
+	mov	x0, #ARM_EXCEPTION_HYP_GONE
 
 9:	eret
 ENDPROC(el1_sync)
@@ -137,3 +140,11 @@ ENTRY(__hyp_set_vectors)
 	ldr	lr, [sp], #16
 	ret
 ENDPROC(__hyp_set_vectors)
+
+ENTRY(__hyp_reset_vectors)
+	str	lr, [sp, #-16]!
+	mov	x0, #HVC_RESET_VECTORS
+	hvc	#0
+	ldr	lr, [sp], #16
+	ret
+ENDPROC(__hyp_reset_vectors)
-- 
2.11.0
