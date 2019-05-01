From: Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/5] KVM: arm/arm64: Introduce helpers for page table enties
 with contiguous bit
Date: Wed, 1 May 2019 09:44:23 +0000
Message-ID: <1556703867-22396-2-git-send-email-yuzenghui@huawei.com>
References: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E6F64A4F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9iijdCnx1Z8X for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 05:48:17 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9970B4A4DE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 05:48:17 -0400 (EDT)
In-Reply-To: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk
List-Id: kvmarm@lists.cs.columbia.edu

Introduce helpers to manipulate stage2 page table entries - set contiguous
bit in the entry and say whether this entry points to a contiguous block.

The helpers are introduced in preparation for supporting contiguous
hugepages at stage2.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 22 ++++++++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 20 ++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 31de4ab..80d73ae 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -143,6 +143,28 @@ static inline bool kvm_s2pud_young(pud_t pud)
 	return false;
 }
 
+static inline pte_t kvm_s2pte_mkcont(pte_t pte)
+{
+	BUG();
+	return pte;
+}
+
+static inline bool kvm_s2pte_cont(pte_t pte)
+{
+	return false;
+}
+
+static inline pmd_t kvm_s2pmd_mkcont(pmd_t pmd)
+{
+	BUG();
+	return pmd;
+}
+
+static inline bool kvm_s2pmd_cont(pmd_t pmd)
+{
+	return false;
+}
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ebeefcf..4afdad9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -295,6 +295,26 @@ static inline bool kvm_s2pud_young(pud_t pud)
 	return pud_young(pud);
 }
 
+static inline pte_t kvm_s2pte_mkcont(pte_t pte)
+{
+	return pte_mkcont(pte);
+}
+
+static inline bool kvm_s2pte_cont(pte_t pte)
+{
+	return pte_cont(pte);
+}
+
+static inline pmd_t kvm_s2pmd_mkcont(pmd_t pmd)
+{
+	return pmd_mkcont(pmd);
+}
+
+static inline bool kvm_s2pmd_cont(pmd_t pmd)
+{
+	return !!(pmd_val(pmd) & PMD_SECT_CONT);
+}
+
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
-- 
1.8.3.1
