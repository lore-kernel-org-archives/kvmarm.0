From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 77/85] arm64: Make BP hardening slot counter available
Date: Wed, 28 Mar 2018 13:52:46 +0100
Message-ID: <20180328125254.31380-78-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B60CE40357
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:01:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cf-mBJGWqww7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 09:00:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D7F49FD7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:13 -0400 (EDT)
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

We're about to need to allocate hardening slots from other parts
of the kernel (in order to support ARM64_HARDEN_EL2_VECTORS).

Turn the counter into an atomic_t and make it available to the
rest of the kernel. Also add BP_HARDEN_EL2_SLOTS as the number of
slots instead of the hardcoded 4...

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/mmu.h   | 3 +++
 arch/arm64/kernel/bpi.S        | 3 ++-
 arch/arm64/kernel/cpu_errata.c | 9 ++++-----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index a050d4f3615d..3baf010fe883 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -21,6 +21,8 @@
 #define USER_ASID_FLAG	(UL(1) << USER_ASID_BIT)
 #define TTBR_ASID_MASK	(UL(0xffff) << 48)
 
+#define BP_HARDEN_EL2_SLOTS 4
+
 #ifndef __ASSEMBLY__
 
 typedef struct {
@@ -51,6 +53,7 @@ struct bp_hardening_data {
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 extern char __bp_harden_hyp_vecs_start[], __bp_harden_hyp_vecs_end[];
+extern atomic_t arm64_el2_vector_last_slot;
 
 DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index dc51ef2ce98a..bb0b67722e86 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -20,6 +20,7 @@
 #include <linux/arm-smccc.h>
 
 #include <asm/alternative.h>
+#include <asm/mmu.h>
 
 .macro hyp_ventry
 	.align 7
@@ -66,7 +67,7 @@ alternative_cb_end
 
 	.align	11
 ENTRY(__bp_harden_hyp_vecs_start)
-	.rept 4
+	.rept BP_HARDEN_EL2_SLOTS
 	generate_vectors
 	.endr
 ENTRY(__bp_harden_hyp_vecs_end)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 52f15cd896e1..8cf6b60a085a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -60,6 +60,8 @@ static int cpu_enable_trap_ctr_access(void *__unused)
 	return 0;
 }
 
+atomic_t arm64_el2_vector_last_slot = ATOMIC_INIT(-1);
+
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
@@ -90,7 +92,6 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
 				      const char *hyp_vecs_end)
 {
-	static int last_slot = -1;
 	static DEFINE_SPINLOCK(bp_lock);
 	int cpu, slot = -1;
 
@@ -103,10 +104,8 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 	}
 
 	if (slot == -1) {
-		last_slot++;
-		BUG_ON(((__bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start)
-			/ SZ_2K) <= last_slot);
-		slot = last_slot;
+		slot = atomic_inc_return(&arm64_el2_vector_last_slot);
+		BUG_ON(slot >= BP_HARDEN_EL2_SLOTS);
 		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
 	}
 
-- 
2.14.2
