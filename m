From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 01/12] KVM: arm/arm64: vgic: Remove spurious call to
 kern_hyp_va
Date: Mon,  4 Dec 2017 14:13:02 +0000
Message-ID: <20171204141313.31604-2-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB0ED49D32
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kio3SecJNsUy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:25 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFF6249D1F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:25 -0500 (EST)
In-Reply-To: <20171204141313.31604-1-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org, James Morse <james.morese@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In save_elrsr(.), we use the following technique to ascertain the
address of the vgic global state:
	(kern_hyp_va(&kvm_vgic_global_state))->nr_lr

For arm, kern_hyp_va(va) == va, and this call effectively compiles out.

For arm64, this call can be spurious as the address of kvm_vgic_global_state
will usually be determined by relative page/absolute page offset relocation
at link time. As the function is idempotent, having the call for arm64 does
not cause any problems.

Unfortunately, this is about to change for arm64 as we need to change
the logic of kern_hyp_va to allow for kernel addresses that are outside
the direct linear map.

This patch removes the call to kern_hyp_va, and ensures that correct
HYP addresses are computed via relative page offset addressing on arm64.
This is achieved by a custom accessor, hyp_address(.), which on arm is a
simple reference operator.

Cc: James Morse <james.morese@arm.com>
Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h | 10 ++++++++++
 virt/kvm/arm/hyp/vgic-v2-sr.c    |  4 ++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index ab20ffa8b9e7..1864a9bdd160 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -26,6 +26,8 @@
 
 #define __hyp_text __section(.hyp.text) notrace
 
+#define hyp_address(symbol)	(&(symbol))
+
 #define __ACCESS_VFP(CRn)			\
 	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 08d3bb66c8b7..34a4ae906a97 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -25,6 +25,16 @@
 
 #define __hyp_text __section(.hyp.text) notrace
 
+#define hyp_address(symbol)				\
+({							\
+	typeof(&symbol) __ret;				\
+	asm volatile(					\
+	"adrp %[ptr], " #symbol	"\n"			\
+	"add %[ptr], %[ptr], :lo12:" #symbol "\n"	\
+	: [ptr] "=r"(__ret));				\
+	__ret;						\
+})
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a3f18d362366..330fd4637708 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -25,7 +25,7 @@
 static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
+	int nr_lr = hyp_address(kvm_vgic_global_state)->nr_lr;
 	u32 elrsr0, elrsr1;
 
 	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
@@ -143,7 +143,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
+	addr  = kern_hyp_va(hyp_address(kvm_vgic_global_state)->vcpu_base_va);
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-- 
2.11.0
