From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/31] arm/arm64: KVM: Remove unreferenced S2_PGD_ORDER
Date: Thu, 24 Dec 2015 11:12:35 +0000
Message-ID: <1450955559-15639-28-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC5340FA2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Dec 2015 06:12:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8DO+nYpmiDqM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Dec 2015 06:12:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83516498C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Dec 2015 06:12:24 -0500 (EST)
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jisheng Zhang <jszhang@marvell.com>, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

Since commit a987370 ("arm64: KVM: Fix stage-2 PGD allocation to have
per-page refcounting") there is no reference to S2_PGD_ORDER, so kill it
for the good.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_arm.h   | 1 -
 arch/arm/kvm/mmu.c               | 6 +++---
 arch/arm64/include/asm/kvm_mmu.h | 1 -
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index dc641dd..b05bb5a 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -135,7 +135,6 @@
 #define KVM_PHYS_SIZE	(1ULL << KVM_PHYS_SHIFT)
 #define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1ULL)
 #define PTRS_PER_S2_PGD	(1ULL << (KVM_PHYS_SHIFT - 30))
-#define S2_PGD_ORDER	get_order(PTRS_PER_S2_PGD * sizeof(pgd_t))
 
 /* Virtualization Translation Control Register (VTCR) bits */
 #define VTCR_SH0	(3 << 12)
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 61d96a6..22f7fa0 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -656,9 +656,9 @@ static void *kvm_alloc_hwpgd(void)
  * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
  * @kvm:	The KVM struct pointer for the VM.
  *
- * Allocates the 1st level table only of size defined by S2_PGD_ORDER (can
- * support either full 40-bit input addresses or limited to 32-bit input
- * addresses). Clears the allocated pages.
+ * Allocates only the stage-2 HW PGD level table(s) (can support either full
+ * 40-bit input addresses or limited to 32-bit input addresses). Clears the
+ * allocated pages.
  *
  * Note we don't need locking here as this is only called when the VM is
  * created, which can only be done once.
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6150567..54cba80 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -158,7 +158,6 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 #define PTRS_PER_S2_PGD_SHIFT	(KVM_PHYS_SHIFT - PGDIR_SHIFT)
 #endif
 #define PTRS_PER_S2_PGD		(1 << PTRS_PER_S2_PGD_SHIFT)
-#define S2_PGD_ORDER		get_order(PTRS_PER_S2_PGD * sizeof(pgd_t))
 
 #define kvm_pgd_index(addr)	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_S2_PGD - 1))
 
-- 
2.1.4
