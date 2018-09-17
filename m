From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 02/18] kvm: arm/arm64: Remove spurious WARN_ON
Date: Mon, 17 Sep 2018 11:41:24 +0100
Message-ID: <20180917104144.19188-3-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99C354A0C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:42:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9hzg20U4AKu8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Sep 2018 06:42:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 900C74A260
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:42:28 -0400 (EDT)
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
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
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On a 4-level page table pgd entry can be empty, unlike a 3-level
page table. Remove the spurious WARN_ON() in stage_get_pud().

Acked-by: Christoffer Dall <cdall@kernel.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ee7ce8fa4a12..4a285d760ce0 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1005,7 +1005,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pud_t *pud;
 
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
-	if (WARN_ON(stage2_pgd_none(*pgd))) {
+	if (stage2_pgd_none(*pgd)) {
 		if (!cache)
 			return NULL;
 		pud = mmu_memory_cache_alloc(cache);
-- 
2.19.0
