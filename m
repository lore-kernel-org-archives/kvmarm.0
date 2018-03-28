From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 64/85] KVM: arm64: Fix HYP idmap unmap when using 52bit PA
Date: Wed, 28 Mar 2018 13:52:33 +0100
Message-ID: <20180328125254.31380-65-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 406E849FF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:59:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k10Xb3+xTXdc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:58:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 368D349FC7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:21 -0400 (EDT)
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

Unmapping the idmap range using 52bit PA is quite broken, as we
don't take into account the right number of PGD entries, and rely
on PTRS_PER_PGD. The result is that pgd_index() truncates the
address, and we end-up in the weed.

Let's introduce a new unmap_hyp_idmap_range() that knows about this,
together with a kvm_pgd_index() helper, which hides a bit of the
complexity of the issue.

Fixes: 98732d1b189b ("KVM: arm/arm64: fix HYP ID map extension to 52 bits")
Reported-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index c41d03a8af93..f7fe724c14f4 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -479,7 +479,13 @@ static void unmap_hyp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 		clear_hyp_pgd_entry(pgd);
 }
 
-static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
+static unsigned int kvm_pgd_index(unsigned long addr, unsigned int ptrs_per_pgd)
+{
+	return (addr >> PGDIR_SHIFT) & (ptrs_per_pgd - 1);
+}
+
+static void __unmap_hyp_range(pgd_t *pgdp, unsigned long ptrs_per_pgd,
+			      phys_addr_t start, u64 size)
 {
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
@@ -489,7 +495,7 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
 	 * We don't unmap anything from HYP, except at the hyp tear down.
 	 * Hence, we don't have to invalidate the TLBs here.
 	 */
-	pgd = pgdp + pgd_index(addr);
+	pgd = pgdp + kvm_pgd_index(addr, ptrs_per_pgd);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (!pgd_none(*pgd))
@@ -497,6 +503,16 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
+{
+	__unmap_hyp_range(pgdp, PTRS_PER_PGD, start, size);
+}
+
+static void unmap_hyp_idmap_range(pgd_t *pgdp, phys_addr_t start, u64 size)
+{
+	__unmap_hyp_range(pgdp, __kvm_idmap_ptrs_per_pgd(), start, size);
+}
+
 /**
  * free_hyp_pgds - free Hyp-mode page tables
  *
@@ -512,13 +528,13 @@ void free_hyp_pgds(void)
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	if (boot_hyp_pgd) {
-		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
+		unmap_hyp_idmap_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
 		boot_hyp_pgd = NULL;
 	}
 
 	if (hyp_pgd) {
-		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
+		unmap_hyp_idmap_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
 				(uintptr_t)high_memory - PAGE_OFFSET);
 		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
@@ -634,7 +650,7 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
 	addr = start & PAGE_MASK;
 	end = PAGE_ALIGN(end);
 	do {
-		pgd = pgdp + ((addr >> PGDIR_SHIFT) & (ptrs_per_pgd - 1));
+		pgd = pgdp + kvm_pgd_index(addr, ptrs_per_pgd);
 
 		if (pgd_none(*pgd)) {
 			pud = pud_alloc_one(NULL, addr);
-- 
2.14.2
