From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 01/25] arm64: hyp-stub: Implement HVC_RESET_VECTORS stub
 hypercall
Date: Mon,  6 Mar 2017 14:24:34 +0000
Message-ID: <20170306142458.8875-2-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E15E40BE4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WNtjU6fwdXvO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:24:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E4E240C27
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:43 -0500 (EST)
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

Let's define a new stub hypercall that resets the HYP configuration
to its default: hyp-stub vectors, and MMU disabled.

Of course, for the hyp-stub itself, this is a trivial no-op.
Hypervisors will have a bit more work to do.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/virt.h |  9 +++++++++
 arch/arm64/kernel/hyp-stub.S  | 13 ++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 439f6b5d31f6..f24f1eb72dc0 100644
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
 
@@ -62,6 +70,7 @@ extern u32 __boot_cpu_mode[2];
 
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
 phys_addr_t __hyp_get_vectors(void);
+void __hyp_reset_vectors(void);
 
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
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
