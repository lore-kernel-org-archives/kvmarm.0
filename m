From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 24/25] arm64: hyp-stub/KVM: Kill __hyp_get_vectors
Date: Mon,  6 Mar 2017 14:24:57 +0000
Message-ID: <20170306142458.8875-25-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52ED340A42
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c6gLBU5ovrFY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:25:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F7740A80
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:37 -0500 (EST)
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

Nobody is using __hyp_get_vectors anymore, so let's remove both
implementations (hyp-stub and KVM).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/virt.h | 12 ++++--------
 arch/arm64/kernel/hyp-stub.S  | 15 +--------------
 arch/arm64/kvm/hyp-init.S     |  7 +------
 arch/arm64/kvm/hyp.S          |  2 +-
 4 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index f24f1eb72dc0..a7c9dfdd6430 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -24,28 +24,25 @@
  * Any other value is used as a pointer to the function to call.
  */
 
-/* HVC_GET_VECTORS - Return the value of the vbar_el2 register. */
-#define HVC_GET_VECTORS 0
-
 /*
  * HVC_SET_VECTORS - Set the value of the vbar_el2 register.
  *
  * @x1: Physical address of the new vector table.
  */
-#define HVC_SET_VECTORS 1
+#define HVC_SET_VECTORS 0
 
 /*
  * HVC_SOFT_RESTART - CPU soft reset, used by the cpu_soft_restart routine.
  */
-#define HVC_SOFT_RESTART 2
+#define HVC_SOFT_RESTART 1
 
 /*
  * HVC_RESET_VECTORS - Restore the vectors to the original HYP stubs
  */
-#define HVC_RESET_VECTORS 3
+#define HVC_RESET_VECTORS 2
 
 /* Max number of HYP stub hypercalls */
-#define HVC_STUB_HCALL_NR 4
+#define HVC_STUB_HCALL_NR 3
 
 #define BOOT_CPU_MODE_EL1	(0xe11)
 #define BOOT_CPU_MODE_EL2	(0xe12)
@@ -69,7 +66,6 @@
 extern u32 __boot_cpu_mode[2];
 
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
-phys_addr_t __hyp_get_vectors(void);
 void __hyp_reset_vectors(void);
 
 /* Reports the availability of HYP mode */
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index a162182d5662..8ccdd549f7c7 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -61,12 +61,7 @@ el1_sync:
 	cmp	x30, #ESR_ELx_EC_HVC64
 	b.ne	9f				// Not an HVC trap
 
-	cmp	x0, #HVC_GET_VECTORS
-	b.ne	1f
-	mrs	x0, vbar_el2
-	b	9f
-
-1:	cmp	x0, #HVC_SET_VECTORS
+	cmp	x0, #HVC_SET_VECTORS
 	b.ne	2f
 	msr	vbar_el2, x1
 	b	9f
@@ -124,14 +119,6 @@ ENDPROC(\label)
  * initialisation entry point.
  */
 
-ENTRY(__hyp_get_vectors)
-	str	lr, [sp, #-16]!
-	mov	x0, #HVC_GET_VECTORS
-	hvc	#0
-	ldr	lr, [sp], #16
-	ret
-ENDPROC(__hyp_get_vectors)
-
 ENTRY(__hyp_set_vectors)
 	str	lr, [sp, #-16]!
 	mov	x1, x0
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 128d6e9732b9..cf01cdb8bc61 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -124,12 +124,7 @@ __do_hyp_init:
 ENDPROC(__kvm_hyp_init)
 
 ENTRY(__kvm_handle_stub_hvc)
-	cmp	x0, #HVC_GET_VECTORS
-	b.ne	1f
-	mrs	x0, vbar_el2
-	b	exit
-
-1:	cmp	x0, #HVC_SOFT_RESTART
+	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
 
 	/* This is where we're about to jump, staying at EL2 */
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 2726635dceba..09391cf0c93c 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -36,7 +36,7 @@
  * passed in x0.
  *
  * A function pointer with a value less than 0xfff has a special meaning,
- * and is used to implement __hyp_get_vectors in the same way as in
+ * and is used to implement hyp stubs in the same way as in
  * arch/arm64/kernel/hyp_stub.S.
  * HVC behaves as a 'bl' call and will clobber lr.
  */
-- 
2.11.0
