From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 59/85] KVM: arm/arm64: Do not use kern_hyp_va() with
 kvm_vgic_global_state
Date: Wed, 28 Mar 2018 13:52:28 +0100
Message-ID: <20180328125254.31380-60-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E75040170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:55:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WzkND+rgsLAq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:55:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0546D4A0BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:01 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

kvm_vgic_global_state is part of the read-only section, and is
usually accessed using a PC-relative address generation (adrp + add).

It is thus useless to use kern_hyp_va() on it, and actively problematic
if kern_hyp_va() becomes non-idempotent. On the other hand, there is
no way that the compiler is going to guarantee that such access is
always PC relative.

So let's bite the bullet and provide our own accessor.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h           |  7 +++++++
 arch/arm64/include/asm/kvm_mmu.h         | 20 ++++++++++++++++++++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index de1b919404e4..93395b7c2322 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -28,6 +28,13 @@
  */
 #define kern_hyp_va(kva)	(kva)
 
+/* Contrary to arm64, there is no need to generate a PC-relative address */
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
index 0656c79d968f..021d3a8117a8 100644
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
+		asm("adrp	%0, %1\n"				\
+		    "add	%0, %0, :lo12:%1\n"			\
+		    : "=r" (addr) : "S" (&s));				\
+		addr;							\
+	})
+
 /*
  * We currently only support a 40bit IPA.
  */
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 97f357ea9c72..10eb2e96b3e6 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -60,7 +60,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
+	addr  = kern_hyp_va(hyp_symbol_addr(kvm_vgic_global_state)->vcpu_base_va);
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-- 
2.14.2
