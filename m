From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v6 06/26] KVM: arm/arm64: Do not use kern_hyp_va() with
 kvm_vgic_global_state
Date: Wed, 14 Mar 2018 16:50:29 +0000
Message-ID: <20180314165049.30105-7-marc.zyngier@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9860B49FF2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Mar 2018 12:44:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2CgP6U3RxMFi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Mar 2018 12:43:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7479549FA9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Mar 2018 12:43:43 -0400 (EDT)
In-Reply-To: <20180314165049.30105-1-marc.zyngier@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

kvm_vgic_global_state is part of the read-only section, and is
usually accessed using a PC-relative address generation (adrp + add).

It is thus useless to use kern_hyp_va() on it, and actively problematic
if kern_hyp_va() becomes non-idempotent. On the other hand, there is
no way that the compiler is going to guarantee that such access is
always PC relative.

So let's bite the bullet and provide our own accessor.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  7 +++++++
 arch/arm64/include/asm/kvm_mmu.h | 20 ++++++++++++++++++++
 virt/kvm/arm/hyp/vgic-v2-sr.c    |  4 ++--
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index de1b919404e4..a6808d2869f5 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -28,6 +28,13 @@
  */
 #define kern_hyp_va(kva)	(kva)
 
+/* Resolving symbol addresses in a PC-relative way is easy... */
+#define hyp_symbol_addr(s)						\
+	({								\
+		typeof(s) *addr = &(s);					\
+		addr;							\
+	})
+
 /*
  * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
  */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e3bc1d0a5e93..7120bf3f22c7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -110,6 +110,26 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
 
+/*
+ * Obtain the PC-relative address of a kernel symbol
+ * s: symbol
+ *
+ * The goal of this macro is to return a symbol's address based on a
+ * PC-relative computation, as opposed to a loading the VA from a
+ * constant pool or something similar. This works well for HYP, as an
+ * absolute VA is guaranteed to be wrong. Only use this if trying to
+ * obtain the address of a symbol (i.e. not something you obtained by
+ * following a pointer).
+ */
+#define hyp_symbol_addr(s)						\
+	({								\
+		typeof(s) *addr;					\
+		asm volatile("adrp	%0, %1\n"			\
+			     "add	%0, %0, :lo12:%1\n"		\
+			     : "=r" (addr) : "S" (&s));			\
+		addr;							\
+	})
+
 /*
  * We currently only support a 40bit IPA.
  */
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 4fe6e797e8b3..a6ca049d9651 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -26,7 +26,7 @@
 static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
+	int nr_lr = hyp_symbol_addr(kvm_vgic_global_state)->nr_lr;
 	u32 elrsr0, elrsr1;
 
 	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
@@ -140,7 +140,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
+	addr  = kern_hyp_va(hyp_symbol_addr(kvm_vgic_global_state)->vcpu_base_va);
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-- 
2.14.2
