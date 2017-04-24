From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 2/2] kvm: arm/arm64: Fix race in resetting stage2 PGD
Date: Mon, 24 Apr 2017 11:10:24 +0100
Message-ID: <1493028624-29837-3-git-send-email-suzuki.poulose@arm.com>
References: <1493028624-29837-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEA7E43C7F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 06:09:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vCZgb5hUYC1V for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Apr 2017 06:09:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCE3040DFB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 06:09:28 -0400 (EDT)
In-Reply-To: <1493028624-29837-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andreyknvl@google.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In kvm_free_stage2_pgd() we check the stage2 PGD before holding
the lock and proceed to take the lock if it is valid. And we unmap
the page tables, followed by releasing the lock. We reset the PGD
only after dropping this lock, which could cause a race condition
where another thread waiting on the lock could potentially see that
the PGD is still valid and proceed to perform a stage2 operation.

This patch moves the stage2 PGD manipulation under the lock.

Reported-by: Alexander Graf <agraf@suse.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 582a972..9c4026d 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -835,16 +835,18 @@ void stage2_unmap_vm(struct kvm *kvm)
  */
 void kvm_free_stage2_pgd(struct kvm *kvm)
 {
-	if (kvm->arch.pgd == NULL)
-		return;
+	void *pgd = NULL;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+	if (kvm->arch.pgd) {
+		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+		pgd = kvm->arch.pgd;
+		kvm->arch.pgd = NULL;
+	}
 	spin_unlock(&kvm->mmu_lock);
-
 	/* Free the HW pgd, one page at a time */
-	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
-	kvm->arch.pgd = NULL;
+	if (pgd)
+		free_pages_exact(pgd, S2_PGD_SIZE);
 }
 
 static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
-- 
2.7.4
