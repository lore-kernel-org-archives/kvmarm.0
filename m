From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 10/19] KVM: arm/arm64: Do not use kern_hyp_va() with kvm_vgic_global_state
Date: Thu,  4 Jan 2018 18:43:25 +0000
Message-ID: <20180104184334.16571-11-marc.zyngier@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180104184334.16571-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

kvm_vgic_global_state is part of the read-only section, and is
usually accessed using a PC-relative address generation (adrp + add).

It is thus useless to use kern_hyp_va() on it, and actively problematic
if kern_hyp_va() becomes non-idempotent. On the other hand, there is
no way that the compiler is going to guarantee that such access is
always be PC relative.

So let's bite the bullet and provide our own accessor.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_hyp.h   | 6 ++++++
 arch/arm64/include/asm/kvm_hyp.h | 9 +++++++++
 virt/kvm/arm/hyp/vgic-v2-sr.c    | 4 ++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index ab20ffa8b9e7..1d42d0aa2feb 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -26,6 +26,12 @@
 
 #define __hyp_text __section(.hyp.text) notrace
 
+#define hyp_symbol_addr(s)						\
+	({								\
+		typeof(s) *addr = &(s);					\
+		addr;							\
+	})
+
 #define __ACCESS_VFP(CRn)			\
 	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 08d3bb66c8b7..a2d98c539023 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -25,6 +25,15 @@
 
 #define __hyp_text __section(.hyp.text) notrace
 
+#define hyp_symbol_addr(s)						\
+	({								\
+		typeof(s) *addr;					\
+		asm volatile("adrp	%0, %1\n"			\
+			     "add	%0, %0, :lo12:%1\n"		\
+			     : "=r" (addr) : "S" (&s));			\
+		addr;							\
+	})
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index d7fd46fe9efb..4573d0552af3 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -25,7 +25,7 @@
 static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
+	int nr_lr = hyp_symbol_addr(kvm_vgic_global_state)->nr_lr;
 	u32 elrsr0, elrsr1;
 
 	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
@@ -139,7 +139,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
+	addr  = kern_hyp_va(hyp_symbol_addr(kvm_vgic_global_state)->vcpu_base_va);
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-- 
2.14.2
