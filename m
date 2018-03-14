From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v6 20/26] arm64: KVM: Move BP hardening vectors into .hyp.text
 section
Date: Wed, 14 Mar 2018 16:50:43 +0000
Message-ID: <20180314165049.30105-21-marc.zyngier@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E08C49FEF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Mar 2018 12:47:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nImyK66UpNiq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Mar 2018 12:46:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6053F49FA9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Mar 2018 12:44:16 -0400 (EDT)
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

There is no reason why the BP hardening vectors shouldn't be part
of the HYP text at compile time, rather than being mapped at runtime.

Also introduce a new config symbol that controls the compilation
of bpi.S.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 4 +---
 arch/arm64/kernel/Makefile       | 4 +---
 arch/arm64/kernel/bpi.S          | 6 ++++++
 arch/arm64/kvm/Kconfig           | 3 +++
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index bfb81e73da06..c2beb2d25170 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -380,9 +380,7 @@ static inline void *kvm_get_hyp_vector(void)
 
 static inline int kvm_map_vectors(void)
 {
-	return create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
-				   kvm_ksym_ref(__bp_harden_hyp_vecs_end),
-				   PAGE_HYP_EXEC);
+	return 0;
 }
 
 #else
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index b87541360f43..93bce17109a6 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -54,9 +54,7 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
 arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
 arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
 
-ifeq ($(CONFIG_KVM),y)
-arm64-obj-$(CONFIG_HARDEN_BRANCH_PREDICTOR)	+= bpi.o
-endif
+arm64-obj-$(CONFIG_KVM_INDIRECT_VECTORS)+= bpi.o
 
 obj-y					+= $(arm64-obj-y) vdso/ probes/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index e5de33513b5d..447188e2a664 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -48,6 +48,10 @@
 	ventry \target + 0x780
 .endm
 
+
+	.text
+	.pushsection	.hyp.text, "ax"
+
 	.align	11
 ENTRY(__bp_harden_hyp_vecs_start)
 	.rept 4
@@ -55,6 +59,8 @@ ENTRY(__bp_harden_hyp_vecs_start)
 	.endr
 ENTRY(__bp_harden_hyp_vecs_end)
 
+	.popsection
+
 ENTRY(__qcom_hyp_sanitize_link_stack_start)
 	stp     x29, x30, [sp, #-16]!
 	.rept	16
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 2257dfcc44cc..bd8cc03d7522 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -57,6 +57,9 @@ config KVM_ARM_PMU
 	  Adds support for a virtual Performance Monitoring Unit (PMU) in
 	  virtual machines.
 
+config KVM_INDIRECT_VECTORS
+       def_bool KVM && HARDEN_BRANCH_PREDICTOR
+
 source drivers/vhost/Kconfig
 
 endif # VIRTUALIZATION
-- 
2.14.2
