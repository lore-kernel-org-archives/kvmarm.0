From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 08/17] kvm-arm: arm: Introduce hyp page table empty checks
Date: Mon,  4 Apr 2016 17:26:08 +0100
Message-ID: <1459787177-12767-9-git-send-email-suzuki.poulose@arm.com>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E50A541267
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pq7JX+vjbQ8K for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 12:25:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1103840B40
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:43 -0400 (EDT)
In-Reply-To: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Introduce hyp_pxx_table_empty helpers for checking whether
a given table entry is empty. This will be used explicitly
once we switch to explicit routines for hyp page table walk.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 7d207b4..901c1ea 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -162,6 +162,10 @@ static inline bool kvm_page_empty(void *ptr)
 #define kvm_pmd_table_empty(kvm, pmdp) kvm_page_empty(pmdp)
 #define kvm_pud_table_empty(kvm, pudp) (0)
 
+#define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
+#define hyp_pmd_table_empty(pmdp) kvm_page_empty(pmdp)
+#define hyp_pud_table_empty(pudp) (0)
+
 static inline void *kvm_get_hwpgd(struct kvm *kvm)
 {
 	return kvm->arch.pgd;
-- 
1.7.9.5
