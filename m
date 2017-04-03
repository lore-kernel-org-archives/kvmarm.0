From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 31/34] arm64: hyp-stub/KVM: Kill __hyp_get_vectors
Date: Mon,  3 Apr 2017 19:38:04 +0100
Message-ID: <20170403183807.1620-32-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B54F40C5A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AOxi3x8nMLlg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:37:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 153A340C8A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:19 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

Nobody is using __hyp_get_vectors anymore, so let's remove both
implementations (hyp-stub and KVM).

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/virt.h | 12 ++++--------
 arch/arm64/kernel/hyp-stub.S  | 13 +------------
 arch/arm64/kvm/hyp-init.S     |  7 +------
 arch/arm64/kvm/hyp.S          |  2 +-
 4 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 435514c52b0f..c5f89442785c 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -29,28 +29,25 @@
  * indirection of a function call (as implemented in hyp-stub.S).
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
 
 /* Error returned when an invalid stub number is passed into x0 */
 #define HVC_STUB_ERR	0xbadca11
@@ -77,7 +74,6 @@
 extern u32 __boot_cpu_mode[2];
 
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
-phys_addr_t __hyp_get_vectors(void);
 void __hyp_reset_vectors(void);
 
 /* Reports the availability of HYP mode */
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 8226fd90f73c..d55604d91e33 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -55,12 +55,7 @@ ENDPROC(__hyp_stub_vectors)
 	.align 11
 
 el1_sync:
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
@@ -118,12 +113,6 @@ ENDPROC(\label)
  * initialisation entry point.
  */
 
-ENTRY(__hyp_get_vectors)
-	mov	x0, #HVC_GET_VECTORS
-	hvc	#0
-	ret
-ENDPROC(__hyp_get_vectors)
-
 ENTRY(__hyp_set_vectors)
 	mov	x1, x0
 	mov	x0, #HVC_SET_VECTORS
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 0ad34fd6d2fc..3734e6315cd7 100644
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
index f6f20b58d65a..952f6cb9cf72 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -36,7 +36,7 @@
  * passed in x0.
  *
  * A function pointer with a value less than 0xfff has a special meaning,
- * and is used to implement __hyp_get_vectors in the same way as in
+ * and is used to implement hyp stubs in the same way as in
  * arch/arm64/kernel/hyp_stub.S.
  */
 ENTRY(__kvm_call_hyp)
-- 
2.11.0
