From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 04/14] ARM: KVM: Teach some form of type-safety to kvm_call_hyp
Date: Thu, 24 Jan 2019 15:00:22 +0100
Message-ID: <20190124140032.8588-5-christoffer.dall@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 097A44A3A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5dhmUgeymk2D for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 09:00:46 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 750C84A3F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:46 -0500 (EST)
In-Reply-To: <20190124140032.8588-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Just like on arm64, and for the same reasons, kvm_call_hyp removes
any form of type safety when calling into HYP. But we can still
try to tell the compiler what we're trying to achieve.

Here, we can add code that would do the function call if it wasn't
guarded by an always-false predicate. Hopefully, the compiler is
dumb enough to do the type checking and clever enough to not emit
the corresponding code...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/kvm_host.h | 31 ++++++++++++++++++++++++++++---
 arch/arm/kvm/hyp/hyp-entry.S    |  2 +-
 arch/arm/kvm/interrupts.S       |  4 ++--
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 023c9f2b1eea..4b6193f2f0f6 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -215,8 +215,33 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 
-unsigned long kvm_call_hyp(void *hypfn, ...);
-#define kvm_call_hyp_ret(f, ...) kvm_call_hyp(f, ##__VA_ARGS__)
+unsigned long __kvm_call_hyp(void *hypfn, ...);
+
+/*
+ * The has_vhe() part doesn't get emitted, but is used for type-checking.
+ */
+#define kvm_call_hyp(f, ...)						\
+	do {								\
+		if (has_vhe()) {					\
+			f(__VA_ARGS__);					\
+		} else {						\
+			__kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__); \
+		}							\
+	} while(0)
+
+#define kvm_call_hyp_ret(f, ...)					\
+	({								\
+		typeof(f(__VA_ARGS__)) ret;				\
+									\
+		if (has_vhe()) {					\
+			ret = f(__VA_ARGS__);				\
+		} else {						\
+			ret = __kvm_call_hyp(kvm_ksym_ref(f),		\
+					     ##__VA_ARGS__);		\
+		}							\
+									\
+		ret;							\
+	})
 
 void force_vm_exit(const cpumask_t *mask);
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
@@ -268,7 +293,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	 * compliant with the PCS!).
 	 */
 
-	kvm_call_hyp((void*)hyp_stack_ptr, vector_ptr, pgd_ptr);
+	__kvm_call_hyp((void*)hyp_stack_ptr, vector_ptr, pgd_ptr);
 }
 
 static inline void __cpu_init_stage2(void)
diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index aa3f9a9837ac..6ed3cf23fe89 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -176,7 +176,7 @@ THUMB(	orr	lr, lr, #PSR_T_BIT	)
 	msr	spsr_cxsf, lr
 	ldr	lr, =panic
 	msr	ELR_hyp, lr
-	ldr	lr, =kvm_call_hyp
+	ldr	lr, =__kvm_call_hyp
 	clrex
 	eret
 ENDPROC(__hyp_do_panic)
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 80a1d6cd261c..a08e6419ebe9 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -42,7 +42,7 @@
  *   r12:     caller save
  *   rest:    callee save
  */
-ENTRY(kvm_call_hyp)
+ENTRY(__kvm_call_hyp)
 	hvc	#0
 	bx	lr
-ENDPROC(kvm_call_hyp)
+ENDPROC(__kvm_call_hyp)
-- 
2.18.0
