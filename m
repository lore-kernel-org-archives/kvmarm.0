From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 3/3] kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd
Date: Thu, 16 Mar 2017 18:20:51 +0000
Message-ID: <1489688451-17520-4-git-send-email-suzuki.poulose@arm.com>
References: <1489688451-17520-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8336240B5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 14:19:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vOGq3OvouZkm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 14:19:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D81040C28
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 14:19:30 -0400 (EDT)
In-Reply-To: <1489688451-17520-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, andreyknvl@google.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while calling
unmap_stage2_range() on the entire memory range for the guest. This could
cause problems with other callers (e.g, munmap on a memslot) trying to
unmap a range. And since we have to unmap the entire Guest memory range
holding a spinlock, make sure we yield the lock if necessary, after we
unmap each PUD range.

Fixes: commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
Cc: stable@vger.kernel.org # v3.10+
Cc: Paolo Bonzini <pbonzin@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[ Avoid vCPU starvation and lockup detector warnings ]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 13b9c1f..7628ef1 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -292,8 +292,14 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 	phys_addr_t addr = start, end = start + size;
 	phys_addr_t next;
 
+	assert_spin_locked(&kvm->mmu_lock);
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
+		/*
+		 * If the range is too large, release the kvm->mmu_lock
+		 * to prevent starvation and lockup detector warnings.
+		 */
+		cond_resched_lock(&kvm->mmu_lock);
 		next = stage2_pgd_addr_end(addr, end);
 		if (!stage2_pgd_none(*pgd))
 			unmap_stage2_puds(kvm, pgd, addr, next);
@@ -831,7 +837,10 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	if (kvm->arch.pgd == NULL)
 		return;
 
+	spin_lock(&kvm->mmu_lock);
 	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+	spin_unlock(&kvm->mmu_lock);
+
 	/* Free the HW pgd, one page at a time */
 	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
 	kvm->arch.pgd = NULL;
-- 
2.7.4
