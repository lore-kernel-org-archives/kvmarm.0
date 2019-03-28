From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 8/8] KVM: arm/arm64: Comments cleanup in mmu.c
Date: Thu, 28 Mar 2019 13:36:08 +0000
Message-ID: <20190328133608.110805-9-marc.zyngier@arm.com>
References: <20190328133608.110805-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47B254A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:37:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rMYKNKVKSgGR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 09:36:59 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF314A439
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:58 -0400 (EDT)
In-Reply-To: <20190328133608.110805-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>, Julien Grall <julien.grall@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Zenghui Yu <yuzenghui@huawei.com>

Some comments in virt/kvm/arm/mmu.c are outdated. Update them to
reflect the current state of the code.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[maz: commit message tidy-up]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index f9da2fad9bd6..27c958306449 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -102,8 +102,7 @@ static bool kvm_is_device_pfn(unsigned long pfn)
  * @addr:	IPA
  * @pmd:	pmd pointer for IPA
  *
- * Function clears a PMD entry, flushes addr 1st and 2nd stage TLBs. Marks all
- * pages in the range dirty.
+ * Function clears a PMD entry, flushes addr 1st and 2nd stage TLBs.
  */
 static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
 {
@@ -121,8 +120,7 @@ static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
  * @addr:	IPA
  * @pud:	pud pointer for IPA
  *
- * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs. Marks all
- * pages in the range dirty.
+ * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs.
  */
 static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
 {
@@ -899,9 +897,8 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
  * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
  * @kvm:	The KVM struct pointer for the VM.
  *
- * Allocates only the stage-2 HW PGD level table(s) (can support either full
- * 40-bit input addresses or limited to 32-bit input addresses). Clears the
- * allocated pages.
+ * Allocates only the stage-2 HW PGD level table(s) of size defined by
+ * stage2_pgd_size(kvm).
  *
  * Note we don't need locking here as this is only called when the VM is
  * created, which can only be done once.
@@ -1478,13 +1475,11 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
 }
 
 /**
-  * stage2_wp_puds - write protect PGD range
-  * @pgd:	pointer to pgd entry
-  * @addr:	range start address
-  * @end:	range end address
-  *
-  * Process PUD entries, for a huge PUD we cause a panic.
-  */
+ * stage2_wp_puds - write protect PGD range
+ * @pgd:	pointer to pgd entry
+ * @addr:	range start address
+ * @end:	range end address
+ */
 static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
 			    phys_addr_t addr, phys_addr_t end)
 {
-- 
2.20.1
